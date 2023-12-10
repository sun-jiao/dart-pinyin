import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_proxy_adapter/dio_proxy_adapter.dart';

void main() async {
  Dio dio = Dio();
  dio.useProxy(
      bool.hasEnvironment('HTTP_PROXY') ?
      String.fromEnvironment('HTTP_PROXY') : '127.0.0.1:7890');

  var output = File('./dev/temp/pinyin_output_${DateTime.now().toIso8601String()}.csv').openWrite();

  final blocks = [
    MapEntry(0x3400, 0x4DBF),
    MapEntry(0x9FA6, 0x9FFF),
    MapEntry(0xF900, 0xFA6D),
    MapEntry(0xFA70, 0xFAD9),
    MapEntry(0x20000, 0x2A6DF),
    MapEntry(0x2A700, 0x2B73F),
    MapEntry(0x2B740, 0x2B81F),
    MapEntry(0x2B820, 0x2CEAF),
    MapEntry(0x2CEB0, 0x2EBEF),
    MapEntry(0x2EBF0, 0x2EE5D),
    MapEntry(0x2F800, 0x2FA1F),
    MapEntry(0x30000, 0x3134F),
    MapEntry(0x31350, 0x323AF),
  ];

  for (var block in blocks) {
    await for (var result in query(dio, block.key, block.value)) {
      print(result);
      output.writeln(result.join('\t'));
    }
  }

  await output.close();
}

Stream<List<dynamic>> query(Dio dio, int start, int end) async* {
  var baseArgs = {
    'action': 'query',
    'prop': 'revisions',
    'rvslots': '*',
    'rvprop': 'content',
    'formatversion': 2,
    'format': 'json',
  };

  for (int i = start; i <= end; i++) {
    final char = String.fromCharCode(i);
    try {
      final args = Map<String, dynamic>.from(baseArgs);
      args['titles'] = char;

      var response = await dio.get('https://en.wiktionary.org/w/api.php', queryParameters: args);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = jsonDecode(response.toString());

        var content = jsonMap['query']['pages'][0]['revisions'][0]['slots']['main']['content'];

        var zhSeeMatch = RegExp(r'\{\{zh-see\|([^}]*)(\|[A-Za-z]*\}\}|\}\})').allMatches(content).map((e) => e.group(1)).join(',');
        var zhPronMatch = RegExp(r'\{\{zh-pron[^\}]*\|m=([^|\n]*)').allMatches(content).map((e) => e.group(1)).join(',');

        yield [i, char, zhPronMatch, zhSeeMatch];
      } else {
        yield [i, char, 'error', 'error'];
      }
    } catch (e, s) {
      print(e);
      print(s);
      yield [i, char, 'error', 'error'];
    }
  }
}

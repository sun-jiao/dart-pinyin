import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

void main() async {
  Dio dio = Dio();

  var output = File('./dev/temp/wikt_ids_output_${DateTime.now().toIso8601String()}.csv').openWrite();

  final blocks = [
    // MapEntry(0x3400, 0x4DBF),
    MapEntry(0x9FF0, 0x9FFF), //
    MapEntry(0xFA0E, 0xFA6D), // 兼容
    MapEntry(0xFA70, 0xFAD9),
    MapEntry(0x2A6D7, 0x2A6DF),
    MapEntry(0x2B735, 0x2B73F),
    // MapEntry(0x2B740, 0x2B81F),
    MapEntry(0x2CEA2, 0x2CEAF),
    MapEntry(0x2EBE1, 0x2EBEF),
    MapEntry(0x2EBF0, 0x2EE5D),
    MapEntry(0x2FA1E, 0x2FA1F), // 兼容补充
    MapEntry(0x3134B, 0x3134F),
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

      var response = await dio.get('https://zh.wiktionary.org/w/api.php', queryParameters: args);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = jsonDecode(response.toString());

        var content = jsonMap['query']['pages'][0]['revisions'][0]['slots']['main']['content'];

        var zhSeeMatch = RegExp(r'ids=(.+)(\||\}\})')
            .allMatches(content)
            .map((e) => e.group(1))
            .join(',');


        yield [i, char, zhSeeMatch];
      } else {
        yield [i, char, 'error'];
      }
    } catch (e, s) {
      print(e);
      print(s);
      yield [i, char, 'error'];
    }
  }
}

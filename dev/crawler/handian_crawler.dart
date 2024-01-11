import 'dart:io';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';

void main() async {
  Dio dio = Dio();

  var output =
      File('./dev/temp/handian_output_${DateTime.now().toIso8601String()}.csv').openWrite();

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
  for (int i = start; i <= end; i++) {
    final char = String.fromCharCode(i);
    try {
      var response = await dio.get('https://www.zdic.net/hant/${Uri.encodeComponent(char)}');
      if (response.statusCode == 200) {
        final htmlObject = parse(response.toString());
        final zhPron = htmlObject.getElementsByClassName('z_d song');
        final zhPronMatch = zhPron.length != 0
            ? zhPron.sublist(0, ((zhPron.length ~/ 4))).map((e) => e.text.trim()).join(',')
            : '';
        final zhSee = htmlObject.getElementsByClassName('z_jfz');
        final zhSeeMatch = zhSee.length == 2 ? zhSee[1].text.trim() : '';
        final zhVar = htmlObject.getElementsByClassName('z_ytz2');
        late final String zhVarMatch;
        if (zhVar.length == 0) {
          zhVarMatch = '';
        } else {
          zhVarMatch = zhVar.first.nodes
              .map((e) => e.attributes['href']?.split('/').lastOrNull ?? '')
              .join(',');
        }

        yield [i, char, zhPronMatch, zhSeeMatch, zhVarMatch];
      } else {
        yield [i, char, 'error', 'error', 'error'];
      }
    } catch (e, s) {
      print(e);
      print(s);
      yield [i, char, 'error', 'error', 'error'];
    }
  }
}

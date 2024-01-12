import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:pinyin/map/phrase_map.dart';

Future<void> main() async {
  // download data from https://github.com/mozillazg/phrase-pinyin-data
  // old multi_pinyin_dict are totally covered by phrase_map
  phraseMap = {};
  final input = File('dev/data/large_pinyin.txt').openRead();
  final fields = await input.transform(utf8.decoder).transform(CsvToListConverter(
    fieldDelimiter: ": ",
    eol: "\n",
    shouldParseNumbers: false,
  )).toList();

  final file = File('./lib/map/phrase_map.dart');
  if (await file.exists()) {
    await file.delete();
  }

  final output = file.openWrite();

  output.writeln('Map<String, String> phraseMap = {');

  for (var field in fields) {
    output.writeln('  "${field[0]}": "${field[1].trim().replaceAll(' ', ',')}",');
  }

  output.writeln('};');
}

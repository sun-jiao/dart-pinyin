import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';

Future<void> main() async {
  final input = File('dev/data/pinyin.csv').openRead();
  final fields = await input.transform(utf8.decoder).transform(CsvToListConverter(
    shouldParseNumbers: false,
  )).toList();

  if (fields[0][0] != 'code' ||
      fields[0][1] != 'char' ||
      fields[0][2] != 'hex' ||
      fields[0][3] != 'pinyin' ||
      fields[0][4] != 'simp' ||
      fields[0][5] != 'trad') {
    return;
  }

  // TODO: update dict file
}

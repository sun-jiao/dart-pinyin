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


  final pinyin = File('./lib/data/pinyin_map.json');
  final simp = File('./lib/data/trad_to_simp_map.json');
  final trad = File('./lib/data/simp_to_trad_map.json');
  for (final file in [pinyin, simp, trad]) {
    if (await file.exists()) {
      await file.delete();
    }
  }

  final pinyinOutput = pinyin.openWrite();
  final simpOutput = simp.openWrite();
  final tradOutput = trad.openWrite();

  pinyinOutput.write('{');
  simpOutput.write('{');
  tradOutput.write('{');

  bool pinyinWrite = false;
  bool simpWrite = false;
  bool tradWrite = false;

  for (var field in fields.sublist(1)) {
    if (field[3].toString().isNotEmpty) {
      if (pinyinWrite) {
        pinyinOutput.write(',\n  "${field[1]}": "${field[3]}"');
      } else {
        pinyinWrite = true;
        pinyinOutput.write('\n  "${field[1]}": "${field[3]}"');
      }
    }

    if (field[4].toString().isNotEmpty) {
      if (simpWrite) {
        simpOutput.write(',\n  "${field[1]}": "${field[4]}"');
      } else {
        simpWrite = true;
        simpOutput.write('\n  "${field[1]}": "${field[4]}"');
      }
    }

    if (field[5].toString().isNotEmpty) {
      if (tradWrite) {
        tradOutput.write(',\n  "${field[1]}": "${field[5]}"');
      } else {
        tradWrite = true;
        tradOutput.write('\n  "${field[1]}": "${field[5]}"');
      }
    }
  }

  pinyinOutput.writeln('\n}');
  simpOutput.writeln('\n}');
  tradOutput.writeln('\n}');
}

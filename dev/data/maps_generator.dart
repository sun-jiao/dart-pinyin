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


  final pinyin = File('./lib/dict/pinyin_dict.dart');
  final simp = File('./lib/dict/trad_simp_dict.dart');
  final trad = File('./lib/dict/simp_trad_dict.dart');
  for (final file in [pinyin, simp, trad]) {
    if (await file.exists()) {
      await file.delete();
    }
  }

  final pinyinOutput = pinyin.openWrite();
  final simpOutput = simp.openWrite();
  final tradOutput = trad.openWrite();

  pinyinOutput.writeln('const List<String> pinyinDict = [');
  simpOutput.writeln('const List<String> tradSimpDict = [');
  tradOutput.writeln('const List<String> simpTradDict = [');

  for (var field in fields.sublist(1)) {
    if (field[3].toString().isNotEmpty) {
      pinyinOutput.writeln('  "${field[1]}=${field[3]}",');
    }

    if (field[4].toString().isNotEmpty) {
      simpOutput.writeln('  "${field[1]}=${field[4]}",');
    }

    if (field[5].toString().isNotEmpty) {
      tradOutput.writeln('  "${field[1]}=${field[5]}",');
    }
  }

  pinyinOutput.writeln('];');
  simpOutput.writeln('];');
  tradOutput.writeln('];');
}

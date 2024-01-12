import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:pinyin/pinyin.dart';

Future<void> main() async {
  // download data from https://github.com/mozillazg/phrase-pinyin-data
  // old multi_pinyin_dict are totally covered by phrase_map
  phraseMap = {};
  PinyinHelper.minPhraseLength = 1;
  PinyinHelper.maxPhraseLength = 1;

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
    final word = ChineseHelper.convertToSimplifiedChinese(field[0].trim()); // some phrases are mixtures of both trad chars and simp chars
    final pinyin = field[1].trim().replaceAll(' ', PinyinHelper.pinyinSeparator);
    final autoPinyin = PinyinHelper.getPinyin(word, format: PinyinFormat.WITH_TONE_MARK, separator: PinyinHelper.pinyinSeparator);
    if (pinyin != autoPinyin) {
      output.writeln('  "$word": "$pinyin",');
    }
  }

  output.writeln('};');
}

import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:pinyin/pinyin.dart';

const errorWords = ['𫛚', '𱉻𱊊', '陕西', '苜蓿', '石龙子']; // they are basically wrong in large_pinyin.txt

Future<void> main() async {
  // download data from https://github.com/mozillazg/phrase-pinyin-data
  // old multi_pinyin_dict are totally covered by phrase_map
  // phraseMap = {};
  PinyinHelper.minPhraseLength = 1;
  PinyinHelper.maxPhraseLength = 1;
  PinyinHelper.phraseMap;
  PinyinHelper.pinyinMap;

  final input = File('dev/data/large_pinyin.txt').openRead();
  final fields = await input.transform(utf8.decoder).transform(CsvToListConverter(
    fieldDelimiter: ": ",
    eol: "\n",
    shouldParseNumbers: false,
  )).toList();

  final file = File('./lib/data/phrase_map.json');
  if (await file.exists()) {
    await file.delete();
  }

  final output = file.openWrite();

  Map<String, String> theMap = HashMap();
  output.write('{');
  bool alreadyWrite = false;

  for (var field in fields) {
    final word = ChineseHelper.convertToSimplifiedChinese(field[0].trim()); // some phrases are mixtures of both trad chars and simp chars
    if (errorWords.map((e) => word.contains(e)).reduce((a, b) => a || b)) continue;
    final pinyin = field[1].trim().replaceAll(' ', PinyinHelper.pinyinSeparator);
    try {
      final autoPinyin = PinyinHelper.getPinyin(word, format: PinyinFormat.WITH_TONE_MARK, separator: PinyinHelper.pinyinSeparator);
      if (pinyin != autoPinyin) {
        if (theMap.containsKey(word)) {
          if (theMap[word] != pinyin) {
            print('$word: $pinyin error');
          }
        } else {
          theMap[word] = pinyin;
          if (alreadyWrite) {
            output.write(',\n  "$word": "$pinyin"');
          } else {
            alreadyWrite = true;
            output.write('\n  "$word": "$pinyin"');
          }
        }
      }
    } catch (e, s) {
      print(s);
    }
  }

  output.write('}');

  int minPhraseLength = theMap.keys.reduce((a, b) {
    return a.runes.length < b.runes.length ? a : b;
  }).runes.length;
  int maxPhraseLength = theMap.keys.reduce((a, b) {
    return a.runes.length > b.runes.length ? a : b;
  }).runes.length;

  File('lib/map/phrase_length.dart').openWrite(mode: FileMode.append).writeln('''int minPhraseLengthPy = $minPhraseLength;
int maxPhraseLengthPy = $maxPhraseLength;''');
}

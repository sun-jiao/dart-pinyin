import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:pinyin/pinyin.dart';

Future<void> main() async {
  // download data from
  // https://github.com/BYVoid/OpenCC/blob/master/data/dictionary/STPhrases.txt
  // https://github.com/BYVoid/OpenCC/blob/master/data/dictionary/TSPhrases.txt
  // old multi_pinyin_dict are totally covered by phrase_map
  final s2t = ['dev/data/STPhrases.txt', './lib/map/phrase_simp_to_trad.dart', 'phraseMapS2T', ChineseHelper.convertToSimplifiedChinese];
  final t2s = ['dev/data/TSPhrases.txt', './lib/map/phrase_trad_to_simp.dart', 'phraseMapT2S', ChineseHelper.convertToTraditionalChinese];

  for (var list in [s2t, t2s]) {
    final input = File(list[0] as String).openRead();
    final fields = await input.transform(utf8.decoder).transform(CsvToListConverter(
      fieldDelimiter: "\t",
      eol: "\n",
      shouldParseNumbers: false,
    )).toList();

    final file = File(list[1] as String);
    if (await file.exists()) {
      await file.delete();
    }

    final output = file.openWrite();

    Map<String, String> theMap = HashMap();
    output.writeln('Map<String, String> ${list[2] as String} = {');

    for (var field in fields) {
      final word = field[0].trim(); // some phrases are mixtures of both trad chars and simp chars
      final converts = field[1].trim().split(" ");
      for (var convert in converts) {
        try {
          if (theMap.containsKey(word)) {
            if (theMap[word] != convert) {
              print('$word: $convert error');
            }
          } else {
            theMap[word] = convert;
            output.writeln('  "$word": "$convert",');
          }
        } catch (e, s) {
          print(e);
        }
      }
    }

    output.writeln('};');
  }
}

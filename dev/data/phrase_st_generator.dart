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
  ChineseHelper.phraseMapS2T;
  ChineseHelper.phraseMapT2S;
  ChineseHelper.tradToSimpMap;
  ChineseHelper.simpToTradMap;
  final s2t = ['dev/data/STPhrases.txt', './lib/data/phrase_simp_to_trad.json', 'S2T', ChineseHelper.convertToSimplifiedChinese];
  final t2s = ['dev/data/TSPhrases.txt', './lib/data/phrase_trad_to_simp.json', 'T2S', ChineseHelper.convertToTraditionalChinese];

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
    output.write('{');
    bool alreadyWrite = false;

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
            if (alreadyWrite) {
              output.write(',\n  "$word": "$convert"');
            } else {
              alreadyWrite = true;
              output.write('\n  "$word": "$convert"');
            }
          }
        } catch (e, s) {
          print(e);
        }
      }
    }

    output.write('}');



    int minPhraseLength = theMap.keys.reduce((a, b) {
      return a.runes.length < b.runes.length ? a : b;
    }).runes.length;
    int maxPhraseLength = theMap.keys.reduce((a, b) {
      return a.runes.length > b.runes.length ? a : b;
    }).runes.length;

    File('lib/map/phrase_length.dart').openWrite(mode: FileMode.append).writeln('''int minPhraseLength${list[2] as String} = $minPhraseLength;
int maxPhraseLength${list[2] as String} = $maxPhraseLength;''');
  }
}

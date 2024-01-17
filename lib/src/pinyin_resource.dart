import 'dart:collection';
import 'dart:convert';

import 'package:pinyin/data/phrase_map.dart';
import 'package:pinyin/data/phrase_simp_to_trad.dart';
import 'package:pinyin/data/phrase_trad_to_simp.dart';
import 'package:pinyin/data/pinyin_map.dart';
import 'package:pinyin/data/simp_to_trad_map.dart';
import 'package:pinyin/data/trad_to_simp_map.dart';

/// Pinyin Resource.
class PinyinResource {
  /// get Pinyin Resource.
  static Map<String, String> getPinyinResource() {
    return _getMap(pinyinJson);
  }

  /// get Chinese Resource.
  @Deprecated('Replaced by getSimpToTradResource and getTradToSimpResource')
  static Map<String, String> getChineseResource() => getTradToSimpResource();

  /// get Chinese Resource.
  static Map<String, String> getSimpToTradResource() {
    return _getMap(simpToTradJson);
  }

  /// get Chinese Resource.
  static Map<String, String> getTradToSimpResource() {
    return _getMap(tradToSimpJson);
  }

  /// get Multi Pinyin Resource.
  @Deprecated('Replaced by getPhraseResource')
  static Map<String, String> getMultiPinyinResource() => getPhraseResource();

  static Map<String, String> getPhraseResource() {
    return _getMap(phrasePinyin);
  }

  static Map<String, String> getPhraseSimpToTradResource() {
    return _getMap(phraseS2TJson);
  }

  static Map<String, String> getPhraseTradToSimpResource() {
    return _getMap(phraseT2SJson);
  }

  static Map<String, String> _getMap(String jsonAsString) {
    final decoded = json.decode(jsonAsString);
    var largeMap = SplayTreeMap<String, String>();
    for (var entry in decoded.entries) {
      largeMap[entry.key] = entry.value;
    }
    return largeMap;
  }

  /// get Resource.
  @Deprecated('No longer needed.')
  static Map<String, String> getResource(List<String> list) {
    Map<String, String> map = HashMap();
    List<MapEntry<String, String>> mapEntryList = [];
    for (int i = 0, length = list.length; i < length; i++) {
      List<String> tokens = list[i].trim().split('=');
      MapEntry<String, String> mapEntry = MapEntry(tokens[0], tokens[1]);
      mapEntryList.add(mapEntry);
    }
    map.addEntries(mapEntryList);
    return map;
  }
}

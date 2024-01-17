import 'dart:collection';
import 'dart:convert';
import 'dart:io';

/// Pinyin Resource.
class PinyinResource {
  /// get Pinyin Resource.
  static Map<String, String> getPinyinResource() {
    return _getMap('lib/data/pinyin_map.json');
  }

  /// get Chinese Resource.
  @Deprecated('Replaced by getSimpToTradResource and getTradToSimpResource')
  static Map<String, String> getChineseResource() => getTradToSimpResource();

  /// get Chinese Resource.
  static Map<String, String> getSimpToTradResource() {
    return _getMap('lib/data/simp_to_trad_map.json');
  }

  /// get Chinese Resource.
  static Map<String, String> getTradToSimpResource() {
    return _getMap('lib/data/trad_to_simp_map.json');
  }

  /// get Multi Pinyin Resource.
  @Deprecated('Replaced by getPhraseResource')
  static Map<String, String> getMultiPinyinResource() {
    return _getMap('lib/data/pinyin_map.json');
  }

  static Map<String, String> getPhraseResource() {
    return _getMap('lib/data/phrase_map.json');
  }

  static Map<String, String> getPhraseSimpToTradResource() {
    return _getMap('lib/data/phrase_simp_to_trad.json');
  }

  static Map<String, String> getPhraseTradToSimpResource() {
    return _getMap('lib/data/phrase_trad_to_simp.json');
  }

  static Map<String, String> _getMap(String filename) {
    final myJsonAsString = File(filename).readAsStringSync();
    final decoded = json.decode(myJsonAsString);
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

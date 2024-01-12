import 'dart:collection';

import '../map/phrase_map.dart';
import '../map/simp_to_trad_map.dart';
import '../map/pinyin_map.dart';

/// Pinyin Resource.
class PinyinResource {
  /// get Pinyin Resource.
  @Deprecated('No longer needed.')
  static Map<String, String> getPinyinResource() {
    return pinyinMap;
  }

  /// get Chinese Resource.
  @Deprecated('No longer needed.')
  static Map<String, String> getChineseResource() {
    return simpToTradMap;
  }

  /// get Multi Pinyin Resource.
  @Deprecated('No longer needed.')
  static Map<String, String> getMultiPinyinResource() {
    return phraseMap;
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

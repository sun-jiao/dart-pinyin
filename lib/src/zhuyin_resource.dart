import 'dart:collection';

import 'zhuyin_map.dart';

class ZhuyinResource {
  /// get Pinyin To Zhuyin Resource.
  static Map<String, String> getPinyinToZhuyinResource() {
    return pinyinToZhuyinMap;
  }

  /// get Pinyin To Zhuyin Resource.
  static Map<String, String> getZhuyinToPinyinResource() {
    List<String> keys = pinyinToZhuyinMap.keys.toList();
    List<String> values = pinyinToZhuyinMap.values.toList();
    Map<String, String> map = HashMap();
    List<MapEntry<String, String>> mapEntryList = [];
    for (int i = 0; i < values.length; i++) {
      MapEntry<String, String> mapEntry = MapEntry(values[i], keys[i]);
      mapEntryList.add(mapEntry);
    }
    map.addEntries(mapEntryList);
    return map;
  }
}

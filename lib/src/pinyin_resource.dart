import 'dart:collection';

import 'package:pinyin/db/db_utils.dart';
import 'package:sqlite3/sqlite3.dart';

import '../dict/multi_pinyin_dict.dart';

/// Pinyin Resource.
class PinyinResource {
  static Database? _db;
  
  static void initDb(String path) {
    if (_db == null) {
      _db = getPinyinDb(path);
    }
  }

  static Database get db {
    return _db!;
  }

  static void disposeDb() {
    _db?.dispose();
  }
  
  // /// get Pinyin Resource.
  // static Map<String, String> getPinyinResource() {
  //   return getResource(pinyinDict);
  // }
  //
  // /// get Chinese Resource.
  // static Map<String, String> getChineseResource() {
  //   return simpTradDict;
  // }

  /// get Multi Pinyin Resource.
  static Map<String, String> getMultiPinyinResource() {
    return getResource(multiPinyinDict);
  }

  /// get Resource.
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


import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

Database getPinyinDb(String path) {
  final Database db = sqlite3.open(path);
  final pinyinTable = db.select("select * from sqlite_schema where tbl_name='pinyin'");
  final versionTable = db.select("select * from sqlite_schema where tbl_name='version'");
  if (pinyinTable.length == 1 && versionTable.length == 1) {
    final version = db.select("select * from version where id=0");
    if (version.length == 1 && version.first['version'] == int.parse(File('lib/db/version').readAsStringSync())) {
      return db;
    }
  }

  db.execute(File('lib/db/pinyin.sql').readAsStringSync());
  return db;
}
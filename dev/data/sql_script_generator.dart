import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';

Future<void> main() async {
  final input = File('dev/data/pinyin.csv').openRead();
  final fields = await input.transform(utf8.decoder).transform(CsvToListConverter(
    shouldParseNumbers: false,
  )).toList();

  if (fields[0][0] != 'code' ||
      fields[0][1] != 'char' ||
      fields[0][2] != 'hex' ||
      fields[0][3] != 'pinyin' ||
      fields[0][4] != 'simp' ||
      fields[0][5] != 'trad') {
    return;
  }

  final versionFile = File('dev/data/version');
  final int version = int.parse(await versionFile.readAsString());
  versionFile.copy('lib/db/version');

  final file = File('./lib/db/pinyin.sql');
  if (await file.exists()) {
    await file.delete();
  }

  final output = File('./lib/db/pinyin.sql').openWrite();
  output.writeln('''BEGIN TRANSACTION;
DROP TABLE IF EXISTS "version";
CREATE TABLE IF NOT EXISTS "version" (
	"id"	INTEGER NOT NULL UNIQUE,
	"version"	INTEGER NOT NULL,
	PRIMARY KEY("id")
);
INSERT INTO "version" ("id","version") VALUES (0,$version);
DROP TABLE IF EXISTS "pinyin";
CREATE TABLE IF NOT EXISTS "pinyin" (
	"code"	INTEGER NOT NULL UNIQUE,
	"char"	TEXT NOT NULL,
	"hex"	TEXT NOT NULL UNIQUE,
	"pinyin"	TEXT,
	"simp"	TEXT,
	"trad"	TEXT,
	PRIMARY KEY("code")
);''');

  for (var field in fields.sublist(1)) {
    output.writeln('INSERT INTO "pinyin" ("code","char","hex","pinyin","simp","trad") VALUES (${field[0]},\'${field[1]}\',\'${field[2]}\',${field[3] == "" ? 'NULL' : "'" + field[3] + "'"},${field[4] == "" ? 'NULL' : "'" + field[4] + "'"},${field[5] == "" ? 'NULL' : "'" + field[5] + "'"});');
  }

  output.writeln('COMMIT;');
}

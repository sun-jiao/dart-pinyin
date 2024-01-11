import 'dart:io';

import 'package:pinyin/pinyin.dart';

Future<void> main() async {
  var file = await File('./dev/benchmark/滕王阁序.txt').readAsString();
  final start = DateTime.now();
  final result = PinyinHelper.getPinyin(file,
      separator: " ", format: PinyinFormat.WITH_TONE_MARK);
  final end = DateTime.now();
  print(result);
  print(end.microsecond - start.microsecond); // 70
}
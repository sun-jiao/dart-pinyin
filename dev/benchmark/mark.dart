import 'dart:io';

import 'package:pinyin/pinyin.dart';

Future<void> main() async {
  var file = await File('./dev/benchmark/Zhuangzi.txt').readAsString();
  final start = DateTime.now();
  final result = PinyinHelper.getPinyin(file,
      separator: " ", format: PinyinFormat.WITH_TONE_MARK);
  final end = DateTime.now();
  print(result);
  print(end.millisecondsSinceEpoch - start.millisecondsSinceEpoch);
}
import 'dart:io';

import 'package:pinyin/pinyin.dart';

Future<void> main() async {
  PinyinResource.initDb('pinyin.sqlite');
  var file = await File('./dev/benchmark/Zhuangzi.txt').readAsString();
  for (int i = 0; i < 10; i++) {
    print('doing the ${i+1} epoch');
    final start = DateTime.now();
    PinyinHelper.maxMultiLength = 5;
    PinyinHelper.getPinyin(file * (i + 1),
        separator: " ", format: PinyinFormat.WITH_TONE_MARK);
    final end = DateTime.now();
    print(end.millisecondsSinceEpoch - start.millisecondsSinceEpoch);
  }
}
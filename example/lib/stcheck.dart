import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:pinyin/pinyin.dart';

main() {
  var path = 'example/simp';
  new File(path)
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter())
      .forEach((l) async {
        if (ChineseHelper.convertToSimplifiedChinese(l) != l) {
          print(l);
        }
  });
}

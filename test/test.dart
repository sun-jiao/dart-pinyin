import 'package:pinyin/pinyin.dart';
import 'package:test/test.dart';

void main() {
  group('Regular conversions', () {
    final testStr = "汉语拼音方案";
    test('without tone', () {
      final pinyin = PinyinHelper.getPinyin(testStr);
      expect(pinyin, equals('han yu pin yin fang an'));
    });

    test('with tone mark', () {
      final pinyin = PinyinHelper.getPinyin(testStr, format: PinyinFormat.WITH_TONE_MARK);
      expect(pinyin, equals('hàn yǔ pīn yīn fāng àn'));
    });

    test('with tone number', () {
      final pinyin = PinyinHelper.getPinyin(testStr, format: PinyinFormat.WITH_TONE_NUMBER);
      expect(pinyin, equals('han4 yu3 pin1 yin1 fang1 an4'));
    });
  });
}
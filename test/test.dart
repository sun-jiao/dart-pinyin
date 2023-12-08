import 'package:pinyin/pinyin.dart';
import 'package:test/test.dart';

void main() {
  group('dictionary completion check', () {
    PinyinHelper.pinyinMap = PinyinResource.getPinyinResource();
    final keys = PinyinHelper.pinyinMap.keys;

    test('check zero in dict', () {
      expect(keys.contains(String.fromCharCode(0x3007)), isTrue);
    });

    test('check all URO chars in dict', () {
      for (int i = 0x4e00; i <= 0x9fa5; i++) {
        expect(keys.contains(String.fromCharCode(i)), isTrue);
      }
    });

    // test('check all dict keys in URO', () {
    //   for (String str in keys) {
    //     final code = str.runes.toList()[0];
    //     if (!(code == 0x3007 || (code >= 0x4e00 && code <= 0x9fa5))) {
    //       print(String.fromCharCode(code));
    //     }
    //     expect(code == 0x3007 || (code >= 0x4e00 && code <= 0x9fa5), isTrue);
    //   }
    // });
  });

  group('Regular conversions', () {
    final testStr = "汉语拼音方案";
    test('abbr', () {
      final pinyin = PinyinHelper.getShortPinyin(testStr);
      expect(pinyin, equals('hypyfa'));
    });

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

    test('zhuyin, without tone', () {
      final pinyin = ZhuyinHelper.getZhuyin(testStr, format: PinyinFormat.WITHOUT_TONE);
      expect(pinyin, equals('ㄏㄢ ㄩ ㄆㄧㄣ ㄧㄣ ㄈㄤ ㄢ'));
    });

    test('zhuyin, with tone mark', () {
      final pinyin = ZhuyinHelper.getZhuyin(testStr, format: PinyinFormat.WITH_TONE_MARK);
      expect(pinyin, equals('ㄏㄢˋ ㄩˇ ㄆㄧㄣ ㄧㄣ ㄈㄤ ㄢˋ'));
    });

    test('zhuyin, with tone number', () {
      final pinyin = ZhuyinHelper.getZhuyin(testStr, format: PinyinFormat.WITH_TONE_NUMBER);
      expect(pinyin, equals('ㄏㄢ4 ㄩ3 ㄆㄧㄣ1 ㄧㄣ1 ㄈㄤ1 ㄢ4'));
    });
  });

  group('Contains non-Chinese characters or emoji', () {
    final testStr = "🇨🇳Chengdu天府广场";
    test('abbr', () {
      final pinyin = PinyinHelper.getShortPinyin(testStr);
      expect(pinyin, equals('🇨🇳Chengdu tfgc'));
    });

    test('without tone', () {
      final pinyin = PinyinHelper.getPinyin(testStr);
      expect(pinyin, equals('🇨🇳Chengdu tian fu guang chang'));
    });

    test('with tone mark', () {
      final pinyin = PinyinHelper.getPinyin(testStr, format: PinyinFormat.WITH_TONE_MARK);
      expect(pinyin, equals('🇨🇳Chengdu tiān fǔ guǎng chǎng'));
    });

    test('with tone number', () {
      final pinyin = PinyinHelper.getPinyin(testStr, format: PinyinFormat.WITH_TONE_NUMBER);
      expect(pinyin, equals('🇨🇳Chengdu tian1 fu3 guang3 chang3'));
    });

    test('zhuyin, without tone', () {
      final pinyin = ZhuyinHelper.getZhuyin(testStr, format: PinyinFormat.WITHOUT_TONE);
      expect(pinyin, equals('🇨🇳Chengdu ㄊㄧㄢ ㄈㄨ ㄍㄨㄤ ㄔㄤ'));
    });

    test('zhuyin, with tone mark', () {
      final pinyin = ZhuyinHelper.getZhuyin(testStr, format: PinyinFormat.WITH_TONE_MARK);
      expect(pinyin, equals('🇨🇳Chengdu ㄊㄧㄢ ㄈㄨˇ ㄍㄨㄤˇ ㄔㄤˇ'));
    });

    test('zhuyin, with tone number', () {
      final pinyin = ZhuyinHelper.getZhuyin(testStr, format: PinyinFormat.WITH_TONE_NUMBER);
      expect(pinyin, equals('🇨🇳Chengdu ㄊㄧㄢ1 ㄈㄨ3 ㄍㄨㄤ3 ㄔㄤ3'));
    });
  });

  group('custom dict, extension platform chars, and heteronym', () {
    PinyinHelper.addPinyinDict(['𱉼=jí','𫛚=yán,jiān']);
    PinyinHelper.addMultiPinyinDict(['黄苇𫛚=huáng,wěi,jiān']);

    final testStr = "东亚石𱉼和黄苇𫛚";
    test('abbr', () {
      final pinyin = PinyinHelper.getShortPinyin(testStr);
      expect(pinyin, equals('dysjhhwj'));
    });

    test('without tone', () {
      final pinyin = PinyinHelper.getPinyin(testStr);
      expect(pinyin, equals('dong ya shi ji he huang wei jian'));
    });

    test('with tone mark', () {
      final pinyin = PinyinHelper.getPinyin(testStr, format: PinyinFormat.WITH_TONE_MARK);
      expect(pinyin, equals('dōng yà shí jí hé huáng wěi jiān'));
    });

    test('with tone number', () {
      final pinyin = PinyinHelper.getPinyin(testStr, format: PinyinFormat.WITH_TONE_NUMBER);
      expect(pinyin, equals('dong1 ya4 shi2 ji2 he2 huang2 wei3 jian1'));
    });

    test('zhuyin, without tone', () {
      final pinyin = ZhuyinHelper.getZhuyin(testStr, format: PinyinFormat.WITHOUT_TONE);
      expect(pinyin, equals('ㄉㄨㄥ ㄧㄚ ㄕ ㄐㄧ ㄏㄜ ㄏㄨㄤ ㄨㄟ ㄐㄧㄢ'));
    });

    test('zhuyin, with tone mark', () {
      final pinyin = ZhuyinHelper.getZhuyin(testStr, format: PinyinFormat.WITH_TONE_MARK);
      expect(pinyin, equals('ㄉㄨㄥ ㄧㄚˋ ㄕˊ ㄐㄧˊ ㄏㄜˊ ㄏㄨㄤˊ ㄨㄟˇ ㄐㄧㄢ'));
    });

    test('zhuyin, with tone number', () {
      final pinyin = ZhuyinHelper.getZhuyin(testStr, format: PinyinFormat.WITH_TONE_NUMBER);
      expect(pinyin, equals('ㄉㄨㄥ1 ㄧㄚ4 ㄕ2 ㄐㄧ2 ㄏㄜ2 ㄏㄨㄤ2 ㄨㄟ3 ㄐㄧㄢ1'));
    });
  });
}

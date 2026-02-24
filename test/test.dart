import 'package:pinyin/pinyin.dart';
import 'package:test/test.dart';

void main() {
/*  Remove dictionary completion check because they're currently auto-generated
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
  });*/

  group('Toned consonants in syllabic nasals', () {
    // 嗯 has pinyin "èn,ń". The reading ń (U+0144) is a toned consonant, not a vowel.
    // Before this fix, convertWithToneNumber would call allUnmarkedVowel.codeUnitAt(-1)
    // and throw a RangeError because ń was absent from allMarkedVowel.
    test('嗯 WITH_TONE_NUMBER no longer throws RangeError', () {
      expect(
        () => PinyinHelper.getPinyinE('嗯', separator: ' ', defPinyin: '#',
            format: PinyinFormat.WITH_TONE_NUMBER),
        returnsNormally,
      );
    });

    test('嗯 WITH_TONE_NUMBER returns tone-numbered reading', () {
      final result = PinyinHelper.getPinyinE('嗯', separator: ' ', defPinyin: '#',
          format: PinyinFormat.WITH_TONE_NUMBER);
      expect(result, equals('en4'));
    });

    test('嗯 WITH_TONE_MARK still works', () {
      final result = PinyinHelper.getPinyinE('嗯', separator: ' ', defPinyin: '#',
          format: PinyinFormat.WITH_TONE_MARK);
      expect(result, equals('èn'));
    });
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

  group('extension platform chars', () {
    PinyinHelper.addPinyinMap({'𱉼': 'jí','𫛚': 'yán,jiān'}); // 𱉼 is in TIP (第三辅助平面) and 𫛚 is in SIP (表意文字补充平面)
    PinyinHelper.addPhraseMap({'黄苇𫛚': 'huáng,wěi,jiān'});

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

  group('custom dict and heteronym', () {
    PinyinHelper.addPinyinMap({'𫠪':'yǐ,xià','𫠫': 'bù,yúan'}); // not right, just for test.
    PinyinHelper.addPhraseMap({'不不𫠫':'bù,bù,yúan'});

    final testStr = "东𫠪不不𫠫";
    test('abbr', () {
      final pinyin = PinyinHelper.getShortPinyin(testStr);
      expect(pinyin, equals('dybby'));
    });

    test('without tone', () {
      final pinyin = PinyinHelper.getPinyin(testStr);
      expect(pinyin, equals('dong yi bu bu yuan'));
    });

    test('with tone mark', () {
      final pinyin = PinyinHelper.getPinyin(testStr, format: PinyinFormat.WITH_TONE_MARK);
      expect(pinyin, equals('dōng yǐ bù bù yúan'));
    });

    test('with tone number', () {
      final pinyin = PinyinHelper.getPinyin(testStr, format: PinyinFormat.WITH_TONE_NUMBER);
      expect(pinyin, equals('dong1 yi3 bu4 bu4 yuan2'));
    });

    test('zhuyin, without tone', () {
      final pinyin = ZhuyinHelper.getZhuyin(testStr, format: PinyinFormat.WITHOUT_TONE);
      expect(pinyin, equals('ㄉㄨㄥ ㄧ ㄅㄨ ㄅㄨ ㄩㄢ'));
    });

    test('zhuyin, with tone mark', () {
      final pinyin = ZhuyinHelper.getZhuyin(testStr, format: PinyinFormat.WITH_TONE_MARK);
      expect(pinyin, equals('ㄉㄨㄥ ㄧˇ ㄅㄨˋ ㄅㄨˋ ㄩㄢˊ'));
    });

    test('zhuyin, with tone number', () {
      final pinyin = ZhuyinHelper.getZhuyin(testStr, format: PinyinFormat.WITH_TONE_NUMBER);
      expect(pinyin, equals('ㄉㄨㄥ1 ㄧ3 ㄅㄨ4 ㄅㄨ4 ㄩㄢ2'));
    });
  });

  group('Simp-Trad convert', () {
    test('simp to trad', () {
      final simp = '''夸夸其谈 夸父逐日
我干什么不干你事。
太后的头发很干燥。
燕燕于飞，差池其羽。之子于归，远送于野。
请成相，世之殃，愚暗愚暗堕贤良。人主无贤，如瞽无相何伥伥！请布基，慎圣人，愚而自专事不治。主忌苟胜，群臣莫谏必逢灾。
曾经有一份真诚的爱情放在我面前，我没有珍惜，等我失去的时候我才后悔莫及。人事间最痛苦的事莫过于此。如果上天能够给我一个再来一次得机会，我会对那个女孩子说三个字，我爱你。如果非要在这份爱上加个期限，我希望是，一万年。
新的理论被发现了。
金胄不是金色的甲胄。
经理发现后劝谕两人
想到自己一紧张就口吃，我就没胃口吃饭
恒指最新消息，恒生指数跌破 2 万点
恒生银行和恒大集团发布财报''';
      final trad = '''誇誇其談 夸父逐日
我幹什麼不干你事。
太后的頭髮很乾燥。
燕燕于飛，差池其羽。之子于歸，遠送於野。
請成相，世之殃，愚闇愚闇墮賢良。人主無賢，如瞽無相何倀倀！請布基，慎聖人，愚而自專事不治。主忌苟勝，群臣莫諫必逢災。
曾經有一份真誠的愛情放在我面前，我沒有珍惜，等我失去的時候我才後悔莫及。人事間最痛苦的事莫過於此。如果上天能夠給我一個再來一次得機會，我會對那個女孩子説三個字，我愛你。如果非要在這份愛上加個期限，我希望是，一萬年。
新的理論被發現了。
金胄不是金色的甲冑。
經理發現後勸諭兩人
想到自己一緊張就口吃，我就沒胃口吃飯
恒指最新消息，恒生指數跌破 2 萬點
恒生銀行和恒大集團發佈財報''';
      final converted = ChineseHelper.convertToTraditionalChinese(simp);
      expect(converted, equals(trad));
    });

    test('trad to simp', () {
      final simp = '''曾经有一份真诚的爱情放在我面前，我没有珍惜，等我失去的时候我才后悔莫及。人事间最痛苦的事莫过于此。如果上天能够给我一个再来一次得机会，我会对那个女孩子说三个字，我爱你。如果非要在这份爱上加个期限，我希望是，一万年。
二𫫇英''';
      final trad = '''曾經有一份真誠的愛情放在我面前，我沒有珍惜，等我失去的時候我才後悔莫及。人事間最痛苦的事莫過於此。如果上天能夠給我一個再來一次得機會，我會對那個女孩子說三個字，我愛你。如果非要在這份愛上加個期限，我希望是，一萬年。
二噁英''';
      final converted = ChineseHelper.convertToSimplifiedChinese(trad);
      expect(converted, equals(simp));
    });
  });
}

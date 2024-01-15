import 'dart:collection';
import 'dart:math';

import 'package:pinyin/pinyin.dart';
import 'package:pinyin/src/phrase_converter.dart';

/// 汉字转拼音类.
class PinyinHelper {
  /// 拼音分隔符
  static const String pinyinSeparator = ',';

  /// 所有带声调的拼音字母
  static const String allMarkedVowel = 'āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜ';
  static const String allUnmarkedVowel = 'aeiouv';
  static int minPhraseLength = 2;
  static int maxPhraseLength = phraseMap.keys.reduce((a, b) {
    return a.runes.length > b.runes.length ? a : b;
  }).runes.length;

  @Deprecated('replaced by minPhraseLength')
  static int get minMultiLength => minPhraseLength;
  @Deprecated('replaced by minPhraseLength')
  static set minMultiLength(int length) {
    minPhraseLength = length;
  }

  @Deprecated('replaced by maxPhraseLength')
  static int get maxMultiLength => maxPhraseLength;
  @Deprecated('replaced by maxPhraseLength')
  static set maxMultiLength(int length) {
    maxPhraseLength = length;
  }

  static String _getPinyin(
    String str,
    bool isShort,
    String separator,
    Function(StringBuffer sb, String char) onKeyError,
    PinyinFormat format,
  ) {
    if (str.isEmpty) return '';
    StringBuffer sb = StringBuffer();
    // str = ChineseHelper.convertToSimplifiedChinese(str); // now only needed for phrases.

    List<int> runes = str.runes.toList();
    int runeLen = runes.length;
    int i = 0;
    bool prevIsHan = false;

    while (i < runeLen) {
      String subStr = String.fromCharCodes(runes.sublist(i));
      String _char = String.fromCharCode(runes[i]);
      bool isHan = ChineseHelper.isChinese(_char);

      if (i != 0 && ((!isShort && (isHan || prevIsHan)) || (isHan ^ prevIsHan))) {
        sb.write(separator);
      }

      PhrasePinyin? node = convertToPinyinForPhrase(subStr, separator, format, isShort: isShort);
      if (node == null) {
        if (isHan) {
          List<String> pinyinArray = convertToPinyinArray(_char, format);
          if (pinyinArray.isNotEmpty) {
            if (isShort) {
              sb.write(pinyinArray[0].substring(0, 1));
            } else {
              sb.write(pinyinArray[0]);
            }
          } else {
            onKeyError.call(sb, _char);
          }
        } else {
          sb.write(_char);
        }
        i++;
      } else {
        sb.write(node.pinyin?.trim());
        i += node.word!.runes.length;
      }
      prevIsHan = isHan;
    }
    String res = sb.toString();
    return ((res.endsWith(separator) && separator != '') ? res.substring(0, res.runes.length - 1) : res);
  }

  /// 获取字符串首字拼音
  /// @param str 需要转换的字符串
  /// @return 首字拼音 (成都 cheng)
  static String getFirstWordPinyin(String str) {
    if (str.isEmpty) return '';
    // str = ChineseHelper.convertToSimplifiedChinese(str); // now only needed for phrases.

    List runes = str.runes.toList();
    int runeLen = runes.length;
    int i = 0;
    final format = PinyinFormat.WITHOUT_TONE;

    while (i < runeLen) {
      String subStr = String.fromCharCode(runes[i]);
      PhrasePinyin? node = convertToPinyinForPhrase(subStr, ' ', format);
      if (node == null) {
        String _char = String.fromCharCode(runes[i]);
        bool isHan = ChineseHelper.isChinese(_char);

        if (isHan) {
          List<String> pinyinArray = convertToPinyinArray(_char, format);
          return pinyinArray[0];
        }
      }

      i++;
    }

    return '';
  }

  /// 获取字符串对应拼音的首字母
  /// @param str 需要转换的字符串
  /// @return 对应拼音的首字母 (成都 cd)
  static String getShortPinyin(String str) =>
      _getPinyin(str, true, ' ', (sb, char) => null, PinyinFormat.WITHOUT_TONE);

  /// 将字符串转换成相应格式的拼音
  /// @param str 需要转换的字符串
  /// @param separator 拼音分隔符 def: ' '
  /// @param format 拼音格式 def: PinyinFormat.WITHOUT_TONE
  /// @return 字符串的拼音(成都 cheng du)
  static String getPinyin(
    String str, {
    String separator = ' ',
    PinyinFormat format = PinyinFormat.WITHOUT_TONE,
  }) =>
      _getPinyin(str, false, separator,
          (sb, char) => throw PinyinException("Can't convert to pinyin: $char"), format);

  /// 将字符串转换成相应格式的拼音 (不能转换的字拼音默认用' '替代 )
  /// @param str 需要转换的字符串
  /// @param separator 拼音分隔符 def: ' '
  /// @param defPinyin 默认拼音 def: ' '
  /// @param format 拼音格式 def: PinyinFormat.WITHOUT_TONE
  /// @return 字符串的拼音(成都 cheng du)
  static String getPinyinE(
    String str, {
    String separator = ' ',
    String defPinyin = ' ',
    PinyinFormat format = PinyinFormat.WITHOUT_TONE,
  }) =>
      _getPinyin(str, false, separator, (sb, char) {
        sb.write(defPinyin);
        print("### Can't convert to pinyin: $char , defPinyin: $defPinyin");
      }, format);

  /// 获取词组拼音
  /// @param str 需要转换的字符串
  /// @param separator 拼音分隔符
  /// @param format 拼音格式
  /// @return 词组拼音
  @Deprecated('replaced by convertToPinyinForPhrase')
  static PhrasePinyin? convertToMultiPinyin(String str, String separator, PinyinFormat format,
      {bool isShort = false}) {
    return convertToPinyinForPhrase(str, separator, format, isShort: isShort);
  }
  
  /// 获取词组拼音
  /// @param str 需要转换的字符串
  /// @param separator 拼音分隔符
  /// @param format 拼音格式
  /// @return 词组拼音
  static PhrasePinyin? convertToPinyinForPhrase(String str, String separator, PinyinFormat format,
      {bool isShort = false}) {
    final runes = str.runes.toList();

    if (str.runes.toList().length < minPhraseLength) return null;
    str = ChineseHelper.convertToSimplifiedChinese(str); // now only needed for phrases.

    if (maxPhraseLength == 0) {
      List<String> keys = phraseMap.keys.toList();
      for (int i = 0, length = keys.length; i < length; i++) {
        if (keys[i].runes.toList().length > maxPhraseLength) {
          maxPhraseLength = keys[i].runes.toList().length;
        }
      }
    }

    for (int end = min(maxPhraseLength, runes.length);
        (end >= minPhraseLength);
        end--) {
      String subStr = String.fromCharCodes(runes.sublist(0, end));
      String? phraseValue = phraseMap[subStr];
      if (phraseValue != null && phraseValue.isNotEmpty) {
        List<String> strList = phraseValue.split(pinyinSeparator);
        StringBuffer sb = StringBuffer();
        strList.forEach((value) {
          List<String> pinyin = formatPinyin(value, format);
          if (isShort) {
            sb.write(pinyin[0].substring(0, 1));
          } else {
            sb.write(pinyin[0]);
            sb.write(separator);
          }
        });
        return PhrasePinyin(word: subStr, pinyin: sb.toString());
      }
    }
    return null;
  }

  /// 将单个汉字转换为相应格式的拼音
  /// @param c 需要转换成拼音的汉字
  /// @param format 拼音格式
  /// @return 汉字的拼音
  static List<String> convertToPinyinArray(String c, PinyinFormat format) {
    String? pinyin = pinyinMap[c];
    return pinyin == null ? [] : formatPinyin(pinyin, format);
  }

  /// 将带声调的拼音格式化为相应格式的拼音
  /// @param pinyinStr 带声调格式的拼音
  /// @param format 拼音格式
  /// @return 格式转换后的拼音
  static List<String> formatPinyin(String pinyinStr, PinyinFormat format) {
    if (format == PinyinFormat.WITH_TONE_MARK) {
      return pinyinStr.split(pinyinSeparator);
    } else if (format == PinyinFormat.WITH_TONE_NUMBER) {
      return convertWithToneNumber(pinyinStr);
    } else if (format == PinyinFormat.WITHOUT_TONE) {
      return convertWithoutTone(pinyinStr);
    }
    return [];
  }

  /// 将带声调格式的拼音转换为不带声调格式的拼音
  /// @param pinyinArrayStr 带声调格式的拼音
  /// @return 不带声调的拼音
  static List<String> convertWithoutTone(String pinyinArrayStr) {
    List<String> pinyinArray;
    for (int i = allMarkedVowel.length - 1; i >= 0; i--) {
      int originalChar = allMarkedVowel.codeUnitAt(i);
      double index = (i - i % 4) / 4;
      int replaceChar = allUnmarkedVowel.codeUnitAt(index.toInt());
      pinyinArrayStr = pinyinArrayStr.replaceAll(
          String.fromCharCode(originalChar), String.fromCharCode(replaceChar));
    }
    // 将拼音中的ü替换为v
    pinyinArray = pinyinArrayStr.replaceAll("ü", "v").split(pinyinSeparator);
    // 去掉声调后的拼音可能存在重复，做去重处理
    LinkedHashSet<String> pinyinSet = LinkedHashSet<String>();
    pinyinArray.forEach((value) {
      pinyinSet.add(value);
    });
    return pinyinSet.toList();
  }

  /// 将带声调格式的拼音转换为数字代表声调格式的拼音
  /// @param pinyinArrayStr 带声调格式的拼音
  /// @return 数字代表声调格式的拼音
  static List<String> convertWithToneNumber(String pinyinArrayStr) {
    List<String> pinyinArray = pinyinArrayStr.split(pinyinSeparator);
    for (int i = pinyinArray.length - 1; i >= 0; i--) {
      bool hasMarkedChar = false;
      String originalPinyin = pinyinArray[i].replaceAll('ü', 'v'); // 将拼音中的ü替换为v
      for (int j = originalPinyin.length - 1; j >= 0; j--) {
        int originalChar = originalPinyin.codeUnitAt(j);
        // 搜索带声调的拼音字母，如果存在则替换为对应不带声调的英文字母
        if (originalChar < 'a'.codeUnitAt(0) || originalChar > 'z'.codeUnitAt(0)) {
          int indexInAllMarked = allMarkedVowel.indexOf(String.fromCharCode(originalChar));
          int toneNumber = indexInAllMarked % 4 + 1; // 声调数
          double index = (indexInAllMarked - indexInAllMarked % 4) / 4;
          int replaceChar = allUnmarkedVowel.codeUnitAt(index.toInt());
          pinyinArray[i] = originalPinyin.replaceAll(
                  String.fromCharCode(originalChar), String.fromCharCode(replaceChar)) +
              toneNumber.toString();
          hasMarkedChar = true;
          break;
        }
      }
      if (!hasMarkedChar) {
        // 找不到带声调的拼音字母说明是轻声，用数字5表示
        pinyinArray[i] = originalPinyin + '5';
      }
    }

    return pinyinArray;
  }

  /// 将单个汉字转换成带声调格式的拼音
  /// @param c 需要转换成拼音的汉字
  /// @return 字符串的拼音
  static List<String> convertCharToPinyinArray(String c) {
    return convertToPinyinArray(c, PinyinFormat.WITH_TONE_MARK);
  }

  /// 判断一个汉字是否为多音字
  /// @param c汉字
  /// @return 判断结果，是汉字返回true，否则返回false
  static bool hasMultiPinyin(String c) {
    List<String> pinyinArray = convertCharToPinyinArray(c);
    if (pinyinArray.isNotEmpty) {
      return true;
    }
    return false;
  }

  /// 添加拼音字典
  @Deprecated('replaced by addPinyinMap')
  static void addPinyinDict(List<String> list) {
    addPinyinMap(PinyinResource.getResource(list));
  }

  /// 添加多音字字典
  @Deprecated('replaced by addPhrasePinyinMap')
  static void addMultiPinyinDict(List<String> list) {
    addPhraseMap(PinyinResource.getResource(list));
  }

  /// 添加拼音字典
  static void addPinyinMap(Map<String, String> map) {
    pinyinMap.addAll(map);
  }

  /// 添加多音字字典
  static void addPhraseMap(Map<String, String> map) {
    phraseMap.addAll(map);
  }
}

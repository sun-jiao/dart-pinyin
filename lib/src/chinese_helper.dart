import 'phrase_length.dart';
import 'phrase_converter.dart';
import 'pinyin_resource.dart';

/// Chinese Helper.
class ChineseHelper {
  static int? minPhraseLength;
  static int? maxPhraseLength;

  static Map<String, String>? _tradToSimpMap;

  static Map<String, String> get tradToSimpMap {
    _tradToSimpMap ??= PinyinResource.getTradToSimpResource();
    return _tradToSimpMap!;
  }

  static Map<String, String>? _simpToTradMap;

  static Map<String, String> get simpToTradMap {
    _simpToTradMap ??= PinyinResource.getSimpToTradResource();
    return _simpToTradMap!;
  }

  static Map<String, String>? _phraseMapS2T;

  static Map<String, String> get phraseMapS2T {
    _phraseMapS2T ??= PinyinResource.getPhraseSimpToTradResource();
    return _phraseMapS2T!;
  }

  static Map<String, String>? _phraseMapT2S;

  static Map<String, String> get phraseMapT2S {
    _phraseMapT2S ??= PinyinResource.getPhraseTradToSimpResource();
    return _phraseMapT2S!;
  }

  static bool isChineseCode(int code) =>
      (code == 0x3007) || // "〇" is also a Chinese character  〇也是汉字
      (code >= 0x3400 && code <= 0x4DBF) || // Ext+A
      (code >= 0x4E00 && code <= 0x9FFF) || // CJK Unified Ideographs
      (code >= 0xF900 && code <= 0xFA6D) || // CJK Compatibility Ideographs - Part 1
      (code >= 0xFA70 && code <= 0xFAD9) || // CJK Compatibility Ideographs - Part 2
      (code >= 0x20000 && code <= 0x2A6DF) || // Ext+B
      (code >= 0x2A700 && code <= 0x2B739) || // Ext+C
      (code >= 0x2B740 && code <= 0x2B81D) || // Ext+D
      (code >= 0x2B820 && code <= 0x2CEA1) || // Ext+E
      (code >= 0x2CEB0 && code <= 0x2EBE0) || // Ext+F
      (code >= 0x2EBF0 && code <= 0x2EE5D) || // Ext+I
      (code >= 0x2F800 && code <= 0x2FA1F) || // CJK Compatibility Supplement
      (code >= 0x30000 && code <= 0x3134A) || // Ext+G
      (code >= 0x31350 && code <= 0x323AF); // Ext+H

  /// 判断某个字符是否为汉字
  /// @return 是汉字返回true，否则返回false
  static bool isChinese(String c) {
    try {
      return isChineseCode(c.runes.first);
    } catch (e) {
      return false;
    }
    // a better workaround:
    // return isChineseCode(c.runes.firstOrNull ?? -1);
    // while avoid using firstOrNull for compatible with Dart 2.
  }

  /// 判断某个字符是否为繁体字
  /// @param c 需要判断的字符
  /// @return 是繁体字返回true，否则返回false
  static bool isTraditionalChinese(String c) {
    return tradToSimpMap.containsKey(c);
  }

  /// 判断字符串中是否包含中文
  /// @param str 字符串
  /// @return 包含汉字返回true，否则返回false
  static bool containsChinese(String str) {
    final runes = str.runes;
    for (int i = 0, len = runes.length; i < len; i++) {
      if (isChinese(str[i])) {
        return true;
      }
    }
    return false;
  }

  /// 将单个繁体字转换为简体字
  /// @param c 需要转换的繁体字
  /// @return 转换后的简体字
  static String convertCharToSimplifiedChinese(String c) {
    String? simplifiedChinese = tradToSimpMap[c];
    return simplifiedChinese ?? c;
  }

  /// 将单个简体字转换为繁体字
  /// @param c 需要转换的简体字
  /// @return 转换后的繁体字
  static String convertCharToTraditionalChinese(String c) {
    String? traditionalChinese = simpToTradMap[c];
    return traditionalChinese ?? c;
  }

  /// 将繁体字转换为简体字
  /// @param str 需要转换的繁体字
  /// @return 转换后的简体字
  static String convertToSimplifiedChinese(String str) =>
      _stringConvert(str, phraseMapT2S, convertCharToSimplifiedChinese, minPhraseLengthT2S, maxPhraseLengthT2S);

  /// 将简体字转换为繁体字
  /// @param str 需要转换的简体字
  /// @return 转换后的繁体字
  static String convertToTraditionalChinese(String str) =>
      _stringConvert(str, phraseMapS2T, convertCharToTraditionalChinese, minPhraseLengthS2T, maxPhraseLengthS2T);

  static String _stringConvert(
      String str, Map<String, String> dict, String Function(String) singleCharConvert, int min, int max) {
    StringBuffer sb = StringBuffer();
    final runes = str.runes.toList();
    int i = 0;
    while (i < runes.length) {
      String subStr = String.fromCharCodes(runes.sublist(i));
      String _char = String.fromCharCode(runes[i]);
      bool isHan = ChineseHelper.isChinese(_char);

      PhraseConvert? node = stConvertForPhrase(subStr, dict, min, max);
      if (node == null) {
        if (isHan) {
          sb.write(singleCharConvert.call(String.fromCharCode(runes[i])));
        } else {
          sb.write(_char);
        }
        i++;
      } else {
        sb.write(node.result?.trim());
        i += node.word!.runes.length;
      }
    }

    return sb.toString();
  }

  /// 词组转换
  /// @param str 需要转换的字符串
  /// @param dict 转换词典
  /// @return 转换结果
  static PhraseConvert? stConvertForPhrase(String str, Map<String, String> dict, int min, int max) =>
      convertForPhrase(
        str,
        dict,
        (subStr, result) => result != null && result.isNotEmpty
            ? PhraseConvert(word: subStr, result: result)
            : null,
        minPhraseLength ?? min,
        maxPhraseLength ?? max,
      );

  /// 添加繁体字字典
  static void addSimpToTradMap(Map<String, String> map) {
    simpToTradMap.addAll(map);
  }

  /// 添加简体字字典
  static void addTradToSimpMap(Map<String, String> map) {
    tradToSimpMap.addAll(map);
  }

  /// 添加繁体字字典
  @Deprecated('Replaced by addSimpToTradMap and addTradToSimpMap')
  static void addChineseDict(List<String> list) {
    final map = PinyinResource.getResource(list);
    addTradToSimpMap(map);
    addSimpToTradMap(map.map((key, value) => MapEntry(value, key)));
  }
}

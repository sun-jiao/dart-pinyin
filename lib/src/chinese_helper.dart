import 'package:pinyin/src/pinyin_resource.dart';

/// Chinese Helper.
class ChineseHelper {
  static final Map<String, String> chineseMap = PinyinResource.getChineseResource();

  static bool isChineseCode(int code) =>
      (code == 0x3007) || // 〇也是汉字
      (code >= 0x3400 && code <= 0x4DBF) || // Ext+A
      (code >= 0x4E00 && code <= 0x9FFF) || // CJK Unified Ideographs
      (code >= 0xF900 && code <= 0xFAFF) || // CJK Compatibility Ideographs
      (code >= 0x20000 && code <= 0x2A6DF) || // Ext+B
      (code >= 0x2A700 && code <= 0x2B73F) || // Ext+C
      (code >= 0x2B740 && code <= 0x2B81F) || // Ext+D
      (code >= 0x2B820 && code <= 0x2CEAF) || // Ext+E
      (code >= 0x2CEB0 && code <= 0x2EBEF) || // Ext+F
      (code >= 0x2EBF0 && code <= 0x2EE5D) || // Ext+I
      (code >= 0x30000 && code <= 0x3134F) || // Ext+G
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
    return chineseMap.containsKey(c);
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
    String? simplifiedChinese = chineseMap[c];
    return simplifiedChinese ?? c;
  }

  /// 将单个简体字转换为繁体字
  /// @param c 需要转换的简体字
  /// @return 转换后的繁体字
  static String convertCharToTraditionalChinese(String c) {
    if (chineseMap.containsValue(c)) {
      Iterable<MapEntry<String, String>> iterable = chineseMap.entries;
      for (int i = 0, length = iterable.length; i < length; i++) {
        MapEntry<String, String> entry = iterable.elementAt(i);
        if (entry.value == c) {
          return entry.key;
        }
      }
    }
    return c;
  }

  /// 将繁体字转换为简体字
  /// @param str 需要转换的繁体字
  /// @return 转换后的简体字
  static String convertToSimplifiedChinese(String str) {
    StringBuffer sb = StringBuffer();
    for (int i = 0, len = str.length; i < len; i++) {
      sb.write(convertCharToSimplifiedChinese(str[i]));
    }
    return sb.toString();
  }

  /// 将简体字转换为繁体字
  /// @param str 需要转换的简体字
  /// @return 转换后的繁体字
  static String convertToTraditionalChinese(String str) {
    StringBuffer sb = StringBuffer();
    for (int i = 0, len = str.length; i < len; i++) {
      sb.write(convertCharToTraditionalChinese(str[i]));
    }
    return sb.toString();
  }

  /// 添加繁体字字典
  static void addChineseDict(List<String> list) {
    chineseMap.addAll(PinyinResource.getResource(list));
  }
}

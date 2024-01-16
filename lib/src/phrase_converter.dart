import 'dart:math';

@Deprecated('replaced by PhrasePinyin')
class MultiPinyin extends PhraseConvert {
  @Deprecated('replaced by PhrasePinyin')
  String? word;
  @Deprecated('replaced by PhrasePinyin')
  String? result;

  @Deprecated('replaced by result')
  String? get pinyin => result;
  @Deprecated('replaced by result')
  set pinyin(String? p) {
    result = p;
  }

  @Deprecated('replaced by PhrasePinyin')
  MultiPinyin({this.word, String? pinyin}):result=pinyin;

  @override
  @Deprecated('replaced by PhrasePinyin')
  String toString() => super.toString();
}

/// 多音字
class PhraseConvert {
  String? word;
  String? result;

  PhraseConvert({this.word, this.result});

  @override
  String toString() {
    StringBuffer sb = StringBuffer('{');
    sb.write("\"word\":\"$word\"");
    sb.write(",\"result\":\"$result\"");
    sb.write('}');
    return sb.toString();
  }
}

PhraseConvert? convertForPhrase(String str, Map<String, String> dict, PhraseConvert? Function(String, String?) getResult, int minPhraseLength, int maxPhraseLength) {
  final runes = str.runes.toList();

  if (runes.length < minPhraseLength) return null;

  for (int end = min(maxPhraseLength, runes.length);
  (end >= minPhraseLength);
  end--) {
    String subStr = String.fromCharCodes(runes.sublist(0, end));
    String? result = dict[subStr];
    final convertResult = getResult.call(subStr, result);
    if (convertResult != null) {
      return convertResult;
    }
  }
  return null;
}
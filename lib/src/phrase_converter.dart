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

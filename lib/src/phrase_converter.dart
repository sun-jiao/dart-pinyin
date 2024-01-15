@Deprecated('replaced by PhrasePinyin')
class MultiPinyin extends PhrasePinyin {
  @Deprecated('replaced by PhrasePinyin')
  String? word;
  @Deprecated('replaced by PhrasePinyin')
  String? pinyin;

  @Deprecated('replaced by PhrasePinyin')
  MultiPinyin({this.word, this.pinyin});

  @override
  @Deprecated('replaced by PhrasePinyin')
  String toString() => super.toString();
}

/// 多音字
class PhrasePinyin {
  String? word;
  String? pinyin;

  PhrasePinyin({this.word, this.pinyin});

  @override
  String toString() {
    StringBuffer sb = StringBuffer('{');
    sb.write("\"word\":\"$word\"");
    sb.write(",\"pinyin\":\"$pinyin\"");
    sb.write('}');
    return sb.toString();
  }
}

/// 多音字
class PhraseSTConvert {
  String? word;
  String? result;

  PhraseSTConvert({this.word, this.result});

  @override
  String toString() {
    StringBuffer sb = StringBuffer('{');
    sb.write("\"word\":\"$word\"");
    sb.write(",\"converted\":\"$result\"");
    sb.write('}');
    return sb.toString();
  }
}
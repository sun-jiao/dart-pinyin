void main() {
  const String simpleChineseRegex = "([\u3007\u4E00-\u9FFF\u3400-\u4DBF\uF900-\uFAFF]|[\uD840-\uD887][\uDC00-\uDFFF]|\uD888[\uDC00-\uDFAF])";
  final RegExp simpleChineseRegexp = RegExp(simpleChineseRegex);
  const String chineseRegex = "([\u3007\u4E00-\u9FFF\u3400-\u4DBF\uF900-\uFAFF]|[\uD840-\uD868\uD86A-\uD86C\uD86F-\uD872\uD874-\uD879\uD880-\uD883\uD885-\uD887][\uDC00-\uDFFF]|\uD869[\uDC00-\uDEDF\uDF00-\uDFFF]|\uD86D[\uDC00-\uDF39\uDF40-\uDFFF]|\uD86E[\uDC00-\uDC1D\uDC20-\uDFFF]|\uD873[\uDC00-\uDEA1\uDEB0-\uDFFF]|\uD87A[\uDC00-\uDFE0\uDFF0-\uDFFF]|\uD87B[\uDC00-\uDE50]|\uD87E[\uDC00-\uDE1F]|\uD884[\uDC00-\uDF4A\uDF50-\uDFFF|\uD888[\uDC00-\uDFAF])";
  final RegExp chineseRegexp = RegExp(chineseRegex);
  final testStr = "㒔一斣筓答辶𠂇𤥶𪛕𪡆𪡇𫟶𬾦𬾧𮷕𮷖瑜𰉾𰉿𱑾";
  print(chineseRegexp.allMatches(testStr).toList().map((e) => testStr.substring(e.start, e.end)));
  print(simpleChineseRegexp.allMatches(testStr).toList().map((e) => testStr.substring(e.start, e.end)));
}
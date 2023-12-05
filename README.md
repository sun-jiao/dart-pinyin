# dart-pinyin (Dart package for converting Chinese characters to Pinyin and Zhuyin)

pinyin is a dart package for converting Chinese characters to Pinyin and Zhuyin, with reference to java library [jpinyin](https://github.com/SilenceDut/jpinyin).  
①Accurate, complete dictionary
②Swift convertion
③Multiple formations: without tone, with tone mark, with tone number, abbr  
④Heteronym support, including words, place names, and chengyus
⑤Simplified and traditional Chinese convertion
⑥Custom dictionary support
⑦Zhuyin (bopomofo) support, with reference to python library[python-zhuyin](https://github.com/rku1999/python-zhuyin)，authored by @w830207

pinyin是一个汉字转拼音的Dart Package. 主要参考Java开源类库[jpinyin](https://github.com/SilenceDut/jpinyin).  
①准确、完善的字库  
②拼音转换速度快  
③支持多种拼音输出格式：带音标、不带音标、数字表示音标以及拼音首字母输出格式  
④支持常见多音字的识别，其中包括词组、成语、地名等  
⑤简繁体中文转换  
⑥支持添加用户自定义字典  
⑦支援漢字轉注音 參考自[python-zhuyin](https://github.com/rku1999/python-zhuyin)，authored by @w830207

This package is originally authored by @Sky24n, @tanghongliang, @duwen and @thl from @flutterchina. We are deeply grateful for their contributions. 

## Pub

```yaml
dependencies:
  pinyin: ^2.0.2  #latest version
```

## Example

``` dart

// Import package
import 'package:pinyin/pinyin.dart';

String text = "天府广场";

//字符串拼音首字符
PinyinHelper.getShortPinyin(str); // tfgc

//字符串首字拼音
PinyinHelper.getFirstWordPinyin(str); // tian

//无法转换拼音会 throw PinyinException
PinyinHelper.getPinyin(text);
PinyinHelper.getPinyin(text, separator: " ", format: PinyinFormat.WITHOUT_TONE);//tian fu guang chang

//无法转换拼音 默认用' '替代
PinyinHelper.getPinyinE(text);
PinyinHelper.getPinyinE(text, separator: " ", defPinyin: '#', format: PinyinFormat.WITHOUT_TONE);//tian fu guang chang

//添加用户自定义字典
List<String> dict1 = ['耀=yào','老=lǎo'];
PinyinHelper.addPinyinDict(dict1);//拼音字典
List<String> dict2 = ['奇偶=jī,ǒu','成都=chéng,dū'];
PinyinHelper.addMultiPinyinDict(dict2);//多音字词组字典
List<String> dict3 = ['倆=俩','們=们'];
ChineseHelper.addChineseDict(dict3);//繁体字字典

```

## Screenshots
![](https://s1.ax1x.com/2020/11/05/B2fwQO.gif)

## Changelog
Please see the [Changelog](CHANGELOG.md) page to know what's recently changed.

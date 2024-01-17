import 'package:flutter/material.dart';
import 'package:pinyin/pinyin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _inputController = TextEditingController();
  String result1 = '';
  String result2 = '';
  String result3 = '';

  void _onSubmit() {
    // 调用你的三个函数，并更新结果变量
    // 假设 func1、func2、func3 是你已经实现的函数
    result1 = PinyinHelper.getPinyin(_inputController.text);
    result2 = ChineseHelper.convertToSimplifiedChinese(_inputController.text);
    result3 = ChineseHelper.convertToTraditionalChinese(_inputController.text);

    // 刷新界面
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 示例'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(labelText: '输入文本'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _onSubmit,
              child: const Text('获取结果'),
            ),
            const SizedBox(height: 16.0),
            Text('Func1 输出: $result1'),
            Text('Func2 输出: $result2'),
            Text('Func3 输出: $result3'),
          ],
        ),
      ),
    );
  }
}

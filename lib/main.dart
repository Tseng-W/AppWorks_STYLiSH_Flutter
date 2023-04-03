import 'package:flutter/material.dart';
import 'package:stylish_wen/pages/category_lists.dart';
import 'package:stylish_wen/pages/hot_product_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: const ProviderScope(child: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Image.asset(
            'images/logo.png',
            height: 36,
            fit: BoxFit.contain,
          )),
      body: Column(
        children: const [
          HotProductsList(),
          CategoryLists(),
        ],
      ),
    );
  }
}

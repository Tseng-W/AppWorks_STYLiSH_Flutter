import 'package:flutter/material.dart';
import 'package:stylish_wen/pages/category_lists.dart';
import 'package:stylish_wen/pages/hot_product_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final LoadingStatusNotifierProvider =
    StateNotifierProvider<LoadingStatusNotifier, bool>(
        (ref) => LoadingStatusNotifier());

class LoadingStatusNotifier extends StateNotifier<bool> {
  LoadingStatusNotifier() : super(false);

  void startLoading() {
    state = true;
  }

  void endLoading() {
    state = false;
  }
}

final appBarProvider = Provider((ref) => AppBar(
        title: Image.asset(
      'images/logo.png',
      height: 36,
      fit: BoxFit.contain,
    )));

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
      theme: ThemeData(colorSchemeSeed: Colors.blueGrey, useMaterial3: true),
      home: const ProviderScope(child: MyHomePage()),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(LoadingStatusNotifierProvider);
    return Scaffold(
      appBar: ref.watch(appBarProvider),
      body: Stack(
        children: [
          Column(
            children: const [
              HotProductsList(),
              CategoryLists(),
            ],
          ),
          if (loading)
            Positioned.fill(
              child: Container(
                color: Colors.grey.withOpacity(0.2),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}

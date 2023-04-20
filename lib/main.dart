import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stylish_wen/bloc/product_detail_bloc.dart';
import 'package:stylish_wen/bloc/hot_product_bloc.dart';
import 'package:stylish_wen/bloc/singleton_cubit.dart';
import 'package:stylish_wen/pages/category_lists.dart';
import 'package:stylish_wen/pages/hot_product_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum LoadingStatus { loading, loaded }

class LoadingCubit extends Cubit<bool> {
  LoadingCubit() : super(false);
  void startLoading() => emit(true);
  void endLoading() => emit(false);
}

void main() {
  runApp(BlocProvider(
      create: (context) => SingletonCubit(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorSchemeSeed: Colors.blueGrey, useMaterial3: true),
      home: BlocProvider(
          create: (_) => LoadingCubit(), child: const MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  String _batteryLevel = '';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingCubit, bool>(
      builder: (context, isLoading) {
        return Scaffold(
          appBar: AppBar(
              title: Image.asset(
            'images/logo.png',
            height: 36,
            fit: BoxFit.contain,
          )),
          body: Stack(
            children: [
              Column(
                children: [
                  BlocProvider(
                      create: (_) => HotProductBloc(
                          repo:
                              context.read<SingletonCubit>().state.apiService),
                      child: const HotProductsList()),
                  BlocProvider(
                    create: (context) => ProductDetailBloc(
                        repo: context.read<SingletonCubit>().state.apiService),
                    child: const CategoryLists(),
                  ),
                  ElevatedButton(
                    onPressed: _getBatteryLevel,
                    child: const Text('Get Battery Level'),
                  ),
                  Text(_batteryLevel),
                ],
              ),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.grey.withOpacity(0.2),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

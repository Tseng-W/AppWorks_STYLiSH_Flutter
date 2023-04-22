import 'package:flutter/material.dart';
import 'package:stylish_wen/bloc/singleton_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_wen/bloc/loading_cubit.dart';
import 'package:stylish_wen/pages/home.dart';
import 'routes.dart';

void main() {
  runApp(BlocProvider(
      create: (context) => SingletonCubit(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(colorSchemeSeed: Colors.blueGrey, useMaterial3: true),
      routerConfig: router,
    );
  }
}

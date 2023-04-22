import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_wen/bloc/hot_product_bloc.dart';
import 'package:stylish_wen/bloc/loading_cubit.dart';
import 'package:stylish_wen/bloc/product_detail_bloc.dart';
import 'package:stylish_wen/bloc/singleton_cubit.dart';
import 'package:stylish_wen/pages/category_lists.dart';
import 'package:stylish_wen/pages/hot_product_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
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

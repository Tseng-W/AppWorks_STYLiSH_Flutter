import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:stylish_wen/pages/category_lists.dart';
import 'package:stylish_wen/pages/home.dart';
import 'package:stylish_wen/pages/hot_product_list.dart';
import 'package:stylish_wen/pages/product_detail.dart';
import 'bloc/loading_cubit.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) =>
        BlocProvider(create: (_) => LoadingCubit(), child: const MyHomePage()),
  ),
  GoRoute(
      path: '/detail/:productId',
      name: "detail",
      builder: (context, state) {
        final productId = state.params['productId']!;
        return BlocProvider(
          create: (_) => LoadingCubit(),
          child: ProductDetail(
            productId: int.parse(productId),
          ),
        );
      }),
]);

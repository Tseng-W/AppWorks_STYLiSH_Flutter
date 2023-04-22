import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stylish_wen/pages/cart.dart';
import 'package:stylish_wen/pages/home.dart';
import 'package:stylish_wen/pages/product_detail.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const MyHomePage(),
    routes: [
      GoRoute(
          path: 'cart',
          name: 'cart',
          builder: (context, state) {
            // TODO: Implement check out API
            return Cart();
          })
    ],
  ),
  GoRoute(
    path: '/detail/:productId',
    name: "detail",
    builder: (context, state) {
      final productId = state.params['productId']!;
      return ProductDetail(
        productId: int.parse(productId),
      );
    },
  )
]);

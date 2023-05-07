import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stylish_wen/Pages/device_enumeration.dart';
import 'package:stylish_wen/Pages/get_user_media.dart';
import 'main.dart';

typedef RouteCallback = void Function(BuildContext context);

class RouteItem {
  RouteItem({
    required this.title,
    this.subtitle,
    this.push,
  });

  final String title;
  final String? subtitle;
  final RouteCallback? push;
}

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/getUserMedia',
      name: 'getUserMedia',
      builder: (context, state) => const GetUserMediaPage(),
    ),
    GoRoute(
      path: '/deviceEnumerationView',
      name: 'deviceEnumerationView',
      builder: (context, state) => const DeviceEnumerationView(),
    )
  ],
);

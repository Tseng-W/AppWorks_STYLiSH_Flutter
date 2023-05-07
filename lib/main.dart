import 'package:flutter/material.dart';
import 'package:stylish_wen/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final mainRouteProvider = Provider(
  (_) {
    return <RouteItem>[
      RouteItem(
        title: 'GetUserMedia',
        push: (context) {
          context.pushNamed('getUserMedia');
        },
      ),
      RouteItem(
          title: 'DeviceEnumerationView',
          push: (context) {
            context.pushNamed('deviceEnumerationView');
          })
    ];
  },
);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(mainRouteProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter WebRTC Demo')),
      body: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0.0),
          itemCount: items.length,
          itemBuilder: (context, i) {
            return _buildRow(context, items[i]);
          }),
    );
  }

  ListBody _buildRow(context, item) {
    return ListBody(children: <Widget>[
      ListTile(
        title: Text(item.title),
        onTap: () => item.push(context),
        trailing: const Icon(Icons.arrow_right),
      ),
      const Divider()
    ]);
  }
}

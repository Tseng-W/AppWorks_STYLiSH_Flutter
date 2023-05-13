import 'package:flutter/material.dart';
import 'package:stylish_wen/router.dart';
import 'Pages/body_tracker_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<RouteItem> items = [];

  @override
  void initState() {
    super.initState();
    _initialItems();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('ARKit demo'),
          ),
          body: SafeArea(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, i) => _buildListRow(context, items[i]),
            ),
          )),
    );
  }

  _initialItems() {
    items = [
      RouteItem(
          title: 'Body tracker demo',
          push: (ctx) {
            Navigator.push(ctx,
                MaterialPageRoute(builder: (context) => BodyTrackerView()));
          })
    ];
  }

  ListBody _buildListRow(context, item) {
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

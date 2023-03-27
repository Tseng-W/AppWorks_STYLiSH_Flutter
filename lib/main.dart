import 'dart:math';

import 'package:flutter/material.dart';

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
      home: const MyHomePage(),
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

class CategoryLists extends StatelessWidget {
  const CategoryLists({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: const [
          Expanded(
            child: CategoryList(),
          ),
          Expanded(
            child: CategoryList(),
          ),
          Expanded(
            child: CategoryList(),
          ),
        ],
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const padding = 8.0;

    return Column(
      children: [
        Text(
          '女裝',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Expanded(
          child: ListView.builder(itemBuilder: (context, index) {
            return const Padding(
                padding: EdgeInsets.only(
                    left: padding,
                    right: padding,
                    top: padding / 2,
                    bottom: padding / 2),
                child: CategoryCell());
          }),
        ),
      ],
    );
  }
}

class CategoryCell extends StatelessWidget {
  const CategoryCell({super.key});

  @override
  Widget build(BuildContext context) {
    const padding = 8.0;
    const borderRadius = 8.0;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(
          height: 150,
          child: Row(
            children: [
              Image.asset(
                'images/nope.jpg',
                fit: BoxFit.fitHeight,
              ),
              Padding(
                padding: const EdgeInsets.all(padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UNIQLO 特級級輕羽絨外套',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'NT\$ 233',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HotProductsList extends StatelessWidget {
  const HotProductsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 1000,
        itemBuilder: (context, index) {
          return const Padding(
            padding:
                EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0, bottom: 16.0),
            child: HotProduct(),
          );
        },
      ),
    );
  }
}

class HotProduct extends StatelessWidget {
  const HotProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(
        'images/doge.jpg',
        width: 300,
        fit: BoxFit.cover,
      ),
    );
  }
}

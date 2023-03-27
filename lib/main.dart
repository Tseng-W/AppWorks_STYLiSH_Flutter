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
    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / size.height;

    const mockListAmout = 10;
    final mockCategoryList = List.generate(
        mockListAmout,
        (index) =>
            CategoryItem('UNIQLO 特級級輕羽絨外套', index + 1, 'images/nope.jpg'));

    final List<CategoryData> mockCategoryData = [
      CategoryData('女裝', mockCategoryList),
      CategoryData('男裝', mockCategoryList),
      CategoryData('飾品', mockCategoryList),
    ];

    if (aspectRatio > 1) {
      return Expanded(
        child: Row(
          children: [
            Expanded(child: CategoryList(categoryData: mockCategoryData[0])),
            Expanded(child: CategoryList(categoryData: mockCategoryData[1])),
            Expanded(child: CategoryList(categoryData: mockCategoryData[2])),
          ],
        ),
      );
    } else {
      return Expanded(
        child: Row(
          children: [
            Expanded(
                child: CategoryList(
                    categoryData: CategoryData('女裝', mockCategoryList))),
          ],
        ),
      );
    }
  }
}

class CategoryData {
  final String categoryType;
  final List<CategoryItem> items;

  CategoryData(this.categoryType, this.items);
}

class CategoryItem {
  final String title;
  final int price;
  final String image;

  CategoryItem(this.title, this.price, this.image);
}

class CategoryList extends StatelessWidget {
  const CategoryList({
    super.key,
    required this.categoryData,
  });

  final CategoryData categoryData;

  @override
  Widget build(BuildContext context) {
    const padding = 8.0;

    return Column(
      children: [
        Text(
          categoryData.categoryType,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.only(
                        left: padding,
                        right: padding,
                        top: padding / 2,
                        bottom: padding / 2),
                    child: CategoryCell(
                      categoryItem: categoryData.items[index],
                    ));
              }),
        ),
      ],
    );
  }
}

class CategoryCell extends StatelessWidget {
  const CategoryCell({super.key, required this.categoryItem});

  final CategoryItem categoryItem;

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
                categoryItem.image,
                fit: BoxFit.fitHeight,
              ),
              const SizedBox(
                width: padding,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryItem.title,
                      style: Theme.of(context).textTheme.titleLarge,
                      softWrap: true,
                    ),
                    Text(
                      'NT\$ ${categoryItem.price}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              )
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
        scrollDirection: Axis.horizontal,
        itemCount: 10,
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

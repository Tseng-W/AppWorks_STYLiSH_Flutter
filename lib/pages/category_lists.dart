import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stylish_wen/data/category_model.dart';

final categoryListViewModelProvider =
    StateNotifierProvider<CategoryListViewModel, List<CategoryData>>(
  (ref) => CategoryListViewModel(),
);

class CategoryListViewModel extends StateNotifier<List<CategoryData>> {
  CategoryListViewModel() : super([]);

  final mockListCount = 10;

  CategoryData generateMockList(String categoryTitle) {
    return CategoryData(
        categoryTitle,
        List.generate(
            mockListCount,
            (index) => CategoryItem('UNIQLO 特級級輕羽絨外套', index + 1,
                Image.asset('images/nope.jpg'), index)));
  }

  void fetchCategoryList() async {
    await Future.delayed(const Duration(seconds: 2));
    state = [
      generateMockList('女裝'),
      generateMockList('男裝'),
      generateMockList('飾品'),
    ];
  }
}

class CategoryLists extends ConsumerWidget {
  const CategoryLists({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / size.height;

    return Consumer(builder: (context, ref, child) {
      final list = ref.watch(categoryListViewModelProvider);
      ref.watch(categoryListViewModelProvider.notifier).fetchCategoryList();

      if (list.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return (aspectRatio > 1)
          ? WideCategoryLists(categoryLists: list)
          : NarrowCategoryLists(categoryLists: list);
    });
  }
}

class NarrowCategoryLists extends StatelessWidget {
  const NarrowCategoryLists({
    super.key,
    required this.categoryLists,
  });

  final List<CategoryData> categoryLists;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: categoryLists.length,
            itemBuilder: (context, index) {
              return CategoryList(
                categoryData: categoryLists[index],
                needShrink: true,
              );
            }));
  }
}

class WideCategoryLists extends StatelessWidget {
  const WideCategoryLists({
    super.key,
    required this.categoryLists,
  });

  final List<CategoryData> categoryLists;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
          children: categoryLists
              .map((e) => Expanded(
                      child: CategoryList(
                    categoryData: e,
                    needShrink: false,
                  )))
              .toList()),
    );
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({
    super.key,
    required this.categoryData,
    required this.needShrink,
  });

  final CategoryData categoryData;
  final bool needShrink;

  @override
  Widget build(BuildContext context) {
    const padding = 8.0;

    final listViewBuilder = ListView.builder(
        itemCount: categoryData.items.length,
        shrinkWrap: needShrink,
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
        });

    return Column(
      children: [
        Text(
          categoryData.categoryType,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        needShrink ? listViewBuilder : Expanded(child: listViewBuilder)
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
              const Placeholder(
                fallbackHeight: 240,
                fallbackWidth: 100,
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

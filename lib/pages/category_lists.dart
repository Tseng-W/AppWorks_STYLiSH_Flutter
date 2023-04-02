import 'package:flutter/material.dart';
import 'package:stylish_wen/data/category_model.dart';

class CategoryLists extends StatelessWidget {
  const CategoryLists({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / size.height;

    const mockListAmount = 10;
    final mockCategoryList = List.generate(
        mockListAmount,
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
            Expanded(
                child: CategoryList(
              categoryData: mockCategoryData[0],
              needShrink: false,
            )),
            Expanded(
                child: CategoryList(
                    categoryData: mockCategoryData[1], needShrink: false)),
            Expanded(
                child: CategoryList(
                    categoryData: mockCategoryData[2], needShrink: false)),
          ],
        ),
      );
    } else {
      return Expanded(
        child: Row(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: mockCategoryData.length,
                    itemBuilder: (context, index) {
                      return CategoryList(
                        categoryData: mockCategoryData[index],
                        needShrink: true,
                      );
                    }))
          ],
        ),
      );
    }
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

    if (needShrink) {
      return Column(
        children: [
          Text(
            categoryData.categoryType,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          listViewBuilder
        ],
      );
    } else {
      return Column(
        children: [
          Text(
            categoryData.categoryType,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Expanded(
            child: listViewBuilder,
          ),
        ],
      );
    }
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

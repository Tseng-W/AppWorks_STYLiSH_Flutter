import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stylish_wen/data/category_model.dart';
import 'package:stylish_wen/data/product_detail_model.dart';
import 'package:stylish_wen/main.dart';
import 'package:stylish_wen/model/api_service.dart';
import 'package:stylish_wen/data/product_detail_model.dart';
import 'package:stylish_wen/pages/product_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final categoryListViewModelProvider =
    StateNotifierProvider<CategoryListViewModel, List<CategoryData>>(
  (ref) => CategoryListViewModel(ref.read(apiServiceProvider)),
);

class CategoryListViewModel extends StateNotifier<List<CategoryData>> {
  CategoryListViewModel(this._apiService) : super([]);

  final APIServiceProtocol _apiService;

  void fetchCategoryList() async {
    await Future.delayed(const Duration(seconds: 1));
    state = await _apiService.fetchCategoryList();
  }

  Future<ProductDetailModel> fetchProductDetail(String uuid) async {
    await Future.delayed(const Duration(seconds: 1));
    return await _apiService.fetchProductDetail(uuid);
  }
}

class CategoryLists extends ConsumerWidget {
  const CategoryLists({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / size.height;

    ref.read(categoryListViewModelProvider.notifier).fetchCategoryList();

    return Consumer(builder: (context, ref, child) {
      final list = ref.watch(categoryListViewModelProvider);

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
              .map((list) => Expanded(
                      child: CategoryList(
                    categoryData: list,
                    needShrink: false,
                  )))
              .toList()),
    );
  }
}

class CategoryList extends ConsumerWidget {
  const CategoryList({
    super.key,
    required this.categoryData,
    required this.needShrink,
  });

  final CategoryData categoryData;
  final bool needShrink;

  @override
  Widget build(context, ref) {
    return BlocBuilder<LoadingCubit, bool>(builder: ((context, state) {
      final viewModel = ref.read(categoryListViewModelProvider.notifier);

      final listViewBuilder = ListView.builder(
          itemCount: categoryData.items.length,
          shrinkWrap: needShrink,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  context.read<LoadingCubit>().startLoading();
                  viewModel
                      .fetchProductDetail(categoryData.items[index].uuid)
                      .then((model) {
                    context.read<LoadingCubit>().endLoading();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProviderScope(
                        child: ProductDetail(
                          model: model,
                        ),
                      );
                    }));
                  });
                },
                child: CategoryCell(
                  categoryItem: categoryData.items[index],
                ));
          });

      return Column(
        children: [
          Card(
            color: Theme.of(context).dialogBackgroundColor,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
              child: Text(
                categoryData.categoryType,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          needShrink ? listViewBuilder : Expanded(child: listViewBuilder)
        ],
      );
    }));
  }
}

class CategoryCell extends StatelessWidget {
  const CategoryCell({super.key, required this.categoryItem});

  final CategoryItem categoryItem;

  @override
  Widget build(BuildContext context) {
    const padding = 8.0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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

import 'package:flutter/material.dart';
import 'package:stylish_wen/bloc/category_list_bloc.dart' as category;
import 'package:stylish_wen/bloc/product_detail_bloc.dart';
import 'package:stylish_wen/data/category_model.dart';
import 'package:stylish_wen/main.dart';
import 'package:stylish_wen/model/api_service.dart';
import 'package:stylish_wen/pages/product_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_wen/bloc/product_detail_bloc.dart' as product;

class CategoryLists extends StatelessWidget {
  const CategoryLists({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / size.height;

    return BlocBuilder<category.CategoryListBloc, category.CategoryListState>(
        builder: (context, state) {
      if (state is category.Success) {
        return BlocProvider(
          create: (context) => ProductDetailBloc(repo: MockAPIService()),
          child: (aspectRatio > 1)
              ? WideCategoryLists(categoryLists: state.list)
              : NarrowCategoryLists(categoryLists: state.list),
        );
      } else if (state is category.Initial) {
        context
            .read<category.CategoryListBloc>()
            .add(category.CategoryListEvent.fetch);
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is category.Failure) {
        context
            .read<category.CategoryListBloc>()
            .add(category.CategoryListEvent.fetch);
        return Center(
          child: Text('${state.message} error.'),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
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
        child: BlocListener(
      bloc: BlocProvider.of<ProductDetailBloc>(context),
      listener: (context, state) {
        if (state is product.Success) {
          context.read<LoadingCubit>().endLoading();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ProductDetail(
              model: state.model,
            );
          }));
        }
      },
      child: Row(
          children: categoryLists
              .map((list) => Expanded(
                      child: CategoryList(
                    categoryData: list,
                    needShrink: false,
                  )))
              .toList()),
    ));
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
  Widget build(context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: ((context, state) {
      final listViewBuilder = ListView.builder(
          itemCount: categoryData.items.length,
          shrinkWrap: needShrink,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  context.read<LoadingCubit>().startLoading();
                  context
                      .read<ProductDetailBloc>()
                      .add(categoryData.items[index].uuid);
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

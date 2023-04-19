import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stylish_wen/bloc/category_list_bloc.dart';
import 'package:stylish_wen/bloc/product_detail_bloc.dart' as detail;
import 'package:stylish_wen/bloc/singleton_cubit.dart';
import 'package:stylish_wen/data/product.dart';
import 'package:stylish_wen/main.dart';
import 'package:stylish_wen/model/request.dart';
import 'package:stylish_wen/pages/product_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_wen/bloc/product_detail_bloc.dart' as product;

class CategoryLists extends StatelessWidget {
  const CategoryLists({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / size.height;

    return BlocListener(
      bloc: BlocProvider.of<detail.ProductDetailBloc>(context),
      listener: (context, state) {
        if (state is product.Success) {
          context.read<LoadingCubit>().endLoading();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ProductDetail(
              product: state.model,
            );
          }));
        }
      },
      child: (aspectRatio > 1)
          ? const WideCategoryLists(
              productTypes: [
                ProductListType.women,
                ProductListType.men,
                ProductListType.accessories
              ],
            )
          : const NarrowCategoryLists(
              productType: ProductListType.all,
            ),
    );
  }
}

class NarrowCategoryLists extends StatelessWidget {
  const NarrowCategoryLists({
    super.key,
    required this.productType,
  });

  final ProductListType productType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryListBloc(
        repo: context.read<SingletonCubit>().state.apiService,
        type: productType,
      ),
      child: Expanded(
        child: BlocBuilder<CategoryListBloc, CategoryListState>(
          builder: (context, state) {
            if (state is Initial) {
              context.read<CategoryListBloc>().add(CategoryListEvent.fetch);
            } else if (state is Failure) {
              return Center(
                child: TextButton(
                    onPressed: () {
                      context
                          .read<CategoryListBloc>()
                          .add(CategoryListEvent.fetch);
                    },
                    child: const Text('Retry')),
              );
            } else if (state is Success) {
              Map<String, List<Product>> groupedProduct = {};
              for (var product in state.list.products) {
                if (groupedProduct.containsKey(product.category) == false) {
                  groupedProduct[product.category] = [];
                }
                groupedProduct[product.category]!.add(product);
              }
              final products = groupedProduct.values.map(
                (products) {
                  return PagedProduct(products, 0);
                },
              ).toList();
              return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return CategoryList(
                      pagedProduct: products[index],
                      needShrink: true,
                    );
                  });
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class WideCategoryLists extends StatelessWidget {
  const WideCategoryLists({
    super.key,
    required this.productTypes,
  });

  final List<ProductListType> productTypes;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...productTypes.map(
            (type) {
              return BlocProvider(
                create: (context) => CategoryListBloc(
                    repo: context.read<SingletonCubit>().state.apiService,
                    type: type),
                child: Expanded(
                  child: BlocBuilder<CategoryListBloc, CategoryListState>(
                    builder: (context, state) {
                      if (state is Initial) {
                        context
                            .read<CategoryListBloc>()
                            .add(CategoryListEvent.fetch);
                      } else if (state is Failure) {
                        return Center(
                          child: TextButton(
                              onPressed: () {
                                context
                                    .read<CategoryListBloc>()
                                    .add(CategoryListEvent.fetch);
                              },
                              child: const Text('Retry')),
                        );
                      } else if (state is Success) {
                        return CategoryList(
                          pagedProduct: state.list,
                          needShrink: false,
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({
    super.key,
    required this.pagedProduct,
    required this.needShrink,
  });

  final PagedProduct pagedProduct;
  final bool needShrink;

  @override
  Widget build(context) {
    return BlocBuilder<detail.ProductDetailBloc, detail.ProductDetailState>(
        builder: ((context, state) {
      final listViewBuilder = ListView.builder(
          itemCount: pagedProduct.products.length,
          shrinkWrap: needShrink,
          physics: needShrink ? const NeverScrollableScrollPhysics() : null,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  context.read<LoadingCubit>().startLoading();
                  context
                      .read<detail.ProductDetailBloc>()
                      .add(pagedProduct.products[index].id);
                },
                child: CategoryCell(
                  product: pagedProduct.products[index],
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
                pagedProduct.products.first.category,
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
  const CategoryCell({super.key, required this.product});

  final Product product;

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
              CachedNetworkImage(
                imageUrl: product.mainImage,
                progressIndicatorBuilder: (context, url, progress) =>
                    CircularProgressIndicator(
                  value: progress.progress,
                ),
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
                      product.title,
                      style: Theme.of(context).textTheme.titleLarge,
                      softWrap: true,
                    ),
                    Text(
                      'NT\$ ${product.price}',
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

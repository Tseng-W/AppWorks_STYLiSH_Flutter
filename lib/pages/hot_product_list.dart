import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stylish_wen/data/hots.dart';
import 'package:stylish_wen/bloc/hot_product_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_wen/data/product.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HotProductsList extends StatelessWidget {
  const HotProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildList(List<Hots> list) {
      final products = list.map((e) => e.products).expand((i) => i).toList();
      return SizedBox(
        height: 200,
        child: list.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 16.0, bottom: 16.0),
                    child: HotProduct(
                      product: products[index],
                    ),
                  );
                },
              ),
      );
    }

    return BlocBuilder<HotProductBloc, HotProductState>(
      builder: (context, state) {
        if (state is Success) {
          return buildList(state.list);
        } else if (state is Initial) {
          context.read<HotProductBloc>().add(HotProductEvent.fetch);
          return buildList(state.list);
        } else if (state is Failure) {
          context.read<HotProductBloc>().add(HotProductEvent.fetch);
          return const Center(
            child: Text('Something went wrong'),
          );
        } else {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
      },
    );
  }
}

class HotProduct extends StatelessWidget {
  const HotProduct({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed('shopMap'),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImage(
            imageUrl: product.mainImage,
            progressIndicatorBuilder: (context, url, progress) =>
                _sizedContainer(
              CircularProgressIndicator(
                value: progress.progress,
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )),
    );
  }

  Widget _sizedContainer(Widget child) {
    return SizedBox(
      width: 100,
      height: 200,
      child: Center(child: child),
    );
  }
}

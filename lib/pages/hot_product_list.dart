import 'package:flutter/material.dart';
import 'package:stylish_wen/data/hot_product_model.dart';
import 'package:stylish_wen/bloc/hot_product_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HotProductsList extends StatelessWidget {
  const HotProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildList(List<HotProductModel> list) {
      return SizedBox(
        height: 200,
        child: list.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 16.0, bottom: 16.0),
                    child: HotProduct(
                      product: list[index],
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

  final HotProductModel product;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0), child: const Placeholder());
  }
}

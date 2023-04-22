import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stylish_wen/bloc/product_detail_bloc.dart';
import 'package:stylish_wen/bloc/singleton_cubit.dart';
import 'package:stylish_wen/data/product.dart' as p;
import 'package:stylish_wen/bloc/product_detail_selection_cubic.dart';
import 'package:stylish_wen/extensions/color_extension.dart';

import '../model/api_service.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Image.asset(
          'images/logo.png',
          height: 36,
          fit: BoxFit.contain,
        )),
        body: BlocProvider(
            create: (context) => ProductDetailBloc(
                repo: context.read<SingletonCubit>().state.apiService),
            // context.read<SingletonCubit>().state.apiService
            child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
                builder: (context, state) {
              switch (state.runtimeType) {
                case Success:
                  return ProductDetailContainer(
                      product: (state as Success).model);
                case Failure:
                  context.go("/");
                  return Center(
                      child: Text((state as Failure).message,
                          style: Theme.of(context).textTheme.bodyMedium));
                default:
                  context.read<ProductDetailBloc>().add(productId);
                  return const Center(child: CircularProgressIndicator());
              }
            })));
  }
}

class ProductDetailContainer extends StatelessWidget {
  const ProductDetailContainer({
    super.key,
    required this.product,
  });

  final p.Product product;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: product.mainImage,
              progressIndicatorBuilder: (context, url, progress) =>
                  CircularProgressIndicator(value: progress.progress),
            ),
            Column(
              children: [
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  product.id.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 32,
                ),
                Text('NT\$ ${product.price}',
                    style: Theme.of(context).textTheme.titleLarge)
              ],
            ),
            const Divider(
              height: 32,
            ),
            BlocProvider(
                create: (context) => ProductDetailSelectionCubit(),
                child: ProductSelection(
                  colors: product.colors,
                  sizeStocks: product.variants,
                  sizes: product.sizes,
                )),
            const Divider(
              height: 32,
            ),
            Text(product.description),
            const SizedBox(
              height: 16,
            ),
            const Row(
              children: [
                Text('細部說明'),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Divider(
                    color: Colors.black,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Text(product.story),
            const SizedBox(
              height: 16,
            ),
            ...product.images.map((url) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: CachedNetworkImage(imageUrl: url),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ProductSelection extends StatelessWidget {
  const ProductSelection(
      {super.key,
      required this.sizeStocks,
      required this.sizes,
      required this.colors});
  final List<String> sizes;
  final List<p.Variant> sizeStocks;
  final List<p.Color> colors;

  @override
  Widget build(context) {
    return BlocBuilder<ProductDetailSelectionCubit, ProductSelectionModel>(
      builder: (context, viewModel) {
        final selectedSize = sizes[viewModel.selectedSizeIndex];
        final maxStock = (viewModel.selectedColorIndex != null)
            ? sizeStocks.firstWhere((variant) {
                final colorMatched = variant.colorCode ==
                    colors[viewModel.selectedColorIndex!].code;
                final sizeMatched = variant.size == selectedSize;
                return colorMatched && sizeMatched;
              }).stock
            : null;
        return Column(
          children: [
            ColorSelection(colors: colors),
            const SizedBox(
              height: 16,
            ),
            SizeSelection(
              sizes: sizes,
            ),
            const SizedBox(
              height: 32,
            ),
            AmountSelection(maxStock: maxStock),
            const SizedBox(
              height: 16,
            ),
            ConfirmButton(
              isSelected: viewModel.selectedColorIndex != null,
            )
          ],
        );
      },
    );
  }
}

class ConfirmButton extends StatelessWidget {
  bool isSelected;

  ConfirmButton({
    super.key,
    required this.isSelected,
  });

  @override
  Widget build(context) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {},
            child: Text(isSelected ? '立即購買' : '請輸入品項')));
  }
}

class AmountSelection extends StatefulWidget {
  const AmountSelection({super.key, required this.maxStock});

  final int? maxStock;

  @override
  State<AmountSelection> createState() => _AmountSelectionState();
}

class _AmountSelectionState extends State<AmountSelection> {
  final TextEditingController _controller = TextEditingController();

  final minAmount = 1;
  int currentAmount = 1;

  @override
  Widget build(BuildContext context) {
    if ((widget.maxStock ?? 0) > 0) {
      _controller.value = TextEditingValue(text: '$currentAmount');
    } else {
      currentAmount = 1;
      _controller.clear();
    }
    return Row(
      children: [
        Text(
          '數量',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const VerticalDivider(),
        ElevatedButton(
            onPressed: () {
              if (widget.maxStock == null) return;
              currentAmount = max(currentAmount - 1, minAmount);
              _controller.value = TextEditingValue(text: '$currentAmount');
            },
            child: const Text('-')),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: TextField(
            readOnly: widget.maxStock == null,
            controller: _controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '數量',
            ),
            onChanged: (amount) {
              currentAmount = int.tryParse(amount) ?? minAmount;
            },
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        ElevatedButton(
            onPressed: () {
              if (widget.maxStock == null) return;
              currentAmount = min(currentAmount + 1, widget.maxStock!);
              _controller.value = TextEditingValue(text: '$currentAmount');
            },
            child: const Text('+')),
      ],
    );
  }
}

class SizeSelection extends StatelessWidget {
  const SizeSelection({
    super.key,
    required this.sizes,
  });

  final List<String> sizes;

  @override
  Widget build(context) {
    return BlocBuilder<ProductDetailSelectionCubit, ProductSelectionModel>(
      builder: (context, state) {
        return Row(
          children: [
            Text(
              '尺寸',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const VerticalDivider(),
            ...sizes.map((size) => TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                        sizes.indexOf(size) == state.selectedSizeIndex
                            ? Theme.of(context).primaryColorLight
                            : null,
                  ),
                  onPressed: () {
                    context
                        .read<ProductDetailSelectionCubit>()
                        .selectSize(sizes.indexOf(size));
                  },
                  child: Text(size),
                ))
          ],
        );
      },
    );
  }
}

class ColorSelection extends StatelessWidget {
  const ColorSelection({super.key, required this.colors});

  final List<p.Color> colors;

  @override
  Widget build(context) {
    return BlocBuilder<ProductDetailSelectionCubit, ProductSelectionModel>(
      builder: (context, state) {
        return Row(
          children: [
            Text(
              '顏色',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const VerticalDivider(),
            Wrap(
              spacing: 8,
              children: colors.map((color) {
                final isSelected =
                    colors.indexOf(color) == state.selectedColorIndex;
                return GestureDetector(
                  onTap: () {
                    context
                        .read<ProductDetailSelectionCubit>()
                        .selectColor(colors.indexOf(color));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: color.code.toColor(),
                        border: Border.all(
                            color: isSelected ? Colors.black : Colors.grey,
                            width: 2),
                        shape: BoxShape.rectangle),
                    width: 24,
                    height: 24,
                  ),
                );
              }).toList(),
            )
          ],
        );
      },
    );
  }
}

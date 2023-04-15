import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_wen/data/product_detail_model.dart';
import 'package:stylish_wen/bloc/product_detail_selection_cubic.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key, required this.model});

  final ProductDetailModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Image.asset(
        'images/logo.png',
        height: 36,
        fit: BoxFit.contain,
      )),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Placeholder(
                  fallbackHeight: 240,
                  fallbackWidth: 100,
                ),
                Column(
                  children: [
                    Text(
                      model.description.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      model.description.uuid,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Text('NT\$ ${model.description.price}',
                        style: Theme.of(context).textTheme.titleLarge)
                  ],
                ),
                const Divider(
                  height: 32,
                ),
                BlocProvider(
                    create: (context) => ProductDetailSelectionCubit(),
                    child: ProductSelection(sizeStocks: model.stocks)),
                const Divider(
                  height: 32,
                ),
                Text(model.description.description),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: const [
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
                Text(model.description.detailDescription),
                const SizedBox(
                  height: 16,
                ),
                ...model.description.detailImages.map((_) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Placeholder(
                      fallbackHeight: 300,
                      fallbackWidth: 450,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductSelection extends StatelessWidget {
  const ProductSelection({super.key, required this.sizeStocks});
  final List<ProductStockModel> sizeStocks;

  @override
  Widget build(context) {
    return BlocBuilder<ProductDetailSelectionCubit, ProductSelectionModel>(
      builder: (context, viewModel) {
        final colors = sizeStocks[viewModel.selectedSizeIndex]
            .stocks
            .map((e) => e.color)
            .toList();
        final maxStock = (viewModel.selectedColorIndex != null)
            ? sizeStocks[viewModel.selectedSizeIndex]
                .stocks[viewModel.selectedColorIndex!]
                .stock
            : null;
        return Column(
          children: [
            ColorSelection(colors: colors),
            const SizedBox(
              height: 16,
            ),
            SizeSelection(
              sizes: sizeStocks.map((stock) {
                return stock.size;
              }).toList(),
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

  final List<Color> colors;

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
                        color: color,
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

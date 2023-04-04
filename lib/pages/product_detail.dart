import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stylish_wen/main.dart';
import 'package:stylish_wen/data/product_detail_model.dart';

class ProductDetail extends ConsumerWidget {
  const ProductDetail({super.key, required this.model});

  final ProductDetailModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: ref.watch(appBarProvider),
      body: Center(
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
            ProductSelect(sizeStocks: model.stocks)
          ],
        ),
      ),
    );
  }
}

// TODO: Move this to a separate file
class ProductSelectModel {
  int selectedSizeIndex = 0;
  int? selectedColorIndex;
}

final productSelectionProvider =
    StateNotifierProvider<ProductSelectionNotifier, ProductSelectModel>(
        (ref) => ProductSelectionNotifier());

class ProductSelectionNotifier extends StateNotifier<ProductSelectModel> {
  ProductSelectionNotifier() : super(ProductSelectModel());

  void selectSize(int index) {
    state = ProductSelectModel()
      ..selectedSizeIndex = index
      ..selectedColorIndex = null;
  }

  void selectColor(int index) {
    state = ProductSelectModel()
      ..selectedSizeIndex = state.selectedSizeIndex
      ..selectedColorIndex = index;
  }
}

class ProductSelect extends ConsumerStatefulWidget {
  const ProductSelect({super.key, required this.sizeStocks});

  final List<ProductStockModel> sizeStocks;

  @override
  ProductSelectState createState() => ProductSelectState();
}

class ProductSelectState extends ConsumerState<ProductSelect> {
  @override
  Widget build(context) {
    final viewModel = ref.watch(productSelectionProvider);

    final colors = widget.sizeStocks[viewModel.selectedSizeIndex].stocks
        .map((e) => e.color)
        .toList();
    final maxStock = (viewModel.selectedColorIndex != null)
        ? widget.sizeStocks[viewModel.selectedSizeIndex]
            .stocks[viewModel.selectedColorIndex!].stock
        : null;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ColorSelection(colors: colors),
          const SizedBox(
            height: 16,
          ),
          SizeSelection(
            sizes: widget.sizeStocks.map((stock) {
              return stock.size;
            }).toList(),
          ),
          const SizedBox(
            height: 32,
          ),
          AmountSelection(maxStock: maxStock),
        ],
      ),
    );
  }
}

class AmountSelection extends StatelessWidget {
  AmountSelection({super.key, required this.maxStock});

  final TextEditingController _controller = TextEditingController();

  final minAmount = 1;
  int currentAmount = 1;
  int? maxStock;

  @override
  Widget build(BuildContext context) {
    _controller.value = TextEditingValue(text: '$currentAmount');
    return Row(
      children: [
        Text(
          '數量',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const VerticalDivider(),
        ElevatedButton(
            onPressed: () {
              if (maxStock == null) return;
              currentAmount = max(currentAmount - 1, minAmount);
              _controller.value = TextEditingValue(text: '$currentAmount');
            },
            child: const Text('-')),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: TextField(
            readOnly: maxStock == null,
            controller: _controller,
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
              if (maxStock == null) return;
              currentAmount = min(currentAmount + 1, maxStock!);
              _controller.value = TextEditingValue(text: '$currentAmount');
            },
            child: const Text('+')),
      ],
    );
  }
}

class SizeSelection extends ConsumerWidget {
  const SizeSelection({
    super.key,
    required this.sizes,
  });

  final List<String> sizes;

  @override
  Widget build(context, ref) {
    final viewModel = ref.watch(productSelectionProvider);
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
                    sizes.indexOf(size) == viewModel.selectedSizeIndex
                        ? Theme.of(context).primaryColorLight
                        : null,
              ),
              onPressed: () {
                ref
                    .watch(productSelectionProvider.notifier)
                    .selectSize(sizes.indexOf(size));
              },
              child: Text(size),
            ))
      ],
    );
  }
}

class ColorSelection extends ConsumerWidget {
  const ColorSelection({super.key, required this.colors});

  final List<Color> colors;

  @override
  Widget build(context, ref) {
    final viewModel = ref.watch(productSelectionProvider);
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
                colors.indexOf(color) == viewModel.selectedColorIndex;
            return GestureDetector(
              onTap: () {
                ref
                    .watch(productSelectionProvider.notifier)
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
  }
}

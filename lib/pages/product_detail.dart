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
                ProductSelection(sizeStocks: model.stocks),
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

class ProductSelection extends ConsumerStatefulWidget {
  const ProductSelection({super.key, required this.sizeStocks});

  final List<ProductStockModel> sizeStocks;

  @override
  ProductSelectionView createState() => ProductSelectionView();
}

class ProductSelectionView extends ConsumerState<ProductSelection> {
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
    return Column(
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
        const SizedBox(
          height: 16,
        ),
        const ConfirmButton()
      ],
    );
  }
}

class ConfirmButton extends ConsumerWidget {
  const ConfirmButton({
    super.key,
  });

  @override
  Widget build(context, ref) {
    final isSelected =
        ref.watch(productSelectionProvider).selectedColorIndex != null;
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

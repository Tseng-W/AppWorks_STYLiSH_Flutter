import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hotProductViewModelProvider =
    StateNotifierProvider<HotProductViewModel, List<HotProductModel>>(
  (ref) => HotProductViewModel(),
);

class HotProductModel {
  final int uuid;
  final Image image;

  HotProductModel(this.uuid, this.image);
}

class HotProductViewModel extends StateNotifier<List<HotProductModel>> {
  HotProductViewModel() : super([]);
  void fetchProductList() async {
    await Future.delayed(const Duration(seconds: 2));
    state = List.generate(
        10,
        (index) => HotProductModel(index,
            const Image(image: AssetImage('assets/images/placeholder.png'))));
  }
}

class HotProductsList extends ConsumerWidget {
  const HotProductsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(hotProductViewModelProvider);

    ref.watch(hotProductViewModelProvider.notifier).fetchProductList();

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

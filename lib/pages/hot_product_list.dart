import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final hotProductViewModelProvider = ChangeNotifierProvider<HotProductViewModel>(
  (ref) => HotProductViewModel(),
);

class HotProductModel {
  final int uuid;
  final Image image;

  HotProductModel(this.uuid, this.image);
}

class HotProductViewModel extends ChangeNotifier {
  List<HotProductModel> _productList = [];

  List<HotProductModel> get productList => _productList;

  set lists(List<HotProductModel> value) {
    _productList = value;
    notifyListeners();
  }

  void fetchProductList() async {
    await Future.delayed(const Duration(seconds: 2));
    lists = List.generate(
        10,
        (index) => HotProductModel(index,
            const Image(image: AssetImage('assets/images/placeholder.png'))));
  }
}

class HotProductsList extends StatelessWidget {
  const HotProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final viewModel = ref.watch(hotProductViewModelProvider);

        viewModel.fetchProductList();

        return SizedBox(
          height: 200,
          child: viewModel.productList.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.productList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 16.0, bottom: 16.0),
                      child: HotProduct(
                        product: viewModel.productList[index],
                      ),
                    );
                  },
                ),
        );
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

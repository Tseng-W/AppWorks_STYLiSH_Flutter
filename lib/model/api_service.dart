import 'package:flutter/material.dart';
import 'package:stylish_wen/data/category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stylish_wen/data/product_detail_model.dart';

abstract class APIServiceProtocol {
  Future<List<CategoryData>> fetchCategoryList();
  Future<ProductDetailModel> fetchProductDetail(String uuid);
}

final apiServiceProvider =
    Provider<APIServiceProtocol>((ref) => MockAPIService());

class MockAPIService extends APIServiceProtocol {
  final mockListCount = 10;

  CategoryData generateMockList(String categoryTitle) {
    return CategoryData(
        categoryTitle,
        List.generate(
            mockListCount,
            (index) => CategoryItem(
                'UNIQLO 特級級輕羽絨外套',
                index + 1,
                Image.asset('images/nope.jpg'),
                categoryTitle + index.toString())));
  }

  @override
  Future<List<CategoryData>> fetchCategoryList() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      generateMockList('女裝'),
      generateMockList('男裝'),
      generateMockList('飾品'),
    ];
  }

  @override
  Future<ProductDetailModel> fetchProductDetail(String uuid) async {
    await Future.delayed(const Duration(seconds: 1));

    return ProductDetailModel(
        ProductDescriptionModel('title', Image.asset('name'), 'uuid',
            'description', 'detailDescription', [Image.asset('name')], 100),
        [
          ProductStockModel('S', [
            Stock(Colors.blue, 3),
            Stock(Colors.green, 2),
            Stock(Colors.white, 4)
          ]),
          ProductStockModel('M', [
            Stock(Colors.blue, 3),
            Stock(Colors.green, 2),
            Stock(Colors.white, 4)
          ]),
          ProductStockModel('L', [
            Stock(Colors.blue, 3),
            Stock(Colors.green, 2),
            Stock(Colors.white, 4)
          ]),
        ]);
  }
}

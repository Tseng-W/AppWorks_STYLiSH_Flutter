import 'package:flutter/material.dart';
import 'package:stylish_wen/data/category_model.dart';
import 'package:stylish_wen/data/hot_product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stylish_wen/data/product_detail_model.dart';

abstract class APIServiceProtocol {
  Future<List<CategoryData>> fetchCategoryList();
  Future<ProductDetailModel> fetchProductDetail(String uuid);
}

abstract class HotProductAPIServiceProtocol {
  Future<List<HotProductModel>> fetchHotProductList();
}

final apiServiceProvider =
    Provider<APIServiceProtocol>((ref) => MockAPIService());

class MockAPIService
    implements APIServiceProtocol, HotProductAPIServiceProtocol {
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
        ProductDescriptionModel(
            'title',
            Image.asset('name'),
            'uuid',
            '實品顏色依單品照片為主\n棉 100%\n厚薄：薄\n彈性：無\n素材產地／日本\n加工產品／中國',
            '商品描述: 這款棉質單品，質感柔軟舒適，絕對是秋冬時髦搭配的好夥伴。實品顏色以單品照片為主，採用100%純棉材質，穿著舒適且透氣性佳，不會讓您感到悶熱或不舒適。樸實的設計風格，讓您可以根據自己的喜好自由搭配不同風格的服裝，展現個人獨特的風采。適合多種不同場合，是您不可或缺的基本單品。趕快添加到您的購物清單中吧！\n注意事項: 洗滌時請勿使用漂白劑，避免破壞衣服的質地；建議將衣物放進洗衣袋中，以免衣物變形或損壞。',
            List.generate(6, (index) => Image.asset('name')),
            100),
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

  @override
  Future<List<HotProductModel>> fetchHotProductList() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(mockListCount,
        (index) => HotProductModel(index + 1, Image.asset('images/nope.jpg')));
  }
}

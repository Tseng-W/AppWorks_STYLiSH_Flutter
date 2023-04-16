import 'package:flutter/material.dart';
import 'package:stylish_wen/data/hots.dart';
import 'package:stylish_wen/data/product.dart';
import 'package:stylish_wen/data/product_detail_model.dart';
import 'package:stylish_wen/model/request.dart';
import 'package:dio/dio.dart';

abstract class HotProductAPIServiceProtocol {
  Future<List<Hots>> fetchHotProductList();
}

class HotProductAPIService implements HotProductAPIServiceProtocol {
  APIServiceProtocol repo = APIService();
  @override
  Future<List<Hots>> fetchHotProductList() async {
    final response = await repo.fetchRequest(HostRequest());
    return response;
  }
}

abstract class CategoryListAPIServiceProtocol {
  Future<PagedProduct> fetchCategoryList(ProductListType type);
}

class CategoryListAPIService implements CategoryListAPIServiceProtocol {
  APIServiceProtocol repo = APIService();
  @override
  Future<PagedProduct> fetchCategoryList(ProductListType type) async {
    final response = await repo.fetchRequest(ProductListRequest(type));
    return response;
  }
}

abstract class ProductDetailAPIServiceProtocol {
  Future<ProductDetailModel> fetchProductDetail(int uuid);
}

abstract class APIServiceProtocol {
  Future<T> fetchRequest<T>(Request<T> request);
}

class APIService implements APIServiceProtocol {
  static final shared = APIService();

  final Dio dio = Dio();

  APIService() {
    dio.options.baseUrl = 'https://api.appworks-school.tw/api/1.0';
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 3);
  }

  @override
  Future<T> fetchRequest<T>(Request<T> request) {
    Future<Response<Map>> response;
    switch (request.method) {
      case RequestMethod.GET:
        response = dio.get(request.endpoint, queryParameters: request.queries);
        break;
      case RequestMethod.POST:
        response = dio.post(request.endpoint,
            queryParameters: request.queries,
            options: Options(responseType: request.type));
        break;
      default:
        throw Exception('Not implemented');
    }
    return response.then((response) {
      if (response.statusCode == 200) {
        try {
          if (response.data == null) {
            throw Exception('Data unexpected found nil');
          }
          return request.decode(response.data!);
        } catch (e) {
          if (e is FormatException) {
            throw Exception('Format error');
          } else {
            throw Exception('Unexpected error');
          }
        }
      } else {
        throw Exception('Failed to load hots');
      }
    });
  }
}

class MockAPIService implements ProductDetailAPIServiceProtocol {
  final mockListCount = 10;

  @override
  Future<ProductDetailModel> fetchProductDetail(int uuid) async {
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
}

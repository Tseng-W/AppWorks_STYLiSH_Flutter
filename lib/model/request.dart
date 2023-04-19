import 'package:stylish_wen/data/hots.dart';
import 'package:stylish_wen/data/product.dart';
import 'package:dio/dio.dart';

// ignore: constant_identifier_names
enum RequestMethod { GET, POST }

abstract class Request<T> {
  late RequestMethod method;
  late String endpoint;
  late Map<String, dynamic> queries;
  late ResponseType type;

  T decode(Map<dynamic, dynamic> json);
}

class HostRequest extends Request {
  @override
  RequestMethod get method {
    return RequestMethod.GET;
  }

  @override
  String get endpoint {
    return '/marketing/hots';
  }

  @override
  Map<String, dynamic> get queries {
    return {};
  }

  @override
  ResponseType get type {
    return ResponseType.json;
  }

  @override
  List<Hots> decode(Map<dynamic, dynamic> json) {
    Iterable l = json['data'];
    return List<Hots>.from(l.map((model) => Hots.fromJson(model)));
  }
}

enum ProductListType { all, women, men, accessories }

class ProductListRequest implements Request {
  ProductListRequest(this.listType) {
    endpoint = '/products/${listType.toString().split('.').last}';
  }

  ProductListType listType;

  @override
  late String endpoint;

  @override
  RequestMethod method = RequestMethod.GET;

  @override
  Map<String, dynamic> queries = {};

  @override
  ResponseType type = ResponseType.json;

  @override
  PagedProduct decode(Map json) {
    final paging = json['paging'];
    Iterable l = json['data'];
    final list = List<Product>.from(l.map((model) => Product.fromJson(model)));
    return PagedProduct(list, paging);
  }
}

class ProductDetailRequest implements Request {
  ProductDetailRequest(this.id) {
    endpoint = '/products/details';
    queries = {'id': id};
  }

  int id;

  @override
  late String endpoint;

  @override
  RequestMethod method = RequestMethod.GET;

  @override
  late Map<String, dynamic> queries;

  @override
  ResponseType type = ResponseType.json;

  @override
  Product decode(Map json) {
    return Product.fromJson(json['data']);
  }
}

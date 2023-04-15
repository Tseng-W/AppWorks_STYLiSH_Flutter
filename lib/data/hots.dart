import 'package:stylish_wen/data/product.dart';

class Hots {
  String title;
  List<Product> products;

  Hots({required this.title, required this.products});

  factory Hots.fromJson(Map<String, dynamic> json) {
    List<Product> products = [];
    if (json['products'] != null) {
      for (var productJson in json['products']) {
        products.add(Product.fromJson(productJson));
      }
    }

    return Hots(title: json['title'], products: products);
  }
}

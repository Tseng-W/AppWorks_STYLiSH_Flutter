import 'package:flutter/material.dart';

class ProductDetailModel {
  final ProductDescriptionModel description;
  final List<ProductStockModel> stocks;

  ProductDetailModel(this.description, this.stocks);
}

class ProductDescriptionModel {
  final String title;
  final int price;
  final Image image;
  final String uuid;
  final String description;
  final String detailDescription;
  final List<Image> detailImages;

  ProductDescriptionModel(this.title, this.image, this.uuid, this.description,
      this.detailDescription, this.detailImages, this.price);
}

class ProductStockModel {
  final String size;
  final List<Stock> stocks;

  ProductStockModel(this.size, this.stocks);
}

class Stock {
  final Color color;
  final int stock;

  Stock(this.color, this.stock);
}

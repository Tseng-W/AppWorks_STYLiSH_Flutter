import 'package:flutter/material.dart';

class CategoryData {
  final String categoryType;
  final List<CategoryItem> items;

  CategoryData(this.categoryType, this.items);
}

class CategoryItem {
  final String uuid;
  final String title;
  final int price;
  final Image image;

  CategoryItem(this.title, this.price, this.image, this.uuid);
}

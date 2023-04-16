import 'package:flutter/material.dart';

class CategoryItem {
  final String uuid;
  final String title;
  final int price;
  final Image image;

  CategoryItem(this.title, this.price, this.image, this.uuid);
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

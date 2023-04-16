class Product {
  final int id;
  final String category;
  final String title;
  final String description;
  final double price;
  final String texture;
  final String wash;
  final String place;
  final String note;
  final String story;
  final List<Color> colors;
  final List<String> sizes;
  final List<Variant> variants;
  final String mainImage;
  final List<String> images;

  Product({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.price,
    required this.texture,
    required this.wash,
    required this.place,
    required this.note,
    required this.story,
    required this.colors,
    required this.sizes,
    required this.variants,
    required this.mainImage,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<Color> colors = [];
    if (json['colors'] != null) {
      for (var colorJson in json['colors']) {
        colors.add(Color.fromJson(colorJson));
      }
    }

    List<String> sizes = [];
    if (json['sizes'] != null) {
      for (var size in json['sizes']) {
        sizes.add(size.toString());
      }
    }

    List<Variant> variants = [];
    if (json['variants'] != null) {
      for (var variantJson in json['variants']) {
        variants.add(Variant.fromJson(variantJson));
      }
    }

    List<String> images = [];
    if (json['images'] != null) {
      for (var image in json['images']) {
        images.add(image.toString());
      }
    }

    return Product(
      id: json['id'],
      category: json['category'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      texture: json['texture'],
      wash: json['wash'],
      place: json['place'],
      note: json['note'],
      story: json['story'],
      colors: colors,
      sizes: sizes,
      variants: variants,
      mainImage: json['main_image'],
      images: images,
    );
  }
}

class PagedProduct {
  final List<Product> products;
  final int? paging;

  PagedProduct(this.products, this.paging);
}

class Color {
  final String name;
  final String code;

  Color({
    required this.name,
    required this.code,
  });

  factory Color.fromJson(Map<String, dynamic> json) {
    return Color(
      name: json['name'],
      code: json['code'],
    );
  }
}

class Variant {
  final String colorCode;
  final String size;
  final int stock;

  Variant({
    required this.colorCode,
    required this.size,
    required this.stock,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      colorCode: json['color_code'],
      size: json['size'],
      stock: json['stock'],
    );
  }
}

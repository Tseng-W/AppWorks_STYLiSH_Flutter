class CategoryData {
  final String categoryType;
  final List<CategoryItem> items;

  CategoryData(this.categoryType, this.items);
}

class CategoryItem {
  final String title;
  final int price;
  final String image;

  CategoryItem(this.title, this.price, this.image);
}

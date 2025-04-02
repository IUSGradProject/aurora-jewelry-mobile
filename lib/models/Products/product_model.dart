class ProductModel {
  const ProductModel({
    required this.name,
    required this.category,
    required this.description,
    required this.image,
    required this.price,
  });

  final String name;
  final String category;
  final String description;
  final String image;
  final double price;
}

class Product {
  final String productId;
  final String name;
  final String image;
  final String description;
  final double price;
  final int soldItems;
  final int available;
  final bool isDeleted;

  Product({
    required this.productId,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.soldItems,
    required this.available,
    required this.isDeleted
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'] ?? '', // Handle null values
      name: json['name'] ?? '', // Handle null values
      image: json['image'] ?? '', // Handle null values
      description: json['description'] ?? '', // Handle null values
      price:
          (json['price'] ?? 0.0)
              .toDouble(), // Handle null values and default to 0.0
      soldItems: json['soldItems'] ?? 0, // Handle null values
      available: json['available'] ?? 0, // Handle null values
      isDeleted: json['isDeleted'] ?? false, // Handle null values
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'image': image,
      'description': description,
      'price': price,
      'soldItems': soldItems,
      'available': available,
      'isDeleted': isDeleted,
    };
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class Brand {
  final int id;
  final String name;

  Brand({required this.id, required this.name});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class Power {
  final int id;
  final String name;

  Power({required this.id, required this.name});

  factory Power.fromJson(Map<String, dynamic> json) {
    return Power(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
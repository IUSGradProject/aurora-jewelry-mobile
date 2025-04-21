class Product {
  final String productId;
  final String name;
  final String image;
  final String description;
  final double price;
  final int soldItems;
  final int available;
  final bool isEditing;
  final Category category;
  final Brand brand;
  final Power power;
  final Style style;
  final List<String> materials;

  Product({
    required this.productId,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.soldItems,
    required this.available,
    required this.isEditing,
    required this.category,
    required this.brand,
    required this.power,
    required this.style,
    required this.materials,
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
      isEditing:
          json['isEditing'] ?? false, // Handle null values and default to false
      category: Category.fromJson(
        json['category'] ?? {},
      ), // Handle null values for nested objects
      brand: Brand.fromJson(
        json['brand'] ?? {},
      ), // Handle null values for nested objects
      power: Power.fromJson(
        json['power'] ?? {},
      ), // Handle null values for nested objects
      style: Style.fromJson(
        json['style'] ?? {},
      ), // Handle null values for nested objects
      materials:
          json['materials'] != null
              ? List<String>.from(
                json['materials'].map((x) => x ?? ''),
              ) // Handle null values in lists
              : [], // Default to empty list if null)
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
      'isEditing': isEditing,
      'category': category.toJson(),
      'brand': brand.toJson(),
      'power': power.toJson(),
      'style': style.toJson(),
      'materials': List<dynamic>.from(materials.map((x) => x)),
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

class Style {
  final int id;
  final String name;

  Style({required this.id, required this.name});

  factory Style.fromJson(Map<String, dynamic> json) {
    return Style(id: json['id'], name: json['name']);
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class Material {
  final int id;
  final String name;

  Material({required this.id, required this.name});

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(id: json['id'], name: json['name']);
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

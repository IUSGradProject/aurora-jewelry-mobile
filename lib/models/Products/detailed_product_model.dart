import 'package:aurora_jewelry/models/Cart/cart_item_contract_model.dart';
import 'package:aurora_jewelry/models/Products/product_model.dart';

class DetailedProduct {
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
  final List<Material> materials;

  DetailedProduct({
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

  factory DetailedProduct.fromJson(Map<String, dynamic> json) {
    return DetailedProduct(
      productId: json['productId'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      soldItems: json['soldItems'],
      available: json['available'],
      isEditing: json['isEditing'],
      category: Category.fromJson(json['category']),
      brand: Brand.fromJson(json['brand']),
      power: Power.fromJson(json['power']),
      style: Style.fromJson(json['style']),
      materials:
          (json['materials'] as List).map((e) => Material.fromJson(e)).toList(),
    );
  }
  
  
  // CartItemContractModel({
  //   required this.productId,
  //   required this.name,
  //   required this.imageUrl,
  //   required this.price,
  //   required this.available,
  //   required this.quantity,
  // });
  
  CartItemContractModel convertToCartItem(int quantity) {
    return CartItemContractModel(
      productId: productId,
      name: name,
      imageUrl: image,
      price: price.toInt(),
      available: available,
      quantity: quantity,
    );
  }

  Product convertToProduct() {
    return Product(
      productId: productId,
      name: name,
      image: image,
      description: description,
      price: price,
      soldItems: soldItems,
      available: available,
      isDeleted: false,
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name']);
  }
}

class Brand {
  final int id;
  final String name;

  Brand({required this.id, required this.name});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(id: json['id'], name: json['name']);
  }
}

class Power {
  final int id;
  final String name;

  Power({required this.id, required this.name});

  factory Power.fromJson(Map<String, dynamic> json) {
    return Power(id: json['id'], name: json['name']);
  }
}

class Style {
  final int id;
  final String name;

  Style({required this.id, required this.name});

  factory Style.fromJson(Map<String, dynamic> json) {
    return Style(id: json['id'], name: json['name']);
  }
}

class Material {
  final int? id;
  final String? name;

  Material({this.id, this.name});

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(id: json['id'], name: json['name']);
  }
}

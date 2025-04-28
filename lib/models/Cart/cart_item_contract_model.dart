class CartItemContractModel {

  final String productId;
  final String name;
  final String imageUrl;
  final int price;
  final int available;
  final int quantity;

  CartItemContractModel({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.available,
    required this.quantity,
  });

  factory CartItemContractModel.fromJson(Map<String, dynamic> json) {
    return CartItemContractModel(
      productId: json['productId'] as String,
      name: json['name'] as String,
      imageUrl: json['image'] as String,
      price: json['price'] as int,
      available: json['available'] as int,
      quantity: json['quantity'] as int,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'image': imageUrl,
      'price': price,
      'available': available,
      'quantity': quantity,
    };
  }

}
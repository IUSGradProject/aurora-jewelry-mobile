import 'package:aurora_jewelry/models/Cart/cart_item_contract_model.dart';

class CartRequestModel {
  final List<CartItemContractModel> items;

  CartRequestModel({required this.items});



  factory CartRequestModel.fromJson(Map<String, dynamic> json) {
    return CartRequestModel(
      items: (json['items'] as List)
          .map((item) => CartItemContractModel.fromJson(item))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
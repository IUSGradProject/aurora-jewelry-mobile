import 'package:flutter/cupertino.dart';

class CartProvider extends ChangeNotifier {
  final List<String> _cartItems = [];
  final GlobalKey cartIconButtonKey = GlobalKey();

  // Getters
  List<String> get cartItems => _cartItems;

  // Method to add to cart
  void addToCart() {
    _cartItems.add("");
    notifyListeners();
  }
}

import 'package:aurora_jewelry/models/Cart/cart_item_contract_model.dart';
import 'package:aurora_jewelry/providers/Auth/user_provider.dart';
import 'package:flutter/cupertino.dart';

import 'package:aurora_jewelry/services/api_service.dart';
import 'package:provider/provider.dart'; // Adjust the path if different

class CartProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final List<CartItemContractModel> _cartItems = [];
  final List<String> _checkoutItems = [];

  final GlobalKey cartIconButtonKey = GlobalKey();

  bool _isLoading = false;

  // Getters
  List<CartItemContractModel> get cartItems => _cartItems;
  List<String> get checkoutItems => _checkoutItems;
  bool get isLoading => _isLoading;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  void addCheckoutItem(CartItemContractModel item) {
    _checkoutItems.add(item.productId);
    notifyListeners();
  }

  void removeCheckoutItem(CartItemContractModel item) {
    _checkoutItems.remove(item.productId);
    notifyListeners();
  }

  bool isItemInCheckout(CartItemContractModel item) {
    return _checkoutItems.contains(item.productId);
  }

  int calculateCheckoutItemsTotalPrice() {
    int total = 0;
    for (var item in _checkoutItems) {
      final cartItem = _cartItems.firstWhere(
        (cartItem) => cartItem.productId == item,
      );
      total +=
          cartItem.quantity * cartItem.price; // Assuming each item costs 100
    }
    return total;
  }

  // Load cart from backend
  Future<void> fetchCart(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();
      String? userToken =
          Provider.of<UserProvider>(
            context,
            listen: false,
          ).currentUser!.authToken;

      final cartResponse = await _apiService.getCart(userToken!);
      _cartItems.clear();
      _cartItems.addAll(cartResponse);

      //Edge case: If some items are set to 0 quantity in the backend
      // but still exist in the checkout items, remove them from checkout items
      if (_checkoutItems.isNotEmpty) {
        if (cartItems.length != _checkoutItems.length) {
          final List<String> itemsToRemove = [];

          for (var item in _checkoutItems) {
            final cartItem = _cartItems.firstWhere(
              (cartItem) => cartItem.productId == item,
            );
            if (cartItem.quantity == 0) {
              itemsToRemove.add(item);
            }
          }

          _checkoutItems.removeWhere((item) => itemsToRemove.contains(item));
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Failed to fetch cart: $e');
      rethrow;
    }
  }

  // Add item to cart
  // Future<void> addToCart(String productId, {int quantity = 1}) async {
  //   try {
  //     final existingItem = _cartItems.firstWhere(
  //       (item) => item.productId == productId,
  //       orElse: () => CartItemContractModel(productId: '', quantity: 0),
  //     );

  //     if (existingItem.productId.isNotEmpty) {
  //       // If item exists, increase quantity
  //       existingItem.quantity += quantity;
  //     } else {
  //       _cartItems.add(
  //         CartItemContractModel(productId: productId, quantity: quantity),
  //       );
  //     }

  //     await _syncCartWithBackend();
  //     notifyListeners();
  //   } catch (e) {
  //     print('Failed to add to cart: $e');
  //     rethrow;
  //   }
  // }

  // Remove item from cart
  // Future<void> removeFromCart(String productId) async {
  //   try {
  //     _cartItems.removeWhere((item) => item.productId == productId);
  //     await _syncCartWithBackend();
  //     notifyListeners();
  //   } catch (e) {
  //     print('Failed to remove from cart: $e');
  //     rethrow;
  //   }
  // }

  // Clear all items
  // Future<void> clearCart() async {
  //   try {
  //     _cartItems.clear();
  //     await _syncCartWithBackend();
  //     notifyListeners();
  //   } catch (e) {
  //     print('Failed to clear cart: $e');
  //     rethrow;
  //   }
  // }

  // Private: Sync cart with backend
  // Future<void> _syncCartWithBackend() async {
  //   try {
  //     final cartRequest = CartRequestModel(items: _cartItems);
  //     final cartResponse = await _apiService.updateCart(cartRequest);

  //     _totalPrice = cartResponse.totalPrice;
  //   } catch (e) {
  //     print('Failed to sync cart with backend: $e');
  //     rethrow;
  //   }
  // }

  void addToCart() {
    notifyListeners();
  }
}

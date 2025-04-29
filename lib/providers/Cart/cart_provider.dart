import 'package:aurora_jewelry/models/Cart/cart_item_contract_model.dart';
import 'package:aurora_jewelry/models/Products/product_model.dart';
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
  bool _isBottomSheetOpened = false;

  // Getters
  List<CartItemContractModel> get cartItems => _cartItems;
  List<String> get checkoutItems => _checkoutItems;
  bool get isLoading => _isLoading;
  bool get isBottomSheetOpened => _isBottomSheetOpened;

  final double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  void setIsBottomSheetOpened(bool value) {
    _isBottomSheetOpened = value;
    notifyListeners();
  }

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
        orElse:
            () => CartItemContractModel(
              productId: '',
              name: '',
              imageUrl: '',
              price: 0,
              available: 0,
              quantity: 0,
            ),
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

      // Closing and opening bottom sheet
      if (_cartItems.isNotEmpty) {
        setIsBottomSheetOpened(true);
      } else {
        setIsBottomSheetOpened(false);
      }

      //Edge case: If some items are set to 0 quantity in the backend
      // but still exist in the checkout items, remove them from checkout items
      if (_checkoutItems.isNotEmpty) {
        if (cartItems.length != _checkoutItems.length) {
          final List<String> itemsToRemove = [];

          for (var item in _checkoutItems) {
            final cartItem = _cartItems.firstWhere(
              (cartItem) => cartItem.productId == item,
              orElse:
                  () => CartItemContractModel(
                    productId: '',
                    name: '',
                    imageUrl: '',
                    price: 0,
                    available: 0,
                    quantity: 0,
                  ),
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
      rethrow;
    }
  }

  Future<void> removeFromCart(BuildContext context, String productId) async {
    try {
      _isLoading = true;
      notifyListeners();
      String? userToken =
          Provider.of<UserProvider>(
            context,
            listen: false,
          ).currentUser!.authToken;

      await _apiService.deleteCartItem(productId, userToken!);

      // ignore: use_build_context_synchronously
      await fetchCart(context);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// function to add product to cart
  Future<void> addProductToCart(
    Product product,
    BuildContext context, {
    int quantity = 1,
  }) async {
    //Convert Product to CartItemContractModel
    final cartItem = CartItemContractModel(
      productId: product.productId,
      name: product.name,
      imageUrl: product.image,
      price: product.price.toInt(),
      available: product.available,
      quantity: quantity, // Default quantity to 1
    );
    String? userToken =
        Provider.of<UserProvider>(
          context,
          listen: false,
        ).currentUser!.authToken;

    try {
      await _apiService.addToCart(cartItem, userToken!);

      // ignore: use_build_context_synchronously
      await fetchCart(context);
      // When calling fetch cart after adding an item, it will automatically open the bottom sheet
      // But user cannot be inside of cart to perform this action because of that we are closing the bottom sheet
      // this could be more optimized by dividing/changing the logic for opening and closing the bottom sheet.
      // setIsBottomSheetOpened(false);

      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}

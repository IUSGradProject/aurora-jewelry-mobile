import 'package:aurora_jewelry/models/Cart/cart_item_contract_model.dart';
import 'package:aurora_jewelry/models/Cart/delivery_address_model.dart';
import 'package:aurora_jewelry/models/Products/product_model.dart';
import 'package:aurora_jewelry/providers/Auth/user_provider.dart';
import 'package:flutter/cupertino.dart';

import 'package:aurora_jewelry/services/api_service.dart';
import 'package:provider/provider.dart'; // Adjust the path if different

class CartProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final List<CartItemContractModel> _cartItems = [];

  // List of product IDs that have been added to the checkout
  final List<String> _checkoutItemsIds = [];
  // List of items to be sent to the invoice screen, same as checkout items
  // but with Model
  final List<CartItemContractModel> _invoiceItems = [];

  //Delivery addres of order

  bool _isDeliveryAddressSet = false;
  DeliveryAddressModel _deliveryAddress = DeliveryAddressModel(
    fullName: '',
    address: '',
    city: '',
    postalCode: 0,
  );

  GlobalKey cartIconButtonKey = GlobalKey();

  bool _isLoading = false;
  bool _isBottomSheetOpened = false;
  bool _isOrderPlacedSuccesfully = false;

  // Getters
  List<CartItemContractModel> get cartItems => _cartItems;
  List<String> get checkoutItemsIds => _checkoutItemsIds;
  List<CartItemContractModel> get invoiceItems => _invoiceItems;
  bool get isLoading => _isLoading;
  bool get isBottomSheetOpened => _isBottomSheetOpened;
  DeliveryAddressModel get deliveryAddress => _deliveryAddress;
  bool get isDeliveryAddressSet => _isDeliveryAddressSet;
  bool get isOrderPlacedSuccesfully => _isOrderPlacedSuccesfully;

  final double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;



  void reloadCartIconGlobalKey() {
    cartIconButtonKey = GlobalKey();
    notifyListeners();
  }

  void setIsBottomSheetOpened(bool value) {
    _isBottomSheetOpened = value;
    notifyListeners();
  }

  void addCheckoutItem(CartItemContractModel item) {
    _invoiceItems.add(item);
    _checkoutItemsIds.add(item.productId);
    notifyListeners();
  }

  void removeCheckoutItem(CartItemContractModel item) {
    _invoiceItems.remove(item);
    _checkoutItemsIds.remove(item.productId);
    notifyListeners();
  }

  bool isItemInCheckout(CartItemContractModel item) {
    return _checkoutItemsIds.contains(item.productId);
  }

  int calculateCheckoutItemsTotalPrice() {
    int total = 0;
    for (var item in _checkoutItemsIds) {
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

  void addBuyNowItem(CartItemContractModel item) {
    if (_invoiceItems.isNotEmpty) {
      //This indicates that there is already items in every
      //list(lists that are connected with logic of adding/buyin/ordering items).
      _cartItems.clear();
      _invoiceItems.clear();
      _checkoutItemsIds.clear();
    }
    _invoiceItems.add(item);
    _checkoutItemsIds.add(item.productId);
    //Adding item to cart items as well
    //Because of current logic we will need to add it -> calculating total price
    _cartItems.add(item);
    notifyListeners();
  }

  void resetInvoiceScreen() {
    _invoiceItems.clear();
    _checkoutItemsIds.clear();
    _cartItems.clear();
    notifyListeners();
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
      if (_checkoutItemsIds.isNotEmpty) {
        if (cartItems.length != _checkoutItemsIds.length) {
          final List<String> itemsToRemove = [];

          for (var item in _checkoutItemsIds) {
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

          _checkoutItemsIds.removeWhere((item) => itemsToRemove.contains(item));
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

  void decrementCartItemQuantity(CartItemContractModel cartItem) {
    if (cartItem.quantity > 1) {
      for (int i = 0; i < cartItems.length; i++) {
        if (cartItems[i].productId == cartItem.productId) {
          cartItems[i].quantity = cartItems[i].quantity - 1;
          cartItems[i].available = cartItems[i].available + 1;
          break;
        }
      }
      notifyListeners();
    }
  }

  void incrementCartItemQuantity(CartItemContractModel cartItem) {
    if (cartItem.available > 0) {
      for (int i = 0; i < cartItems.length; i++) {
        if (cartItems[i].productId == cartItem.productId) {
          cartItems[i].available = cartItems[i].available - 1;
          cartItems[i].quantity = cartItems[i].quantity + 1;
          break;
        }
      }
      notifyListeners();
    }
  }

  Future<void> updateCartItem(
    CartItemContractModel cartItem,
    BuildContext context,
  ) async {
    String? userToken =
        Provider.of<UserProvider>(
          context,
          listen: false,
        ).currentUser!.authToken;
    try {
      await _apiService.updateCartItem(cartItem, userToken!);
      // ignore: use_build_context_synchronously
      await fetchCart(context);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> placeOrder(BuildContext context) async {
    String? userToken =
        Provider.of<UserProvider>(
          context,
          listen: false,
        ).currentUser!.authToken;
    try {
      _isOrderPlacedSuccesfully = false;
      notifyListeners();
      await _apiService.placeOrder(_invoiceItems, userToken!);
      _isOrderPlacedSuccesfully = true;

      // Order submitted successfully
      //Clearing tmp lists that are used to store checkout items

      //Following things needs to be done:
      // Clear the cart
      // Navigate user to home screen
      _checkoutItemsIds.clear();
      _invoiceItems.clear();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// function to set delivery address
  void setDeliveryAddress(DeliveryAddressModel value) {
    _isDeliveryAddressSet = true;
    _deliveryAddress = value;
    notifyListeners();
  }

  void clearDeliveryAddress() {
    _isDeliveryAddressSet = false;
    _deliveryAddress = DeliveryAddressModel(
      fullName: '',
      address: '',
      city: '',
      postalCode: 0,
    );
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _checkoutItemsIds.clear();
    _invoiceItems.clear();
    notifyListeners();
  }

  void clearAll() {
    _cartItems.clear();
    _checkoutItemsIds.clear();
    _invoiceItems.clear();
    _isDeliveryAddressSet = false;
    _deliveryAddress = DeliveryAddressModel(
      fullName: '',
      address: '',
      city: '',
      postalCode: 0,
    );
    notifyListeners();
  }
}

import 'package:aurora_jewelry/models/Auth/user_model.dart';
import 'package:aurora_jewelry/models/Cart/delivery_address_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isDeliveryAddressSet = false;

  DeliveryAddressModel _userDeliveryAddress = DeliveryAddressModel(
    fullName: "John Doe",
    address: "San Francisco, CA",
    city: "San Francisco",
    postalCode: 94103,
  );

  //getters

  User? get currentUser => _currentUser;
  bool get isDeliveryAddressSet => _isDeliveryAddressSet;
  DeliveryAddressModel get userDeliveryAddress => _userDeliveryAddress;

  Future<void> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString('firstName');
    final lastName = prefs.getString('lastName');
    final email = prefs.getString('email');
    final username = prefs.getString('username');
    final authToken = prefs.getString('jwt');
    if (firstName != null &&
        lastName != null &&
        email != null &&
        username != null) {
      _currentUser = User(
        email: email,
        username: username,
        firstName: firstName,
        lastName: lastName,
        authToken: authToken,
      );
    }
    notifyListeners();
  }

  void saveUserDeliveryAddressToPrefs(
    String fullName,
    String address,
    String city,
    int postalCode,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', fullName);
    await prefs.setString('address', address);
    await prefs.setString('city', city);
    await prefs.setInt('postalCode', postalCode);
  }

  Future<bool> isUserDeliveryAddressSet() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('fullName') != null &&
        prefs.getString('address') != null &&
        prefs.getString('city') != null &&
        prefs.getInt('postalCode') != null) {
      _isDeliveryAddressSet = true;
      notifyListeners();
      return true;
    } else {
      _isDeliveryAddressSet = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> checkIfDeliveryAddressIsSavedToSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('fullName') != null &&
        prefs.getString('address') != null &&
        prefs.getString('city') != null &&
        prefs.getInt('postalCode') != null) {
      _isDeliveryAddressSet = true;
      notifyListeners();
    } else {
      _isDeliveryAddressSet = false;
      notifyListeners();
    }
  }

  Future<void> getUserDeliveryAddressFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final fullName = prefs.getString('fullName') ?? '';
    final address = prefs.getString('address') ?? '';
    final city = prefs.getString('city') ?? '';
    final postalCode = prefs.getInt('postalCode') ?? 0;

    _userDeliveryAddress = DeliveryAddressModel(
      fullName: fullName,
      address: address,
      city: city,
      postalCode: postalCode,
    );
    notifyListeners();
  }


  /// TO DO : Remove this method! (used inside of enter delivery address screen)
  Future<DeliveryAddressModel> getUserDeliveryAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final fullName = prefs.getString('fullName') ?? '';
    final address = prefs.getString('address') ?? '';
    final city = prefs.getString('city') ?? '';
    final postalCode = prefs.getInt('postalCode') ?? 0;

    return DeliveryAddressModel(
      fullName: fullName,
      address: address,
      city: city,
      postalCode: postalCode,
    );
  }
}


///Users Accounts Testing
///stop@gmail.com -> Mirza123!
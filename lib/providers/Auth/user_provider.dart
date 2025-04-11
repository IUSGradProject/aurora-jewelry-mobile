import 'package:aurora_jewelry/models/Auth/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;

  //getters

  User? get currentUser => _currentUser;

  Future<void> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString('firstName');
    final lastName = prefs.getString('lastName');
    final email = prefs.getString('email');
    if (firstName != null && lastName != null && email != null) {
      _currentUser = User(
        email: email,
        firstName: firstName,
        lastName: lastName,
      );
    }
    notifyListeners();
  }
}

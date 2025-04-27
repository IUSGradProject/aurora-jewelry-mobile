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
    final username = prefs.getString('username');
    final authToken = prefs.getString('jwt');
    if (firstName != null && lastName != null && email != null && username != null) {
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
}


///Users Accounts Testing
///stop@gmail.com -> Mirza123!
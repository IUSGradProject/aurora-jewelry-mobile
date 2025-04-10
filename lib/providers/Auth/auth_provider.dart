import 'package:aurora_jewelry/models/Auth/login_response.dart';
import 'package:aurora_jewelry/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isUserAuthenticated = false;
  LoginResponse? _loginResponse;

  //Getters

  bool get isLoading => _isLoading;
  bool get isUserAuthenticated => _isUserAuthenticated;
  LoginResponse? get loginResponse => _loginResponse;

  ///Check if the token exists in SharedPreferences
  Future<void> checkIfAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt'); // Fetch token from preferences
    if (token != null) {
      _isUserAuthenticated = true;
      notifyListeners();
    }
  }

  ///Login function that saves the tooken to SharedPreferences
  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await ApiService().login(email, password);
      if (response != null) {
        _loginResponse = response;
        // Save token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt', response.token);
        _isUserAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Login failed');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ///Logout function to remove the token from SharedPreferences
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
    _isUserAuthenticated = false;
    _loginResponse = null;
    notifyListeners();
  }
}

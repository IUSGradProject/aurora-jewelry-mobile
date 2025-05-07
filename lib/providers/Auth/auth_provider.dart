import 'package:aurora_jewelry/models/Auth/login_response.dart';
import 'package:aurora_jewelry/providers/Auth/user_provider.dart';
import 'package:aurora_jewelry/providers/Cart/cart_provider.dart';
import 'package:aurora_jewelry/providers/Home/navigation_bar_provider.dart';
import 'package:aurora_jewelry/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isUserAuthenticated = false;
  LoginResponse? _loginResponse;

  //Getters

  bool get isLoading => _isLoading;
  bool get isUserAuthenticated => _isUserAuthenticated;
  LoginResponse? get loginResponse => _loginResponse;

  Future<void> saveUserDetailsToPrefs(
    String token,
    String firstName,
    String lastName,
    String email,
    String username,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString('jwt', token),
      prefs.setString('firstName', firstName),
      prefs.setString('lastName', lastName),
      prefs.setString('email', email),
      prefs.setString('username', username),
    ]);
  }

  ///Check if the token exists in SharedPreferences
  Future<void> checkIfAuthenticated(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt'); // Fetch token from preferences
    if (token != null) {
      _isUserAuthenticated = true;
      notifyListeners();
      // Call getCurrentUser from UserProvider
      // ignore: use_build_context_synchronously
      await Provider.of<UserProvider>(context, listen: false).getCurrentUser();
    }
  }

  ///Login function that saves the tooken to SharedPreferences
  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    CartProvider cartProvider =
    // ignore: use_build_context_synchronously
    Provider.of<CartProvider>(context, listen: false);
    try {
      _isLoading = true;
      notifyListeners();
      final response = await ApiService().login(email, password);

      if (response != null) {
        _loginResponse = response;
        // Save User Details to SharedPreferences
        await saveUserDetailsToPrefs(
          response.token,
          response.firstName,
          response.lastName,
          response.email,
          response.username,
        );

        // ignore: use_build_context_synchronously
        await cartProvider.fetchCart(context);

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

  ///Register function that registers user
  ///If registration is success it also logins user

  Future<void> registerAndLogin(
    BuildContext context,
    String firstName,
    String lastName,
    String email,
    String password,
    String username,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();
      await ApiService().registerUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        username: username,
      );
      // If registration succeeds, login user
      // ignore: use_build_context_synchronously
      await login(context, email, password);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deactivateAccount(BuildContext context) async {
    try {
      String? currentUserEmail =
          Provider.of<UserProvider>(context, listen: false).currentUser!.email;
      _isLoading = true;
      notifyListeners();
      await ApiService().deactivateAccount(currentUserEmail);
      // ignore: use_build_context_synchronously
      await logout(context);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ///Logout function to remove the token from SharedPreferences
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    NavigationBarProvider navigationBarProvider =
    // ignore: use_build_context_synchronously
    Provider.of<NavigationBarProvider>(context, listen: false);
    CartProvider cartProvider =
    // ignore: use_build_context_synchronously
    Provider.of<CartProvider>(context, listen: false);
    await prefs.remove('jwt');
    _isUserAuthenticated = false;
    _loginResponse = null;
    cartProvider.clearAll();
    if (navigationBarProvider.currentIndex == 2) {
      navigationBarProvider.setCurrentIndex(0);
    }
    notifyListeners();
  }
}

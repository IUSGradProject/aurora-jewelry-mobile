import 'package:aurora_jewelry/models/Products/product_model.dart';
import 'package:aurora_jewelry/services/api_service.dart';
import 'package:flutter/cupertino.dart';

class DatabaseProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _areProductsFetched = false;

  List<Product> _products = [];

  //Getters

  bool get areProductsFetched => _areProductsFetched;
  List<Product> get products => _products;

  // Method to fetch products
  Future<void> fetchProducts({int page = 1, int pageSize = 20}) async {
    try {
      // Step 1: Fetch the initial paginated products
      final response = await _apiService.getProducts(
        page: page,
        pageSize: pageSize,
      );

      _products = response.data;
      _areProductsFetched = true;

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching productssss: $e');
      _areProductsFetched = false;
      notifyListeners();
    }
  }
}

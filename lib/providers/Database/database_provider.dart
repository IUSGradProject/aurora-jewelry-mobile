import 'package:aurora_jewelry/models/Products/detailed_product_model.dart';
import 'package:aurora_jewelry/models/Products/product_model.dart';
import 'package:aurora_jewelry/providers/Search/search_provider.dart';
import 'package:aurora_jewelry/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DatabaseProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _areProductsFetched = false;
  bool _isDetailedProductFetched = false;

  List<Product> _products = [];
  DetailedProduct? _detailedProduct;

  //Getters

  bool get areProductsFetched => _areProductsFetched;
  List<Product> get products => _products;
  DetailedProduct? get detailedProduct => _detailedProduct;
  bool get isDetailedProductFetched => _isDetailedProductFetched;

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
      debugPrint('Error fetching products: $e');
      _areProductsFetched = false;
      notifyListeners();
    }
  }

  // Method to fetch detailed product
  Future<void> fetchDetailedProduct(String productId, BuildContext context) async {
    try {
      // Step 2: Fetch the detailed product
      final response = await _apiService.getProductById(productId);

      _detailedProduct = response;
      // ignore: use_build_context_synchronously
      Provider.of<SearchProvider>(context, listen: false)
          .setProductPrice(_detailedProduct!.price);
      _isDetailedProductFetched = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching detailed product: $e');
    }
  }

  void resetDetailedProduct(BuildContext context) {
    _detailedProduct = null;
    _isDetailedProductFetched = false;
    Provider.of<SearchProvider>(context, listen: false)
        .setProductPrice(0);
    notifyListeners();
  }

}

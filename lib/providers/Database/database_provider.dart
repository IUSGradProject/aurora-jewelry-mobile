import 'package:aurora_jewelry/models/Orders/previous_order_model.dart';
import 'package:aurora_jewelry/models/Products/brand_model.dart';
import 'package:aurora_jewelry/models/Products/category_model.dart';
import 'package:aurora_jewelry/models/Products/detailed_product_model.dart';
import 'package:aurora_jewelry/models/Products/filter_request_model.dart';
import 'package:aurora_jewelry/models/Products/product_model.dart';
import 'package:aurora_jewelry/models/Products/style_model.dart';
import 'package:aurora_jewelry/providers/Search/search_provider.dart';
import 'package:aurora_jewelry/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DatabaseProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _areProductsFetched = false;
  bool _isDetailedProductFetched = false;

  List<Product> _products = [];
  List<Product> _searchedProducts = [];
  DetailedProduct? _detailedProduct;

  //Search Variables
  List<CategoryModel> _categories = [];
  List<BrandModel> _brands = [];
  List<StyleModel> _styles = [];
  bool _areCategoriesFetched = false;

  //User Details
  //After making sure that this variable is no more in need remove it [_previousUserOrders]
  final List<PreviousOrderModel> _previousUserOrders = [];
  List<List<PreviousOrderModel>> _sortedPreviousOrders = [];
  bool _isUserOrdersFetched = false;

  FilterRequestModel _filterRequestModel = FilterRequestModel(
    categories: [],
    brands: [],
    styles: [],
  );

  //Getters
  bool get areProductsFetched => _areProductsFetched;
  List<Product> get products => _products;
  List<Product> get searchedProducts => _searchedProducts;
  DetailedProduct? get detailedProduct => _detailedProduct;
  bool get isDetailedProductFetched => _isDetailedProductFetched;
  List<CategoryModel> get categories => _categories;
  bool get areCategoriesFetched => _areCategoriesFetched;
  FilterRequestModel get filterRequestModel => _filterRequestModel;
  List<BrandModel> get brands => _brands;
  List<StyleModel> get styles => _styles;

  ///User Related Getters
  List<PreviousOrderModel> get previousUserOrders => _previousUserOrders;
  List<List<PreviousOrderModel>> get sortedPreviousOrders =>
      _sortedPreviousOrders;
  bool get isUserOrdersFetched => _isUserOrdersFetched;

  ///Method to set searched products
  void setSearchedProducts(String searchQuery) {
    _searchedProducts =
        _products
            .where(
              (product) => product.name.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
            )
            .toList();
    notifyListeners();
  }

  ///Method to clear searched products
  void clearSearchedProducts() {
    _searchedProducts.clear();
    notifyListeners();
  }


  ///Method to clear all products
  void clearAllProducts() {
    _products.clear();
    notifyListeners();
  }


  /// Method to fetch products
  Future<void> fetchProducts({int page = 1, int pageSize = 20}) async {
    try {
      _areProductsFetched = false;

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

  /// Method to set filter request model
  void setFilterRequestModel(FilterRequestModel filterRequestModel) {
    _filterRequestModel = filterRequestModel;
    notifyListeners();
  }

  void setCategoryForFilterRequestModel(
    CategoryModel category,
    BuildContext context,
  ) {
    _filterRequestModel.categories.add(category.id);
    notifyListeners();
  }

  void removeCategoryFromFilterRequestModel(CategoryModel category) {
    _filterRequestModel.categories.remove(category.id);
    notifyListeners();
  }

  void clearSelectedCategories() {
    _filterRequestModel.categories.clear();
    notifyListeners();
  }

  void clearSelectedBrands() {
    _filterRequestModel.brands.clear();
    notifyListeners();
  }

  void clearSelectedStyles() {
    _filterRequestModel.styles.clear();
    notifyListeners();
  }

  void resetPriceRangeForFilterRequestModel() {
    _filterRequestModel.minPrice = null;
    _filterRequestModel.maxPrice = null;
    notifyListeners();
  }

  /// Method to reset filter request model
  void resetFilterRequestModel() {
    _filterRequestModel = FilterRequestModel(
      categories: _filterRequestModel.categories,
      brands: [],
      styles: [],
    );
    notifyListeners();
  }

  /// Method to fetch filtered products

  Future<void> fetchFilteredProducts({int page = 1, int pageSize = 20}) async {
    try {
      _areProductsFetched = false;
      notifyListeners();

      // Step 1: Fetch the filtered products
      final response = await _apiService.getProductsWithFilters(
        _filterRequestModel,
        pageNumber: page,
        pageSize: pageSize,
      );
      _products = response.data;
      _areProductsFetched = true;
      notifyListeners();
    } catch (e) {
      _areProductsFetched = false;
      notifyListeners();
      debugPrint('Error fetching filtered products: $e');
    }
  }

  /// Method to fetch detailed product
  Future<void> fetchDetailedProduct(
    String productId,
    BuildContext context,
  ) async {
    try {
      // Step 2: Fetch the detailed product
      final response = await _apiService.getProductById(productId);

      _detailedProduct = response;
      // ignore: use_build_context_synchronously
      Provider.of<SearchProvider>(
        // ignore: use_build_context_synchronously
        context,
        listen: false,
      ).setProductPrice(_detailedProduct!.price);
      _isDetailedProductFetched = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching detailed product: $e');
    }
  }

  void resetDetailedProduct(BuildContext context) {
    _detailedProduct = null;
    _isDetailedProductFetched = false;
    Provider.of<SearchProvider>(context, listen: false).setProductPrice(0);
    notifyListeners();
  }

  /// Method to fetch categories
  Future<void> fetchCategories() async {
    try {
      _categories = await _apiService.getCategories();
      _areCategoriesFetched = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }
  }

  /// Method to fetch brands

  Future<void> fetchBrands() async {
    try {
      _brands = await _apiService.getBrands();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching brands: $e');
    }
  }

  /// Method to fetch styles
  Future<void> fetchStyles() async {
    try {
      _styles = await _apiService.getStyles();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching styles: $e');
    }
  }

  Future<void> fetchPreviousUserOrders(
    String userToken, {
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      _isUserOrdersFetched = false;
      notifyListeners();

      // Fetch all orders from the API
      List<PreviousOrderModel> allPreviousUserOrders = await _apiService
          .getUserPurchaseHistory(
            userToken,
            pageNumber: pageNumber,
            pageSize: pageSize,
          );

      // Group orders by normalized date (rounded to minute)
      Map<DateTime, List<PreviousOrderModel>> grouped = {};

      for (var order in allPreviousUserOrders) {
        final normalizedDate = DateTime(
          order.orderDate.year,
          order.orderDate.month,
          order.orderDate.day,
          order.orderDate.hour,
          order.orderDate.minute,
        );

        grouped.putIfAbsent(normalizedDate, () => []);
        grouped[normalizedDate]!.add(order);
      }

      // Convert to List<List<PreviousOrderModel>> and sort by date descending
      _sortedPreviousOrders =
          grouped.entries.map((entry) {
              final orders = entry.value;
              orders.sort(
                (a, b) => a.orderDate.compareTo(b.orderDate),
              ); // sort items inside
              return orders;
            }).toList()
            ..sort(
              (a, b) => b.first.orderDate.compareTo(a.first.orderDate),
            ); // sort groups

      _isUserOrdersFetched = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching previous user orders: $e');
    }
  }
}

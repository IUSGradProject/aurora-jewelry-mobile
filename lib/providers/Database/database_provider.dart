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

  /// Method to fetch products
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
      categories: [],
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
      print(
        "I am in fetchFilteredProducts, and categories are: ${_filterRequestModel.maxPrice}",
      );
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
}

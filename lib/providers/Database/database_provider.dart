import 'package:aurora_jewelry/models/Orders/previous_order_model.dart';
import 'package:aurora_jewelry/models/Products/brand_model.dart';
import 'package:aurora_jewelry/models/Products/category_model.dart';
import 'package:aurora_jewelry/models/Products/detailed_product_model.dart';
import 'package:aurora_jewelry/models/Products/filter_request_model.dart';
import 'package:aurora_jewelry/models/Products/product_model.dart';
import 'package:aurora_jewelry/models/Products/sort_model.dart';
import 'package:aurora_jewelry/models/Products/style_model.dart';
import 'package:aurora_jewelry/providers/Search/search_provider.dart';
import 'package:aurora_jewelry/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DatabaseProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _areProductsFetched = false;
  bool _isDetailedProductFetched = false;

  //Pagination Variables (Fetch Products)
  int _currentPage = 1;
  bool _isFetchingMoreProducts = false;
  bool _hasMore = true;

  //Pagination variables (Fetch Filtered Products)
  int _filteredCurrentPage = 1;
  bool _isFetchingMoreFiltered = false;
  bool _hasMoreFilteredProducts = true;

  //Pagination variables (Fetch Previous User Orders)
  bool _isFetchingMoreOrders = false;
  bool _hasMoreUserOrders = true;
  int _currentOrdersPage = 1;

  //Products Variables
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
  bool get isFetchingMoreProducts => _isFetchingMoreProducts;
  bool get isFetchingMoreFiltered => _isFetchingMoreFiltered;
  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;
  List<CategoryModel> get categories => _categories;
  bool get areCategoriesFetched => _areCategoriesFetched;
  FilterRequestModel get filterRequestModel => _filterRequestModel;
  List<BrandModel> get brands => _brands;
  List<StyleModel> get styles => _styles;

  ///User Related Getters
  List<PreviousOrderModel> get previousUserOrders => _previousUserOrders;
  List<List<PreviousOrderModel>> get sortedPreviousOrders =>
      _sortedPreviousOrders;
  bool get hasMoreUserOrders => _hasMoreUserOrders;
  int get currentOrdersPage => _currentOrdersPage;
  bool get isFetchingMoreOrders => _isFetchingMoreOrders;
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
      if (page == 1) {
        _products.clear();
      }

      _areProductsFetched = false;

      // Step 1: Fetch the initial paginated products
      final response = await _apiService.getProducts(
        page: page,
        pageSize: pageSize,
      );
      if (response.data.isEmpty || response.data.length < pageSize) {
        _hasMore = false;
      } else {
        _hasMore = true;
      }
      if (page == 1) {
        _products = response.data;
      } else {
        _products.addAll(response.data);
      }

      if (page == 1) {
        _currentPage = page;
      } else {
        _currentPage++;
      }

      _currentPage = page;
      _areProductsFetched = true;

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching products: $e');
      _areProductsFetched = false;
      _hasMore = false;
      notifyListeners();
    }
  }

  /// Method to fetch more products
  Future<void> fetchMoreProducts() async {
    if (_isFetchingMoreProducts || !_hasMore) return;
    _isFetchingMoreProducts = true;

    await fetchProducts(page: _currentPage + 1);
    _isFetchingMoreProducts = false;
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

  void setSortForFilterRequestModel(SortModel sort) {
    _filterRequestModel.sortBy = sort.sortBy;
    _filterRequestModel.sortDesc = sort.sortDesc;
    notifyListeners();
  }

  void cleanSortForFilterRequestModel() {
    _filterRequestModel.sortBy = 'name';
    _filterRequestModel.sortDesc = false;
    notifyListeners();
  }

  void resetPriceRangeForFilterRequestModel() {
    _filterRequestModel.minPrice = null;
    _filterRequestModel.maxPrice = null;
    notifyListeners();
  }

  /// Method to reset filter request model
  void resetFilterRequestModel() {
    //Saving categoriy as previous one because it is used in the filter
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
      _filteredCurrentPage = page;
      _hasMoreFilteredProducts = true;
      notifyListeners();

      final response = await _apiService.getProductsWithFilters(
        _filterRequestModel,
        pageNumber: page,
        pageSize: pageSize,
      );

      _products = response.data;
      _areProductsFetched = true;

      // If less than pageSize, we know there are no more pages
      if (response.data.length < pageSize) {
        _hasMoreFilteredProducts = false;
      }

      notifyListeners();
    } catch (e) {
      _areProductsFetched = false;
      notifyListeners();
      debugPrint('Error fetching filtered products: $e');
    }
  }

  /// Method to fetch more filtered products
  Future<void> fetchMoreFilteredProducts({int pageSize = 20}) async {
    if (_isFetchingMoreFiltered || !_hasMoreFilteredProducts) return;

    try {
      _isFetchingMoreFiltered = true;
      notifyListeners();

      final nextPage = _filteredCurrentPage + 1;
      final response = await _apiService.getProductsWithFilters(
        _filterRequestModel,
        pageNumber: nextPage,
        pageSize: pageSize,
      );

      if (response.data.isNotEmpty) {
        _products.addAll(response.data);
        _filteredCurrentPage = nextPage;
      }

      if (response.data.length < pageSize) {
        _hasMoreFilteredProducts = false;
      }

      _isFetchingMoreFiltered = false;
      notifyListeners();
    } catch (e) {
      _isFetchingMoreFiltered = false;
      notifyListeners();
      debugPrint('Error fetching more filtered products: $e');
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
      _hasMoreUserOrders = true;
      _currentOrdersPage = pageNumber;
      _sortedPreviousOrders = [];
      notifyListeners();

      List<PreviousOrderModel> allPreviousUserOrders = await _apiService
          .getUserPurchaseHistory(
            userToken,
            pageNumber: pageNumber,
            pageSize: pageSize,
          );

      _sortedPreviousOrders = _groupOrders(allPreviousUserOrders);

      if (allPreviousUserOrders.length < pageSize) {
        _hasMoreUserOrders = false;
      }

      _isUserOrdersFetched = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching previous user orders: $e');
      _isUserOrdersFetched = true; // Still notify to end loading state
      notifyListeners();
    }
  }

  Future<void> fetchMorePreviousUserOrders(
    String userToken, {
    int pageSize = 10,
  }) async {
    if (_isFetchingMoreOrders || !_hasMoreUserOrders) return;

    try {
      _isFetchingMoreOrders = true;
      notifyListeners();

      final nextPage = _currentOrdersPage + 1;

      List<PreviousOrderModel> moreOrders = await _apiService
          .getUserPurchaseHistory(
            userToken,
            pageNumber: nextPage,
            pageSize: pageSize,
          );

      final newGrouped = _groupOrders(moreOrders);
      _sortedPreviousOrders.addAll(newGrouped);

      if (moreOrders.length < pageSize) {
        _hasMoreUserOrders = false;
      } else {
        _currentOrdersPage = nextPage;
      }

      _isFetchingMoreOrders = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching more previous orders: $e');
      _isFetchingMoreOrders = false;
      notifyListeners();
    }
  }

  List<List<PreviousOrderModel>> _groupOrders(List<PreviousOrderModel> orders) {
    final grouped = <DateTime, List<PreviousOrderModel>>{};

    for (var order in orders) {
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

    return grouped.entries.map((entry) {
        final group = entry.value;
        group.sort((a, b) => a.orderDate.compareTo(b.orderDate));
        return group;
      }).toList()
      ..sort((a, b) => b.first.orderDate.compareTo(a.first.orderDate));
  }
}

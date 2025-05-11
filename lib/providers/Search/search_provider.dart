import 'package:aurora_jewelry/models/Products/brand_model.dart';
import 'package:aurora_jewelry/models/Products/category_model.dart';
import 'package:aurora_jewelry/models/Products/sort_model.dart';
import 'package:aurora_jewelry/models/Products/style_model.dart';
import 'package:aurora_jewelry/providers/Database/database_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SearchProvider extends ChangeNotifier {
  final List<CategoryModel> _categories = [];

  bool _isSearchingActive = false;
  String _searchQuery = "";

  final List<CategoryModel> _selectedCategories = [];

  ///Select Sorting
  final List<SortModel> _sortingOptions = [
    SortModel(name: 'A to Z', sortBy: 'name', sortDesc: false),
    SortModel(name: 'Z to A', sortBy: 'name', sortDesc: true),
    SortModel(name: 'Highest to lowest price', sortBy: 'price', sortDesc: true),
    SortModel(
      name: 'Lowest to highest price',
      sortBy: 'price',
      sortDesc: false,
    ),
  ];

  final List<SortModel> _selectedSorting = [];
  final List<BrandModel> _selectedFilterBrands = [];
  final List<StyleModel> _selectedFilterStyles = [];
  RangeValues _priceRange = RangeValues(1, 100000);

  //Product Ordering Variables

  ///Current product quantity minimul value should be 1.
  int _currentProductQuantity = 1;

  double _currentProductPrice = 0;
  double _quantityProductPrice = 0;

  //Getters

  bool get isSearchingActive => _isSearchingActive;
  String get searchQuery => _searchQuery;
  List<CategoryModel> get categories => _categories;
  List<CategoryModel> get selectedCategories => _selectedCategories;
  List<SortModel> get sortingOptions => _sortingOptions;

  List<SortModel> get selectedSorting => _selectedSorting;
  int get currentProductQuantity => _currentProductQuantity;
  double get currentProductPrice => _currentProductPrice;
  double get quantityProductPrice => _quantityProductPrice;

  List<BrandModel> get selectedFilterBrands => _selectedFilterBrands;
  List<StyleModel> get selectedFilterStyles => _selectedFilterStyles;
  RangeValues get priceRange => _priceRange;

  ///Select Category
  ///

  void setSearchingStatus(bool status) {
    _isSearchingActive = status;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearchQuery() {
    _searchQuery = "";
    notifyListeners();
  }

  Future<void> selectCategory(
    CategoryModel category,
    BuildContext context,
  ) async {
    _selectedCategories.add(category);
    Provider.of<DatabaseProvider>(
      context,
      listen: false,
    ).setCategoryForFilterRequestModel(category, context);
    await Provider.of<DatabaseProvider>(
      context,
      listen: false,
    ).fetchFilteredProducts();
    notifyListeners();
  }

  void deselectCategory(CategoryModel category, BuildContext context) {
    _selectedCategories.remove(category);
    Provider.of<DatabaseProvider>(
      context,
      listen: false,
    ).removeCategoryFromFilterRequestModel(category);
    notifyListeners();
  }

  Future<void> selectAllCategories(BuildContext context) async {
    _selectedCategories.clear();
    _selectedCategories.addAll(
      Provider.of<DatabaseProvider>(context, listen: false).categories,
    );
    await Provider.of<DatabaseProvider>(context, listen: false).fetchProducts();
    _selectedCategories.addAll(_categories);
    notifyListeners();
  }

  void deselectAllCategories() {
    _selectedCategories.clear();
    notifyListeners();
  }

  bool checkIfCategoryIsSelected(CategoryModel category) {
    if (_selectedCategories.contains(category)) {
      return true;
    } else {
      return false;
    }
  }

  void clearSelectedCategories(BuildContext context) {
    _selectedCategories.clear();
    Provider.of<DatabaseProvider>(
      context,
      listen: false,
    ).clearSelectedCategories();
    notifyListeners();
  }

  double getTextWidth(BuildContext context, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: CupertinoTheme.of(context).textTheme.textStyle,
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width + 60; // Add padding/margin adjustments
  }

  String returnNameOfSearcTextField() {
    if (_selectedCategories.isEmpty) {
      return "Search Aurora";
    } else {
      return "Search ${_selectedCategories[0].name}";
    }
  }

  ///Sorting

  void selectSort(BuildContext context, SortModel sort) {
    if (_selectedSorting.contains(sort)) {
      _selectedSorting.clear();
    } else {
      _selectedSorting.clear();

      _selectedSorting.add(sort);
      //Setting values for the filter request model inside of [DatabaseProvider]
      Provider.of<DatabaseProvider>(
        context,
        listen: false,
      ).setSortForFilterRequestModel(sort);
    }
    notifyListeners();
  }

  //Product price

  void setProductPrice(double price) {
    _currentProductPrice = price;
    _quantityProductPrice = price;
    //This is for the first time when user select the product.
    _currentProductQuantity = 1;
    notifyListeners();
  }

  void incrementCurrentProductQuantity() {
    _currentProductQuantity = _currentProductQuantity + 1;
    _quantityProductPrice = _currentProductPrice * currentProductQuantity;
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  void decrementCurrentProductQuantity() {
    if (_currentProductQuantity > 1) {
      _currentProductQuantity = _currentProductQuantity - 1;
      _quantityProductPrice = _currentProductPrice * currentProductQuantity;
      HapticFeedback.mediumImpact();
    }
    notifyListeners();
  }

  ///Filters

  void setPriceRange(RangeValues rangeValues) {
    _priceRange = rangeValues;
    notifyListeners();
  }

  void restartPriceRange(context) {
    _priceRange = RangeValues(1, 100000);
    Provider.of<DatabaseProvider>(
      context,
      listen: false,
    ).resetPriceRangeForFilterRequestModel();
    notifyListeners();
  }

  bool checkIfBrandIsAdded(BrandModel brand) {
    if (_selectedFilterBrands.contains(brand)) {
      return true;
    } else {
      return false;
    }
  }

  void selectBrand(BrandModel brand) {
    if (checkIfBrandIsAdded(brand)) {
      _selectedFilterBrands.remove(brand);
    } else {
      _selectedFilterBrands.add(brand);
    }
    notifyListeners();
  }

  void clearSelectedBrands(BuildContext context) {
    _selectedFilterBrands.clear();
    Provider.of<DatabaseProvider>(context, listen: false).clearSelectedBrands();
    notifyListeners();
  }

  bool checkIfStyleIsAdded(StyleModel style) {
    if (_selectedFilterStyles.contains(style)) {
      return true;
    } else {
      return false;
    }
  }

  void selectStyle(StyleModel style) {
    if (_selectedFilterStyles.contains(style)) {
      _selectedFilterStyles.remove(style);
    } else {
      _selectedFilterStyles.add(style);
    }
    notifyListeners();
  }

  void clearSelectedStyles(BuildContext context) {
    _selectedFilterStyles.clear();
    Provider.of<DatabaseProvider>(context, listen: false).clearSelectedStyles();
    notifyListeners();
  }

  String formatBrandList() {
    return selectedFilterBrands.map((brand) => brand.name).join(', ');
  }

  String formatStyleList() {
    return selectedFilterStyles.map((style) => style.name).join(', ');
  }

  bool checkIsRangeChanged() {
    if (_priceRange != RangeValues(1, 100000)) {
      return true;
    } else {
      return false;
    }
  }

  bool checkIfThereWasChangesInFilters() {
    if (_priceRange != RangeValues(1, 100000) ||
        _selectedFilterBrands.isNotEmpty ||
        _selectedFilterStyles.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void clearAllFilters(BuildContext context) {
    _selectedFilterBrands.clear();
    _selectedFilterStyles.clear();
    _priceRange = RangeValues(1, 100000);
    Provider.of<DatabaseProvider>(
      context,
      listen: false,
    ).resetFilterRequestModel();

    notifyListeners();
  }
}

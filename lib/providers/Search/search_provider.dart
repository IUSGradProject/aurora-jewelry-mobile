import 'package:aurora_jewelry/models/Products/brand_model.dart';
import 'package:aurora_jewelry/models/Products/category_model.dart';
import 'package:aurora_jewelry/models/Products/filter_request_model.dart';
import 'package:aurora_jewelry/models/Products/style_model.dart';
import 'package:aurora_jewelry/providers/Database/database_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SearchProvider extends ChangeNotifier {
  final List<CategoryModel> _categories = [];

  final List<CategoryModel> _selectedCategories = [];

  final List<String> _selectedSorting = [];
  final List<BrandModel> _selectedFilterBrands = [];
  final List<StyleModel> _selectedFilterStyles = [];
  RangeValues _priceRange = RangeValues(10, 10000);

  //Product Ordering Variables

  ///Current product quantity minimul value should be 1.
  int _currentProductQuantity = 1;

  double _currentProductPrice = 0;
  double _quantityProductPrice = 0;

  //Getters

  List<CategoryModel> get categories => _categories;
  List<CategoryModel> get selectedCategories => _selectedCategories;

  List<String> get selectedSorting => _selectedSorting;
  int get currentProductQuantity => _currentProductQuantity;
  double get currentProductPrice => _currentProductPrice;
  double get quantityProductPrice => _quantityProductPrice;

  List<BrandModel> get selectedFilterBrands => _selectedFilterBrands;
  List<StyleModel> get selectedFilterStyles => _selectedFilterStyles;
  RangeValues get priceRange => _priceRange;

  ///Select Category

  Future<void> selectCategory(
    CategoryModel category,
    BuildContext context,
  ) async {
    _selectedCategories.add(category);
    Provider.of<DatabaseProvider>(context, listen: false).setFilterRequestModel(
      FilterRequestModel(categories: [category.id], brands: [], styles: []),
    );
    await Provider.of<DatabaseProvider>(
      context,
      listen: false,
    ).fetchFilteredProducts();
    notifyListeners();
  }

  void deselectCategory(CategoryModel category, BuildContext context) {
    _selectedCategories.remove(category);
    Provider.of<DatabaseProvider>(context, listen: false).setFilterRequestModel(
      FilterRequestModel(categories: [], brands: [], styles: []),
    );
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

  void clearSelectedCategories() {
    _selectedCategories.clear();
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

  void selectSort(String sortName) {
    if (_selectedSorting.contains(sortName)) {
      _selectedSorting.clear();
    } else {
      _selectedSorting.clear();
      _selectedSorting.add(sortName);
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

  void restartPriceRange() {
    _priceRange = RangeValues(10, 10000);
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

  void clearSelectedBrands() {
    _selectedFilterBrands.clear();
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

  void clearSelectedStyles() {
    _selectedFilterStyles.clear();
    notifyListeners();
  }

  String formatBrandList() {
    return selectedFilterBrands.map((brand) => brand.name).join(', ');
  }

  String formatStyleList() {
    return selectedFilterStyles.map((style) => style.name).join(', ');
  }

  bool checkIsRangeChanged() {
    if (_priceRange != RangeValues(10, 10000)) {
      return true;
    } else {
      return false;
    }
  }

  bool checkIfThereWasChangesInFilters() {
    if (_priceRange != RangeValues(10, 10000) ||
        _selectedFilterBrands.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}

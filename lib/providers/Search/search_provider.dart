import 'package:aurora_jewelry/models/Search/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchProvider extends ChangeNotifier {
  final List<CategoryModel> _categories = [
    CategoryModel(name: "Necklace", icon: CupertinoIcons.link),
    CategoryModel(name: "Earrings", icon: CupertinoIcons.circle_fill),
    CategoryModel(name: "Bracelets", icon: CupertinoIcons.link_circle),
    CategoryModel(name: "Rings", icon: CupertinoIcons.capsule),
    CategoryModel(name: "Watches", icon: CupertinoIcons.time),
  ];
  final List<String> _availableBrands = [
    "Dior",
    "Gucci",
    "Versace",
    "Balenciaga",
    "Nike",
    "Adidas",
  ];

  final List<CategoryModel> _selectedCategories = [];

  final List<String> _selectedSorting = [];
  final List<String> _selectedFilterBrands = [];
  RangeValues _priceRange = RangeValues(10, 10000);

  //Product Ordering Variables

  ///Current product quantity minimul value should be 1.
  int _currentProductQuantity = 1;

  double _currentProductPrice = 1050;

  //Getters

  List<CategoryModel> get categories => _categories;
  List<CategoryModel> get selectedCategories => _selectedCategories;
  List<String> get selectedSorting => _selectedSorting;
  int get currentProductQuantity => _currentProductQuantity;
  double get currentProductPrice => _currentProductPrice;

  List<String> get selectedFilterBrands => _selectedFilterBrands;
  RangeValues get priceRange => _priceRange;
  List<String> get availableBrands => _availableBrands;

  ///Select Category

  void selectCategory(CategoryModel category) {
    _selectedCategories.add(category);
    notifyListeners();
  }

  void deselectCategory(CategoryModel category) {
    _selectedCategories.remove(category);
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

  void incrementCurrentProductQuantity() {
    _currentProductQuantity = _currentProductQuantity + 1;
    _currentProductPrice = 1050.0 * currentProductQuantity;
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  void decrementCurrentProductQuantity() {
    if (_currentProductQuantity > 1) {
      _currentProductQuantity = _currentProductQuantity - 1;
      _currentProductPrice = 1050.0 * currentProductQuantity;
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

  bool checkIfBrandIsAdded(String brandName) {
    if (_selectedFilterBrands.contains(brandName)) {
      return true;
    } else {
      return false;
    }
  }

  void selectBrand(String brandName) {
    if (checkIfBrandIsAdded(brandName)) {
      _selectedFilterBrands.remove(brandName);
    } else {
      _selectedFilterBrands.add(brandName);
    }
    notifyListeners();
  }

  void clearSelectedBrands() {
    _selectedFilterBrands.clear();
    notifyListeners();
  }

  String formatBrandList() {
    return selectedFilterBrands.join(', ');
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

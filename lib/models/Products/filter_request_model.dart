class FilterRequestModel {
  final List<int> categories;
  final List<int> styles;
  final List<int> brands;
  double? minPrice;
  double? maxPrice;
  final String? query;
  final int? queryCategoryId;
  final String? sortBy;
  final bool sortDesc;

  FilterRequestModel({
    required this.categories,
    required this.styles,
    required this.brands,
    this.minPrice,
    this.maxPrice,
    this.query,
    this.queryCategoryId,
    this.sortBy,
    this.sortDesc = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'categories': categories,
      'styles': styles,
      'brands': brands,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'query': query,
      'queryCategoryId': queryCategoryId,
      'sortBy': sortBy,
      'sortDesc': sortDesc,
    };
  }
}

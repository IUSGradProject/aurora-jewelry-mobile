import 'package:aurora_jewelry/models/Products/product_model.dart';

class PaginatedProductsResponse {
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final List<Product> data;

  PaginatedProductsResponse({
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.data,
  });

  factory PaginatedProductsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedProductsResponse(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalCount: json['totalCount'],
      data: List<Product>.from(json['data'].map((x) => Product.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    'pageNumber': pageNumber,
    'pageSize': pageSize,
    'totalCount': totalCount,
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

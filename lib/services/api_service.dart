import 'dart:convert';

import 'package:aurora_jewelry/models/Auth/login_response.dart';
import 'package:aurora_jewelry/models/Products/brand_model.dart';
import 'package:aurora_jewelry/models/Products/category_model.dart';
import 'package:aurora_jewelry/models/Products/detailed_product_model.dart';
import 'package:aurora_jewelry/models/Products/filter_request_model.dart';
import 'package:aurora_jewelry/models/Products/paginated_products_response.dart';
import 'package:aurora_jewelry/models/Products/style_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ApiService {
  static const auroraBackendUrl = 'https://heyappo.me/aurora/api';

  ///Function that calls register api
  Future<LoginResponse?> login(String email, String password) async {
    final url = Uri.parse('$auroraBackendUrl/Users/Login');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json', 'Accept': '*/*'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return LoginResponse.fromJson(json);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Login Failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String username,
  }) async {
    final url = Uri.parse('$auroraBackendUrl/Users');

    final headers = {'Accept': '*/*', 'Content-Type': 'application/json'};

    final body = jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'username': username,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Registration failed');
      }

      // success = do nothing, let caller proceed to login
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedProductsResponse> getProducts({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await http.get(
      Uri.parse(
        '$auroraBackendUrl/products/all?pageNumber=$page&pageSize=$pageSize',
      ),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return PaginatedProductsResponse.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<PaginatedProductsResponse> getProductsWithFilters(
    FilterRequestModel filters, {
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    final url = Uri.parse(
      '$auroraBackendUrl/products/all?pageNumber=$pageNumber&pageSize=$pageSize',
    );

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(filters.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return PaginatedProductsResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  Future<DetailedProduct> getProductById(String productId) async {
    final response = await http.get(
      Uri.parse(
        '$auroraBackendUrl/products/$productId',
      ), // Assuming this is the correct endpoint
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return DetailedProduct.fromJson(jsonBody); // Return the detailed product
    } else {
      throw Exception('Failed to load product details');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(
      Uri.parse('$auroraBackendUrl/attributes/categories'),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<CategoryModel> categories = [];
      for (var categoryJson in jsonBody) {
        categories.add(CategoryModel.fromJson(categoryJson));
      }
      return categories; // Ensure a list is always returned
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<BrandModel>> getBrands() async {
    final response = await http.get(
      Uri.parse('$auroraBackendUrl/attributes/brands'),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return (jsonBody as List)
        .map((item) => BrandModel.fromJson(item))
        .toList();
    } else {
      throw Exception('Failed to load brands');
    }
  }

  Future<List<StyleModel>> getStyles() async {
    final response = await http.get(
      Uri.parse('$auroraBackendUrl/attributes/styles'),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
       return (jsonBody as List)
        .map((item) => StyleModel.fromJson(item))
        .toList();
    } else {
      throw Exception('Failed to load styles');
    }
  }

}

import 'dart:convert';

import 'package:aurora_jewelry/models/Auth/login_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const auroraBackendUrl = 'https://heyappo.me/aurora/api';

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
      print('Login error: $e');
      rethrow;
    }
  }
}

class LoginResponse {
  final String token;
  final String? username;
  final String? email;

  LoginResponse({
    required this.token,
    this.username,
    this.email,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      username: json['username'],
      email: json['email'],
    );
  }
}

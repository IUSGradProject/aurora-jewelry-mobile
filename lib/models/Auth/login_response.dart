class LoginResponse {
  final String token;
  final String username;
  final String email;
  final String firstName;
  final String lastName;

  LoginResponse({
    required this.token,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}

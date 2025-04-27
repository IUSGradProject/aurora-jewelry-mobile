class User {
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String? authToken;

  User({
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.authToken,
  });
}

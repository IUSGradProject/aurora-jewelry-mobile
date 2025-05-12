# 📱Aurora Jewelry Mobile

Aurora Jewelry Mobile is a modern mobile application designed to deliver a smooth shopping and browsing experience for jewelry lovers. It supports both light and dark themes and provides a polished user interface across screens.

# ⚙️ State Management
The application uses Provider for state management.

- ✅ Clean separation of concerns
- ✅ Efficient UI updates through ChangeNotifier
- ✅ Global state access with scoped listeners

# 🌐 REST API Communication
Aurora Jewelry Mobile integrates with a custom-built backend developed using .NET Core, enabling full e-commerce functionality through secure and efficient REST API communication.

🔧 Backend Highlights

- Built with **.NET Core**
- Hosted on a live server secure HTTPS
- Follows RESTful convetions
- Token-based **Authentication & Authorization** (JWT Token)
- Handles
  - 🛍️ Product listing and filtering
  -  🛒 Cart operations
  - 🔐 User authentication
  - 📦 Order management
 
📡 API Call Example (Dart using http) - Login Function:

```bash
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
```
LoginResponse Model: 
```bash
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

```
#### 🧰 Tools Used
- **Postman** for testing and debugging endpoints  
- **CI/CD Pipelines (GitHub Actions)** for automating tests and deploying backend updates [View Workflow Status](https://github.com/IUSGradProject/backend-repository/actions)

---
## 📁 Folder Architecture
A modular and maintainable architecture: 

```bash
├── assets
├── components
│   ├── Cart
│   ├── Products
│   ├── Profile
│   └── Search
│   
├── models
│   ├── Auth
│   ├── Cart
│   ├── Discover
│   ├── Orders
│   └── Orders
├── providers
│   ├── Auth
│   ├── Cart
│   ├── Database
│   ├── Discover
│   ├── Home
│   └── Search
├── screens
│   ├── Authentication
│   └── Home
├── services
│   └── api_service.dart
└── widgets
    ├── Authentication
    ├── Cart
    └── Search
```
## 📦 APK Download

You can download and try the latest version of the app:

👉 **[Download Aurora Jewelry APK](https://drive.google.com/file/d/1a8PGDIdc3rBA8c8yn0LX5G7l1YZxTjKs/view?usp=sharing)**  

---
### 🔐 Authentication 

| Login Screen | Registration Screen | 
|--------------|----------------------|
| <img height="400" alt="Login Screen" src="https://github.com/user-attachments/assets/73fb3b4a-d166-4a11-9745-3ae1f2fbd808" /> | <img height="400" alt="Register Screen" src="https://github.com/user-attachments/assets/da3dfb27-c482-4c2b-b074-604b041d971a" />|

---
### 🏠 Discover Screen

| Discover Light Mode| Discover Dark Mode | 
|--------------------|--------------------|
| <img  height = "400" alt="Discover Screen" src="https://github.com/user-attachments/assets/2f7330d8-197c-4558-a968-a3ca75913e97" /> | <img height = "400" alt="Discover Screen" src="https://github.com/user-attachments/assets/7562cc0e-3447-47a0-935b-634692413185" />|

---
### 👀 Search Screen

| Search Light Mode | Filter Search Modal Mode| Sort Search | Query Search |
|-------------------|-------------------------|-------------|--------------|
| <img height="400" alt="Search Screen" src="https://github.com/user-attachments/assets/be3a2229-0d66-4167-af56-96f7f8c42216" /> |<img height="400" alt="Filter Modal - Feature" src="https://github.com/user-attachments/assets/a30ace01-438f-48ea-a4cf-66330b3ac4ce" />| <img height="400" alt="Filter Modal - Sort:Feature" src="https://github.com/user-attachments/assets/0c65b9c8-49d4-4f67-b124-93c8ef756db7" /> | <img height="400" alt="Search Screen - Search" src="https://github.com/user-attachments/assets/7258ff14-f408-4573-a1ee-b8b9a2d12705" />
|<img height="400" alt="Search Screen" src="https://github.com/user-attachments/assets/b6c413a2-bfd7-4891-a1f6-ab2f77eb419b" /> | <img height="400" alt="Filter Modal Screen" src="https://github.com/user-attachments/assets/e128a73d-ba87-486c-8ebb-e4e5d2e83a3a" />|

---

### 🛒 Cart Screen

| Cart Screen Light Mode | Empty Cart Dark Mode |
|------------------------|----------------------|
|<img height="400" alt="Cart Screen - Selected Item" src="https://github.com/user-attachments/assets/1d8cb3c6-9dbb-4b5a-8b67-677913d40cbb" /> | <img height="400" alt="Cart Screen" src="https://github.com/user-attachments/assets/0baa9090-3f79-42f4-b111-aa1a411a17d0" />|

---

### 💍 Product Detail Screen

| Light Mode | Dark Mode |
|------------|-----------|
| <img height="400" alt="Product Screen - Top" src="https://github.com/user-attachments/assets/1fa2d82e-7143-4460-b38b-5534875846d6" /> | <img height="400" alt="Product Screen" src="https://github.com/user-attachments/assets/7df3a446-ba0d-4cbd-b371-cae5005cadee" /> |

---

### 💍 Invoice Screen

| Invoice Screen | Edit Address Screen | Order Recieved Screen |
|----------------|---------------------|-----------------------|
| <img height="400" alt="Invoice Screen - Without Addess" src="https://github.com/user-attachments/assets/8ef6c817-662e-47b5-9122-4069160e4c57" /> | <img height="400" alt="Edit Address Screen " src="https://github.com/user-attachments/assets/d03a30dd-1a51-4bdf-be5e-8b26185b2b44" /> | <img height="400" alt="Order Recieved Screen" src="https://github.com/user-attachments/assets/65a84fb5-8c8c-4180-ab7c-28cfe71b495f" />|

---

### 👤 Profile Screen

| Profile Light Mode | Dark Mode |
|--------------------|-----------|
| <img height="400" alt="Profile Screen" src="https://github.com/user-attachments/assets/54d98c31-4473-4426-9e19-39c5c30e21b1" /> | <img height="400" alt="Profile Screen" src="https://github.com/user-attachments/assets/631d584c-66cb-468a-a67e-751583314c71" /> |
|<img height="400" alt="Profile Screen - Feature" src="https://github.com/user-attachments/assets/c5d43656-2a8a-4490-9f2d-366e5d92e7bc" />|

---

## 🛠️ Tech Stack

- Flutter
- Dart
- Provider (State Management)
- Responsive UI
- Light & Dark Theme Support

---

## 📎 License
This project is licensed under the [MIT License](LICENSE).

It was developed by Mirza Kadrić as part of a graduation project at the International University of Sarajevo (IUS).  
While the application was coded entirely by Mirza Kadric, feature suggestions were contributed by team members:  
Adna Dedić, Anes Piknjač, and Amina Mujezinović. 

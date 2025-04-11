import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:aurora_jewelry/components/cupertino_snack_bar.dart';
import 'package:aurora_jewelry/providers/Auth/auth_provider.dart';
import 'package:aurora_jewelry/providers/Auth/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

  final TextEditingController _registrationUsernameController =
      TextEditingController();
  final TextEditingController _registrationEmailController =
      TextEditingController();
  final TextEditingController _registrationNameController =
      TextEditingController();
  final TextEditingController _registrationLastNameController =
      TextEditingController();
  final TextEditingController _registrationPasswordController =
      TextEditingController();
  final TextEditingController _registrationConfirmPasswordController =
      TextEditingController();

  bool isRegistration = false;
  String? _emailErrorText;
  String? _confirmPasswordErrorMessage;

  ///When returned false the button opacity is set to 0.5
  ///When returnde true the button opacity is set to 1
  bool canUserBeLoggedIn() {
    final email = _loginEmailController.text.trim();
    final password = _loginPasswordController.text.trim();

    // Check if email or password is empty
    if (email.isEmpty || password.isEmpty) {
      return false; // If either is empty, return false
    }

    // Validate email format using regex
    if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(email)) {
      return false; // If email is not in valid format, return false
    }

    return true; // If both email and password are valid, return true
  }

  bool canUserBeRegistrated(BuildContext context) {
    String username = _registrationUsernameController.text.trim();
    String email = _registrationEmailController.text.trim();
    String name = _registrationNameController.text.trim();
    String lastName = _registrationLastNameController.text.trim();
    String password = _registrationPasswordController.text;
    String confirmPassword = _registrationConfirmPasswordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        name.isEmpty ||
        lastName.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return false;
    }

    if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(email)) {
      return false;
    }

    if (password.length < 6) {
      return false;
    }

    if (password != confirmPassword) {
      return false;
    }

    return true; // Everything is valid
  }

  void showCupertinoSnackBar({
    required BuildContext context,
    required String message,
    int durationMillis = 3000,
  }) {
    const animationDurationMillis = 200;
    final overlayEntry = OverlayEntry(
      builder:
          (context) => CupertinoSnackBar(
            message: message,
            animationDurationMillis: animationDurationMillis,
            waitDurationMillis: durationMillis,
          ),
    );
    Future.delayed(
      Duration(milliseconds: durationMillis + 2 * animationDurationMillis),
      overlayEntry.remove,
    );
    Overlay.of(context).insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            middle: Text("Aurora Jewlery"),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Padding(padding: EdgeInsets.only(top: 86)),
                Text(
                  "Hey👋",
                  style:
                      CupertinoTheme.of(
                        context,
                      ).textTheme.navLargeTitleTextStyle,
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: PageTransitionSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (
                      Widget child,
                      Animation<double> primaryAnimation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return SharedAxisTransition(
                        fillColor:
                            CupertinoTheme.of(context).scaffoldBackgroundColor,
                        animation: primaryAnimation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.vertical,
                        child: child,
                      );
                    },
                    child:
                        isRegistration
                            ? Column(
                              key: ValueKey("registration"),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  "Register Now!",
                                  style:
                                      CupertinoTheme.of(
                                        context,
                                      ).textTheme.navLargeTitleTextStyle,
                                ),
                                SizedBox(height: 32),
                                Row(
                                  children: [
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: Text(
                                        "I Am A Old User",
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isRegistration = false;
                                          _registrationUsernameController
                                              .clear();
                                          _registrationNameController.clear();
                                          _registrationLastNameController
                                              .clear();
                                          _registrationEmailController.clear();
                                          _registrationPasswordController
                                              .clear();
                                          _registrationConfirmPasswordController
                                              .clear();
                                        });
                                      },
                                    ),
                                    Text(
                                      " /  Create New",
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: CupertinoColors.systemGrey,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 32),
                                SizedBox(
                                  height: 50,
                                  child: CupertinoTextField(
                                    controller: _registrationUsernameController,
                                    placeholder: "Username",
                                    clearButtonMode:
                                        OverlayVisibilityMode.editing,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                        RegExp(r'\s'),
                                      ), // Disallow spaces
                                    ],
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.tertiarySystemFill,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                SizedBox(
                                  height: 50,
                                  child: CupertinoTextField(
                                    controller: _registrationNameController,
                                    placeholder: "Name",
                                    clearButtonMode:
                                        OverlayVisibilityMode.editing,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.tertiarySystemFill,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                SizedBox(
                                  height: 50,
                                  child: CupertinoTextField(
                                    controller: _registrationLastNameController,
                                    placeholder: "Last Name",
                                    clearButtonMode:
                                        OverlayVisibilityMode.editing,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.tertiarySystemFill,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                SizedBox(
                                  height: 50,
                                  child: CupertinoTextField(
                                    controller: _registrationEmailController,
                                    placeholder: "Email",
                                    clearButtonMode:
                                        OverlayVisibilityMode.editing,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value.isEmpty ||
                                            !RegExp(
                                              r"^[^@]+@[^@]+\.[^@]+",
                                            ).hasMatch(value)) {
                                          _emailErrorText =
                                              "Invalid email address!";
                                        } else {
                                          _emailErrorText = null;
                                        }
                                      });
                                    },
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.tertiarySystemFill,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                if (_emailErrorText != null &&
                                    _registrationEmailController
                                        .text
                                        .isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4,
                                      left: 8,
                                    ),
                                    child: Text(
                                      _emailErrorText!,
                                      style: TextStyle(
                                        color: CupertinoColors.systemRed,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 16),
                                SizedBox(
                                  height: 50,
                                  child: CupertinoTextField(
                                    controller: _registrationPasswordController,
                                    placeholder: "Password",
                                    clearButtonMode:
                                        OverlayVisibilityMode.editing,
                                    onChanged: (value) {
                                      setState(() {
                                        if (_registrationConfirmPasswordController
                                            .text
                                            .isNotEmpty) {
                                          if (_registrationConfirmPasswordController
                                                  .text !=
                                              value) {
                                            _confirmPasswordErrorMessage =
                                                "Confirm Password does not match with password!";
                                          } else {
                                            _confirmPasswordErrorMessage = null;
                                          }
                                        }
                                      });
                                    },
                                    obscureText: true,
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.tertiarySystemFill,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                SizedBox(
                                  height: 50,
                                  child: CupertinoTextField(
                                    controller:
                                        _registrationConfirmPasswordController,
                                    obscureText: true,
                                    placeholder: "Confirm Password",
                                    clearButtonMode:
                                        OverlayVisibilityMode.editing,
                                    enabled:
                                        _registrationPasswordController
                                            .text
                                            .isNotEmpty,
                                    onChanged: (value) {
                                      setState(() {
                                        if (_registrationPasswordController
                                            .text
                                            .isNotEmpty) {
                                          if (value !=
                                              _registrationPasswordController
                                                  .text) {
                                            _confirmPasswordErrorMessage =
                                                "Confirm Password does not match with password!";
                                          } else {
                                            _confirmPasswordErrorMessage = null;
                                          }
                                        }
                                      });
                                    },
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.tertiarySystemFill,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                if (_confirmPasswordErrorMessage != null &&
                                    _registrationConfirmPasswordController
                                        .text
                                        .isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4,
                                      left: 8,
                                    ),
                                    child: Text(
                                      _confirmPasswordErrorMessage!,
                                      style: TextStyle(
                                        color: CupertinoColors.systemRed,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 150),
                              ],
                            )
                            : Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Login Now!",
                                  style:
                                      CupertinoTheme.of(
                                        context,
                                      ).textTheme.navLargeTitleTextStyle,
                                ),
                                SizedBox(height: 32),
                                Row(
                                  children: [
                                    Text(
                                      "I Am A Old User /  ",
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: CupertinoColors.systemGrey,
                                      ),
                                    ),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: Text(
                                        "Create New",
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isRegistration = true;
                                          _loginEmailController.clear();
                                          _loginPasswordController.clear();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 32),
                                SizedBox(
                                  height: 50,
                                  child: CupertinoTextField(
                                    controller: _loginEmailController,
                                    placeholder: "Email",
                                    keyboardType: TextInputType.emailAddress,
                                    clearButtonMode:
                                        OverlayVisibilityMode.editing,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.tertiarySystemFill,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                SizedBox(
                                  height: 50,
                                  child: CupertinoTextField(
                                    controller: _loginPasswordController,
                                    clearButtonMode:
                                        OverlayVisibilityMode.editing,
                                    placeholder: "Password",
                                    obscureText: true,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.tertiarySystemFill,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Consumer2<AuthProvider, UserProvider>(
            builder:
                (context, authProvider, userProvider, child) => ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                        bottom: 60,
                        top: 8,
                        left: 16,
                        right: 16,
                      ),
                      child: AnimatedOpacity(
                        opacity:
                            canUserBeLoggedIn() || canUserBeRegistrated(context)
                                ? 1
                                : 0.5,
                        duration: Duration(milliseconds: 300),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 32,
                          child: CupertinoButton.filled(
                            borderRadius: BorderRadius.circular(8),
                            child:
                                authProvider.isLoading
                                    ? CupertinoActivityIndicator() // Show loader if loading
                                    : Text(
                                      isRegistration
                                          ? "Register now"
                                          : "Login now",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            onPressed: () async {
                              if (isRegistration == false &&
                                  _loginEmailController.text.isNotEmpty &&
                                  _loginPasswordController.text.isNotEmpty) {
                                try {
                                  await authProvider.login(
                                    _loginEmailController.text,
                                    _loginPasswordController.text,
                                  );

                                  //When user logins user data should be returned from
                                  //Shared preferences, because of that getCurrentUserIsCalled
                                  await userProvider.getCurrentUser();
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                } catch (e) {
                                  // Use Builder to get the correct context that includes ScaffoldMessenger
                                  showCupertinoSnackBar(
                                    // ignore: use_build_context_synchronously
                                    context: context,
                                    message: "Please check your credentials.",
                                  );
                                }
                              } else {
                                try {
                                  if (canUserBeRegistrated(context)) {
                                    await authProvider.registerAndLogin(
                                      _registrationNameController.text,
                                      _registrationLastNameController.text,
                                      _registrationEmailController.text,
                                      _registrationPasswordController.text,
                                      _registrationUsernameController.text,
                                    );
                                    //When user registers user data should be returned from
                                    //Shared preferences, because of that getCurrentUserIsCalled
                                    await userProvider.getCurrentUser();
                                    

                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context);
                                  }
                                } catch (e) {
                                  // Use Builder to get the correct context that includes ScaffoldMessenger
                                  showCupertinoSnackBar(
                                    // ignore: use_build_context_synchronously
                                    context: context,
                                    message:
                                        "There was error while registrating user.",
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          ),
        ),
      ],
    );
  }
}

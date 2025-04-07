import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isRegistration = false;

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
                                    placeholder: "Name",
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
                                    placeholder: "Last Name",
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
                                    placeholder: "Email",
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
                                    placeholder: "Password",
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
                                    obscureText: true,
                                    placeholder: "Confirm Password",
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.tertiarySystemFill,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
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
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 32),
                                SizedBox(
                                  height: 50,
                                  child: CupertinoTextField(
                                    placeholder: "Email",
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
                                    placeholder: "Password",
                                    obscureText: true,
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
          bottom: 60,
          child: AnimatedOpacity(
            opacity: isRegistration? 0.2:1,
            duration: Duration(milliseconds: 300),
            child: SizedBox(
              key: ValueKey("register-button"),
              width: MediaQuery.of(context).size.width - 32,
              child: CupertinoButton.filled(
                borderRadius: BorderRadius.circular(8),
                child:
                    isRegistration
                        ? Text(
                          "Register now",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )
                        : Text(
                          "Login now",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ],
    );
  }
}

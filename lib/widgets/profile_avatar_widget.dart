import 'package:aurora_jewelry/providers/Auth/auth_provider.dart';
import 'package:aurora_jewelry/screens/Authentication/login_screen.dart';
import 'package:aurora_jewelry/screens/Home/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProfileAvatarWidget extends StatelessWidget {
  const ProfileAvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder:
          (context, authProvider, child) => CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              if (authProvider.isUserAuthenticated) {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoSheetRoute<void>(
                    builder: (BuildContext context) => const ProfileScreen(),
                  ),
                );
              } else {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoSheetRoute<void>(
                    builder: (BuildContext context) => const LoginScreen(),
                  ),
                );
              }
            },
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: CupertinoColors.tertiarySystemFill,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(CupertinoIcons.person, size: 32),
            ),
          ),
    );
  }
}

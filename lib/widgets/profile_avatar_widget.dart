import 'package:flutter/cupertino.dart';

class ProfileAvatarWidget extends StatelessWidget {
  const ProfileAvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        // Navigator.of(context).push(
        //   CupertinoSheetRoute<void>(
        //     builder: (BuildContext context) => const ProfileScreen(),
        //   ),
        // );
      },
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          // color: CupertinoColors.activeBlue,
          borderRadius: BorderRadius.circular(50),
        ),
        child: FlutterLogo(),
      ),
    );
  }
}

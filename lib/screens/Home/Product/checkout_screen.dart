import 'package:flutter/cupertino.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar.large(
        previousPageTitle: "Back",
        largeTitle: Text("Checkout"),
      ),
      child: Container(),
    );
  }
}
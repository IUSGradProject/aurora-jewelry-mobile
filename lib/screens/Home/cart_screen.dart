import 'package:aurora_jewelry/widgets/profile_avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            alwaysShowMiddle: false,
            middle: Text("Cart"),
            enableBackgroundFilterBlur: false,
            largeTitle: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Cart"), ProfileAvatarWidget()],
              ),
            ),
          ),
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                LottieBuilder.asset(
                  "lib/assets/empty-cart-animation.json",
                  height: 200,
                ),
                SizedBox(height: 32,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    "Your cart is waiting to be filled with wonderful things!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 18),
                  ),
                ),
                Spacer(flex: 2,),
              ],
            ),
          ),
          // SliverToBoxAdapter(
          //   child: CartItemComponent(
          //     itemName: "Necklace",
          //     quantity: 2,
          //     price: 129.99,
          //     onFinishOrder: () {
          //       Navigator.of(context, rootNavigator: true).push(
          //         CupertinoSheetRoute<void>(
          //           builder:
          //               (BuildContext context) => const EnterAddressScreen(),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

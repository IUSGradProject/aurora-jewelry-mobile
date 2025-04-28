import 'package:aurora_jewelry/components/Cart/cart_item_component.dart';
import 'package:aurora_jewelry/providers/Cart/cart_provider.dart';
import 'package:aurora_jewelry/widgets/Cart/cart_items_widget.dart';
import 'package:aurora_jewelry/widgets/profile_avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule fetchCart after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.fetchCart(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder:
          (context, cartProvider, child) => CupertinoPageScaffold(
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

                cartProvider.cartItems.isEmpty
                    ? SliverFillRemaining(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          LottieBuilder.asset(
                            "lib/assets/empty-cart-animation.json",
                            height: 200,
                          ),
                          SizedBox(height: 32),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32.0,
                            ),
                            child: Text(
                              "Your cart is waiting to be filled with wonderful things!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: CupertinoColors.systemGrey,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Spacer(flex: 2),
                        ],
                      ),
                    )
                    : CartItemsWidget(cartItems: cartProvider.cartItems),
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
          ),
    );
  }
}

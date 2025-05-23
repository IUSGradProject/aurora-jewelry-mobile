import 'package:aurora_jewelry/providers/Cart/cart_provider.dart';
import 'package:aurora_jewelry/screens/Home/Product/invoice_screen.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      await cartProvider.fetchCart(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder:
          (context, cartProvider, child) => CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar.large(
              largeTitle: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Cart"), ProfileAvatarWidget()],
                ),
              ),
            ),
            child: Stack(
              children: [
                cartProvider.cartItems.isEmpty
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(flex: 2,),
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
                    )
                    : CartItemsWidget(cartItems: cartProvider.cartItems),
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: cartProvider.isBottomSheetOpened ? 80 : 0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: CupertinoTheme.of(context).barBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 16),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),

                            child:
                                cartProvider.isLoading
                                    ? Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        //color: CupertinoColors.activeGreen,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CupertinoActivityIndicator(
                                            color: CupertinoColors.activeBlue,
                                          ),
                                        ],
                                      ),
                                    )
                                    : AnimatedOpacity(
                                      duration: Duration(milliseconds: 300),
                                      opacity:
                                          cartProvider
                                                  .checkoutItemsIds
                                                  .isNotEmpty
                                              ? 1
                                              : 0.5,
                                      child: CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          if (cartProvider
                                              .checkoutItemsIds
                                              .isEmpty) {
                                            return;
                                          }
                                          Navigator.of(
                                            context,
                                            rootNavigator: true,
                                          ).push(
                                            CupertinoPageRoute<void>(
                                              builder:
                                                  (BuildContext context) =>
                                                      InvoiceScreen(
                                                        isBuyNowRoot: false,
                                                      ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: CupertinoColors.activeGreen,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                CupertinoIcons.cart,
                                                color: CupertinoColors.white,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Proceed to Checkout",
                                                style: TextStyle(
                                                  color: CupertinoColors.white,
                                                ),
                                              ),
                                              Text(
                                                " \$ ${cartProvider.calculateCheckoutItemsTotalPrice()}",
                                                style: TextStyle(
                                                  color: CupertinoColors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
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
    );
  }
}

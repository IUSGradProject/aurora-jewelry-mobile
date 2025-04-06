import 'package:animated_digit/animated_digit.dart';
import 'package:aurora_jewelry/providers/Cart/cart_provider.dart';
import 'package:aurora_jewelry/providers/Search/search_provider.dart';
import 'package:aurora_jewelry/screens/Home/Product/invoice_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  void animateProductToCart(
    BuildContext context,
    GlobalKey cartKey,
    String imagePath,
    Offset startPosition,
  ) {
    final overlay = Overlay.of(context);
    final cartRenderBox =
        cartKey.currentContext?.findRenderObject() as RenderBox?;

    if (cartRenderBox == null) {
      debugPrint(
        "Cart Icon Button Key is NULL! Make sure it's assigned in Navbar.",
      );
      return;
    }

    final cartPosition = cartRenderBox.localToGlobal(Offset.zero);

    final animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: Navigator.of(context),
    );

    final animation = Tween<Offset>(
      begin: startPosition,
      end: cartPosition,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Positioned(
              left: animation.value.dx,
              top: animation.value.dy,
              child: Opacity(
                opacity: 1 - animationController.value,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(imagePath, width: 60, height: 60),
                ),
              ),
            );
          },
        );
      },
    );

    overlay.insert(overlayEntry);
    animationController.forward().whenComplete(() {
      overlayEntry?.remove();
      animationController.dispose();

      // Update the cart provider after animation completes
      Provider.of<CartProvider>(context, listen: false).addToCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        //  backgroundColor: CupertinoColors.transparent,
        // enableBackgroundFilterBlur: false,
        // automaticBackgroundVisibility: false,
        previousPageTitle: "Search",
        // middle: Text("Gucci"),
      ),
      child: Consumer2<SearchProvider, CartProvider>(
        builder:
            (context, searchProvider, cartProvider, child) => Container(
              padding: EdgeInsets.only(top: 16),
              child: ListView(
                padding: EdgeInsets.only(bottom: 116, top: 100),
                children: [
                  SizedBox(
                    height: 400,
                    child: PageView(
                      controller: PageController(viewportFraction: 0.7),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage("lib/assets/necklace.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage("lib/assets/necklace.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),

                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Lancinc",
                        style:
                            CupertinoTheme.of(
                              context,
                            ).textTheme.navLargeTitleTextStyle,
                      ),
                    ),
                  ),
                  // SizedBox(height: 0),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 16, right: 16),
                  //   child: Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text(
                  //       "Gucci",
                  //       style: TextStyle(
                  //         color: CupertinoColors.systemGrey,
                  //         fontWeight: FontWeight.w700,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      "Description about this product, something long this is very nice text explaining what this product is really about. You will need to buy it. I really liked it!",
                      style: TextStyle(color: CupertinoColors.systemGrey),
                    ),
                  ),

                  SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          AnimatedDigitWidget(
                            value: searchProvider.currentProductPrice,
                            textStyle: CupertinoTheme.of(
                              context,
                            ).textTheme.dateTimePickerTextStyle.copyWith(
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.dark
                                      ? CupertinoColors.white
                                      : CupertinoColors.black,
                            ),
                          ),
                          Text(
                            " BAM",
                            style:
                                CupertinoTheme.of(
                                  context,
                                ).textTheme.dateTimePickerTextStyle,
                          ),
                        ],
                      ),
                      // child: Text(
                      //   "1050 BAM",
                      //   style:
                      //       CupertinoTheme.of(
                      //         context,
                      //       ).textTheme.dateTimePickerTextStyle,
                      // ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Quantity",
                              style: TextStyle(
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                            Text(
                              searchProvider.currentProductQuantity.toString(),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.dark
                                        ? CupertinoColors.white
                                        : CupertinoColors.black,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: CupertinoColors.secondarySystemFill,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Icon(
                                  CupertinoIcons.minus,
                                  color:
                                      searchProvider.currentProductQuantity == 1
                                          ? CupertinoColors.systemGrey
                                          : MediaQuery.of(
                                                context,
                                              ).platformBrightness ==
                                              Brightness.dark
                                          ? CupertinoColors.white
                                          : CupertinoColors.black,
                                ),
                                onPressed: () {
                                  searchProvider
                                      .decrementCurrentProductQuantity();
                                },
                              ),
                              Container(
                                height: 22,
                                width: 1,
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Icon(
                                  CupertinoIcons.plus,
                                  color:
                                      MediaQuery.of(
                                                context,
                                              ).platformBrightness ==
                                              Brightness.dark
                                          ? CupertinoColors.white
                                          : CupertinoColors.black,
                                ),
                                onPressed: () {
                                  searchProvider
                                      .incrementCurrentProductQuantity();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      children: [
                        CupertinoButton(
                          color: CupertinoColors.activeBlue,
                          borderRadius: BorderRadius.circular(8),
                          sizeStyle: CupertinoButtonSize.medium,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.cart_fill_badge_plus,
                                color: CupertinoColors.white,
                                size: 22,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Add to Cart",
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            // final renderBox =
                            //     context.findRenderObject() as RenderBox?;
                            // final position =
                            //     renderBox?.localToGlobal(Offset.zero) ??
                            //     Offset.zero;

                            final positon = Offset(
                              MediaQuery.of(context).size.width / 2,
                              MediaQuery.of(context).size.width / 0.6,
                            );

                            if (cartProvider.cartIconButtonKey.currentContext ==
                                null) {
                              return;
                            }
                            animateProductToCart(
                              context,
                              cartProvider
                                  .cartIconButtonKey, // ✅ Ensure this is assigned in navbar
                              "lib/assets/necklace.jpg",
                              positon,
                            );
                            HapticFeedback.mediumImpact();
                          },
                        ),
                        SizedBox(height: 8),
                        CupertinoButton(
                          color: CupertinoColors.activeGreen,
                          sizeStyle: CupertinoButtonSize.medium,
                          borderRadius: BorderRadius.circular(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.cart_fill,
                                color: CupertinoColors.white,
                                size: 22,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Buy Now",
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => InvoiceScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

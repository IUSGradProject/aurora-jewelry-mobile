import 'package:animated_digit/animated_digit.dart';
import 'package:aurora_jewelry/components/Products/shimmer_product_screen.dart';
import 'package:aurora_jewelry/components/cupertino_snack_bar.dart';
import 'package:aurora_jewelry/providers/Auth/auth_provider.dart';
import 'package:aurora_jewelry/providers/Cart/cart_provider.dart';
import 'package:aurora_jewelry/providers/Database/database_provider.dart';
import 'package:aurora_jewelry/providers/Search/search_provider.dart';
import 'package:aurora_jewelry/screens/Authentication/login_screen.dart';
import 'package:aurora_jewelry/screens/Home/Product/image_preview_screen.dart';
import 'package:aurora_jewelry/screens/Home/Product/invoice_screen.dart';
import 'package:aurora_jewelry/screens/Home/home_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    Provider.of<CartProvider>(
      context,
      listen: false,
    ).setIsAnimatingToCart(true);
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
                child: SizedBox(
                  height: 50,
                  width: 50,

                  child: CachedNetworkImage(
                    imageUrl:
                        Provider.of<DatabaseProvider>(
                          context,
                          listen: false,
                        ).detailedProduct!.image,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) =>
                            const Center(child: CupertinoActivityIndicator()),
                    errorWidget:
                        (context, url, error) =>
                            const Icon(CupertinoIcons.photo),
                    fadeInDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    overlay.insert(overlayEntry);
    animationController.forward().whenComplete(() async {
      overlayEntry?.remove();
      animationController.dispose();

      // Update the cart provider after animation completes
      await Provider.of<CartProvider>(context, listen: false).addProductToCart(
        Provider.of<DatabaseProvider>(
          context,
          listen: false,
        ).detailedProduct!.convertToProduct(),
        context,
        quantity:
            Provider.of<SearchProvider>(
              context,
              listen: false,
            ).currentProductQuantity,
      );
      Provider.of<CartProvider>(
        // ignore: use_build_context_synchronously
        context,
        listen: false,
      ).setIsAnimatingToCart(false);
    });
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
    return !Provider.of<DatabaseProvider>(
          context,
          listen: true,
        ).isDetailedProductFetched
        ? ShimmerProductScreen()
        : Consumer<DatabaseProvider>(
          builder:
              (context, databaseProvider, child) => CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  automaticallyImplyLeading: true,
                  trailing: Text(
                    "${databaseProvider.detailedProduct!.category.name}, ${databaseProvider.detailedProduct!.style.name}",
                    style: TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                child: Consumer2<SearchProvider, CartProvider>(
                  builder:
                      (
                        context,
                        searchProvider,
                        cartProvider,
                        child,
                      ) => Container(
                        padding: EdgeInsets.only(top: 16),
                        child: ListView(
                          padding: EdgeInsets.only(top: 100),
                          children: [
                            ///Single Image Product
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 0.0,
                                right: 0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).push(
                                    CupertinoDialogRoute(
                                      builder:
                                          (context) => ImagePreviewScreen(
                                            imageURL:
                                                databaseProvider
                                                    .detailedProduct!
                                                    .image,
                                          ),
                                      context: context,
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  child: SizedBox(
                                    height: 250,
                                    width: double.infinity,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          databaseProvider
                                              .detailedProduct!
                                              .image,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (context, url) => const Center(
                                            child: CupertinoActivityIndicator(),
                                          ),
                                      errorWidget:
                                          (context, url, error) =>
                                              const Icon(CupertinoIcons.photo),
                                      fadeInDuration: const Duration(
                                        milliseconds: 300,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),

                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  databaseProvider.detailedProduct!.name,
                                  style:
                                      CupertinoTheme.of(
                                        context,
                                      ).textTheme.navLargeTitleTextStyle,
                                ),
                              ),
                            ),
                            SizedBox(height: 0),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  databaseProvider.detailedProduct!.brand.name,
                                  style: TextStyle(
                                    color: CupertinoColors.systemGrey,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 8,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "\$ ",
                                          style:
                                              CupertinoTheme.of(context)
                                                  .textTheme
                                                  .dateTimePickerTextStyle,
                                        ),
                                        Text(
                                          searchProvider.currentProductPrice
                                              .round()
                                              .toString(),
                                          style:
                                              CupertinoTheme.of(context)
                                                  .textTheme
                                                  .dateTimePickerTextStyle,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          databaseProvider
                                              .detailedProduct!
                                              .available
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: CupertinoColors.systemGrey,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "Available",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: CupertinoColors.systemGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),
                              child: Text(
                                databaseProvider.detailedProduct!.description,
                                style: TextStyle(
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 4,
                              ),
                              child: Text(
                                "This item was sold ${databaseProvider.detailedProduct!.soldItems} times.",
                                style: TextStyle(
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                            ),
                            SizedBox(height: 32),

                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      "\$ ",
                                      style:
                                          CupertinoTheme.of(
                                            context,
                                          ).textTheme.dateTimePickerTextStyle,
                                    ),
                                    AnimatedDigitWidget(
                                      value:
                                          searchProvider.quantityProductPrice,
                                      textStyle: CupertinoTheme.of(context)
                                          .textTheme
                                          .dateTimePickerTextStyle
                                          .copyWith(
                                            color:
                                                MediaQuery.of(
                                                          context,
                                                        ).platformBrightness ==
                                                        Brightness.dark
                                                    ? CupertinoColors.white
                                                    : CupertinoColors.black,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Quantity",
                                        style: TextStyle(
                                          color: CupertinoColors.systemGrey,
                                        ),
                                      ),
                                      Text(
                                        searchProvider.currentProductQuantity
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              MediaQuery.of(
                                                        context,
                                                      ).platformBrightness ==
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
                                      color:
                                          CupertinoColors.secondarySystemFill,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          child: Icon(
                                            CupertinoIcons.minus,
                                            color:
                                                searchProvider
                                                            .currentProductQuantity ==
                                                        1
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
                                                searchProvider
                                                            .currentProductQuantity ==
                                                        databaseProvider
                                                            .detailedProduct!
                                                            .available
                                                    ? CupertinoColors.systemGrey
                                                    : MediaQuery.of(
                                                          context,
                                                        ).platformBrightness ==
                                                        Brightness.dark
                                                    ? CupertinoColors.white
                                                    : CupertinoColors.black,
                                          ),
                                          onPressed: () {
                                            if (searchProvider
                                                    .currentProductQuantity <
                                                databaseProvider
                                                    .detailedProduct!
                                                    .available) {
                                              searchProvider
                                                  .incrementCurrentProductQuantity();
                                            } else {
                                              // Use Builder to get the correct context that includes ScaffoldMessenger
                                              showCupertinoSnackBar(
                                                // ignore: use_build_context_synchronously
                                                context: context,
                                                message:
                                                    "No more items available.",
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 32,
                              ),
                              child: Column(
                                children: [
                                  CupertinoButton(
                                    // color: CupertinoColors.activeBlue,
                                    borderRadius: BorderRadius.circular(8),
                                    sizeStyle: CupertinoButtonSize.medium,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons.cart_fill_badge_plus,
                                          // color: CupertinoColors.white,
                                          size: 22,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Add to Cart",
                                          style: TextStyle(
                                            // color: CupertinoColors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 22,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      final isUserRegistered =
                                          Provider.of<AuthProvider>(
                                            context,
                                            listen: false,
                                          ).isUserAuthenticated;

                                      if (isUserRegistered) {
                                        final position = Offset(
                                          MediaQuery.of(context).size.width / 2,
                                          MediaQuery.of(context).size.width /
                                              0.6,
                                        );

                                        final cartKey =
                                            HomeScreen.cartIconKeyGlobal;
                                        final cartContext =
                                            cartKey?.currentContext;
                                        if (cartContext != null) {
                                          animateProductToCart(
                                            context,
                                            cartKey!,
                                            "lib/assets/necklace.jpg",
                                            position,
                                          );
                                        }

                                        HapticFeedback.mediumImpact();
                                      } else {
                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).push(
                                          CupertinoSheetRoute<void>(
                                            builder:
                                                (BuildContext context) =>
                                                    const LoginScreen(),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8),
                                  CupertinoButton(
                                    color: CupertinoColors.activeGreen,
                                    sizeStyle: CupertinoButtonSize.medium,
                                    borderRadius: BorderRadius.circular(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      final isUserRegistered =
                                          Provider.of<AuthProvider>(
                                            context,
                                            listen: false,
                                          ).isUserAuthenticated;

                                      if (isUserRegistered) {
                                        //Adding current product to invoice screen and automatically
                                        //converting it to [CartItemContractModel]
                                        cartProvider.addBuyNowItem(
                                          databaseProvider.detailedProduct!
                                              .convertToCartItem(
                                                Provider.of<SearchProvider>(
                                                  context,
                                                  listen: false,
                                                ).currentProductQuantity,
                                              ),
                                        );
                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).push(
                                          CupertinoPageRoute<void>(
                                            builder:
                                                (BuildContext context) =>
                                                    InvoiceScreen(
                                                      isBuyNowRoot: true,
                                                    ),
                                          ),
                                        );
                                      } else {
                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).push(
                                          CupertinoSheetRoute<void>(
                                            builder:
                                                (BuildContext context) =>
                                                    const LoginScreen(),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).padding.bottom + 32,
                            ),
                          ],
                        ),
                      ),
                ),
              ),
        );
  }
}

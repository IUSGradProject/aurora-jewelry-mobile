import 'package:aurora_jewelry/models/Products/product_model.dart';
import 'package:aurora_jewelry/providers/Auth/auth_provider.dart';
import 'package:aurora_jewelry/providers/Cart/cart_provider.dart';
import 'package:aurora_jewelry/providers/Database/database_provider.dart';
import 'package:aurora_jewelry/screens/Authentication/login_screen.dart';
import 'package:aurora_jewelry/screens/Home/Product/product_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ListProductComponent extends StatefulWidget {
  final Product product;
  const ListProductComponent({super.key, required this.product});

  @override
  State<ListProductComponent> createState() => _ListProductComponentState();
}

class _ListProductComponentState extends State<ListProductComponent>
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Stack(
        children: [
          CupertinoButton(
            pressedOpacity: 0.6,
            onPressed: () {
              Provider.of<DatabaseProvider>(
                context,
                listen: false,
              ).resetDetailedProduct(context);
              Provider.of<DatabaseProvider>(
                context,
                listen: false,
              ).fetchDetailedProduct(widget.product.productId, context);
              Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  builder: (BuildContext context) => ProductScreen(),
                ),
              );
            },
            padding: EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? CupertinoColors.secondarySystemFill
                        : CupertinoColors.white,

                border: Border.all(
                  color:
                      MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? CupertinoColors.transparent
                          : CupertinoColors.systemGrey5,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          height: 100,
                          width: 100,

                          child: CachedNetworkImage(
                            imageUrl: widget.product.image,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => const Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(CupertinoIcons.photo),
                            fadeInDuration: const Duration(milliseconds: 300),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 200,
                            child: Text(
                              widget.product.name,
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width -
                                200, // Adjust width dynamically
                            child: Text(
                              widget.product.description,
                              style: TextStyle(
                                color: CupertinoColors.systemGrey,
                                fontSize: 15,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${widget.product.price}",
                        style: CupertinoTheme.of(
                          context,
                        ).textTheme.textStyle.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(CupertinoIcons.chevron_right),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Consumer<CartProvider>(
              builder:
                  (context, cartProvider, child) => CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    // color: CupertinoColors.activeBlue,
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.cart_badge_plus, size: 32),
                      ],
                    ),
                    onPressed: () {
                      final isUserRegistered =
                          Provider.of<AuthProvider>(
                            context,
                            listen: false,
                          ).isUserAuthenticated;
                      if (isUserRegistered) {
                        final renderBox =
                            context.findRenderObject() as RenderBox?;
                        final position =
                            renderBox?.localToGlobal(Offset.zero) ??
                            Offset.zero;

                        if (cartProvider.cartIconButtonKey.currentContext ==
                            null) {
                          return;
                        }

                        animateProductToCart(
                          context,
                          cartProvider
                              .cartIconButtonKey, // ✅ Ensure this is assigned in navbar
                          "lib/assets/necklace.jpg",
                          position,
                        );
                        HapticFeedback.mediumImpact();
                      } else {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoSheetRoute<void>(
                            builder:
                                (BuildContext context) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

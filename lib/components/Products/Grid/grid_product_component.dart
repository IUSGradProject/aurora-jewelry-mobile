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

class GridProductComponent extends StatefulWidget {
  final Product product;
  const GridProductComponent({super.key, required this.product});

  @override
  State<GridProductComponent> createState() => _GridProductComponentState();
}

class _GridProductComponentState extends State<GridProductComponent>
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
    return Stack(
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
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color:
                      MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? CupertinoColors.tertiarySystemFill
                          : CupertinoColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.black.withValues(alpha: 0.16),
                      offset: Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Inside your widget
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 120,
                        width: double.infinity,
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

                    SizedBox(height: 8),
                    Text(
                      widget.product.name,
                      style: CupertinoTheme.of(
                        context,
                      ).textTheme.textStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),

                    SizedBox(height: 4),
                    Text(
                      widget.product.description,
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 14,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),

              Positioned(
                bottom: 16,
                left: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$ ${widget.product.price.round()}",
                      style: CupertinoTheme.of(context).textTheme.textStyle
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Consumer<CartProvider>(
            builder:
                (context, cartProvider, child) => CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
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
                          renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

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

                  child: Icon(CupertinoIcons.cart_badge_plus, size: 24),
                ),
          ),
        ),
      ],
    );
  }
}

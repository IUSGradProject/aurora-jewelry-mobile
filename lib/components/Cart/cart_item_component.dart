import 'package:aurora_jewelry/models/Cart/cart_item_contract_model.dart';
import 'package:aurora_jewelry/providers/Cart/cart_provider.dart';
import 'package:aurora_jewelry/screens/Home/Product/image_preview_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CartItemComponent extends StatelessWidget {
  final CartItemContractModel cartItem;

  const CartItemComponent({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder:
          (context, cartProvider, child) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Stack(
              children: [
                CupertinoButton(
                  pressedOpacity: 0.75,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (cartProvider.isItemInCheckout(cartItem)) {
                      cartProvider.removeCheckoutItem(cartItem);
                    } else {
                      cartProvider.addCheckoutItem(cartItem);
                    }
                    HapticFeedback.mediumImpact();
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color:
                          MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark
                              ? CupertinoColors.secondarySystemFill
                              : CupertinoColors.white,

                      border: Border.all(
                        color:
                            cartProvider.isItemInCheckout(cartItem)
                                ? CupertinoColors.activeGreen
                                : MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark
                                ? CupertinoColors.transparent
                                : CupertinoColors.systemGrey5,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cart Item Details
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).push(
                                    CupertinoDialogRoute(
                                      builder:
                                          (context) => ImagePreviewScreen(
                                            imageURL: cartItem.imageUrl,
                                          ),
                                      context: context,
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CachedNetworkImage(
                                    imageUrl: cartItem.imageUrl,
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
                            SizedBox(width: 8),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 24.0),
                                child: Text(
                                  cartItem.name,
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          "\$${cartItem.price.toStringAsFixed(2)}",
                          style: CupertinoTheme.of(
                            context,
                          ).textTheme.textStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}",
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text("x${cartItem.quantity}"),
                          ],
                        ),

                        SizedBox(height: 54),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 14,
                  right: 14,
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child:
                          cartProvider.isItemInCheckout(cartItem)
                              ? Icon(
                                CupertinoIcons.check_mark_circled_solid,
                                color: CupertinoColors.activeGreen,
                                size: 25,
                              )
                              : Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: CupertinoColors.activeBlue,
                                    width: 1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  child: Container(
                    height: 30,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    width: MediaQuery.of(context).size.width - 32,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          onPressed: () {
                            cartProvider.removeFromCart(
                              context,
                              cartItem.productId,
                            );
                          },
                          child: Container(
                            height: 30,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                "Remove",
                                style: CupertinoTheme.of(
                                  context,
                                ).textTheme.textStyle.copyWith(
                                  fontSize: 15,
                                  color: CupertinoColors.systemRed,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
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
                                      MediaQuery.of(
                                                context,
                                              ).platformBrightness ==
                                              Brightness.dark
                                          ? CupertinoColors.white
                                          : CupertinoColors.black,
                                ),
                                onPressed: () {},
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
                                  // color:
                                  //     searchProvider.currentProductQuantity ==
                                  //             databaseProvider
                                  //                 .detailedProduct!
                                  //                 .available
                                  //         ? CupertinoColors.systemGrey
                                  //         : MediaQuery.of(
                                  //               context,
                                  //             ).platformBrightness ==
                                  //             Brightness.dark
                                  //         ? CupertinoColors.white
                                  //         : CupertinoColors.black,
                                ),
                                onPressed: () {
                                  // if (searchProvider.currentProductQuantity <
                                  //     databaseProvider
                                  //         .detailedProduct!
                                  //         .available) {
                                  //   searchProvider
                                  //       .incrementCurrentProductQuantity();
                                  // } else {
                                  //   // Use Builder to get the correct context that includes ScaffoldMessenger
                                  //   // showCupertinoSnackBar(
                                  //   //   // ignore: use_build_context_synchronously
                                  //   //   context: context,
                                  //   //   message: "No more items available.",
                                  //   // );
                                  // }
                                },
                              ),
                            ],
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

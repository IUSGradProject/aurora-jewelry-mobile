import 'dart:ui';

import 'package:aurora_jewelry/components/Cart/delivery_address_invoice_component.dart';
import 'package:aurora_jewelry/components/Cart/delivery_address_shared_prefs_component.dart';
import 'package:aurora_jewelry/providers/Auth/user_provider.dart';
import 'package:aurora_jewelry/providers/Cart/cart_provider.dart';
import 'package:aurora_jewelry/providers/Home/navigation_bar_provider.dart';
import 'package:aurora_jewelry/screens/Home/Product/enter_delivery_address_screen.dart';
import 'package:aurora_jewelry/screens/Home/home_screen.dart';
import 'package:aurora_jewelry/screens/Home/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvoiceScreen extends StatefulWidget {
  final bool isBuyNowRoot;
  const InvoiceScreen({super.key, required this.isBuyNowRoot});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await Provider.of<UserProvider>(
        // ignore: use_build_context_synchronously
        context,
        listen: false,
      ).checkIfDeliveryAddressIsSavedToSharedPrefs();

      bool isDeliveryAddressSet =
          Provider.of<UserProvider>(
            // ignore: use_build_context_synchronously
            context,
            listen: false,
          ).isDeliveryAddressSet;

      if (isDeliveryAddressSet) {
        await Provider.of<UserProvider>(
          // ignore: use_build_context_synchronously
          context,
          listen: false,
        ).getUserDeliveryAddressFromSharedPrefs();
      }
    });
  }

  void navigateToHomeAndShowConfirmation(BuildContext context) async {
    // ignore: use_build_context_synchronously

    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    //this is to show to user Discover Screen
    NavigationBarProvider navigationBarProvider =
        Provider.of<NavigationBarProvider>(context, listen: false);
    navigationBarProvider.setCurrentIndex(0);

    // Push HomeScreen and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (_) => HomeScreen()),
      (Route<dynamic> route) => false, // Remove all previous routes
    );

    showCupertinoModalPopup(
      // ignore: use_build_context_synchronously
      context: context,
      builder:
          (context) => Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: CupertinoColors.activeGreen,
                    size: 45,
                  ),
                  SizedBox(height: 32),
                  Text(
                    "Thank you ${userProvider.currentUser!.firstName} for ordering from Aurora Jewelry !",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Text(
                      "You can see you current and previous orders inside of your Profile.",
                      style: CupertinoTheme.of(
                        context,
                      ).textTheme.navTitleTextStyle.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: CupertinoColors.systemGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),
                  CupertinoButton(
                    child: Text("Open Orders"),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        CupertinoSheetRoute<void>(
                          builder:
                              (BuildContext context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CartProvider, UserProvider>(
      builder:
          (context, cartProvider, userProvider, child) => Stack(
            alignment: Alignment.center,
            children: [
              CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  padding: EdgeInsetsDirectional.zero,
                  middle: Text("Invoice"),

                  leading: CupertinoNavigationBarBackButton(
                    previousPageTitle: "Back",
                    onPressed: () async {
                      if (widget.isBuyNowRoot) {
                        cartProvider.resetInvoiceScreen();

                        Navigator.of(context).pop();
                        await cartProvider.fetchCart(context);
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.only(bottom: 60, top: 100),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16,
                        top: 16,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: CupertinoColors.systemGrey.withOpacity(0.2),
                          ),
                          color:
                              MediaQuery.of(context).platformBrightness ==
                                      Brightness.dark
                                  ? CupertinoColors.secondarySystemFill
                                  : CupertinoColors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow:
                              MediaQuery.of(context).platformBrightness ==
                                      Brightness.dark
                                  ? []
                                  : [
                                    BoxShadow(
                                      color: CupertinoColors.systemGrey
                                          .withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                        ),
                        child: Column(
                          // padding: const EdgeInsets.all(16),
                          children: [
                            // Section Header
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Order Summary",
                                    style: CupertinoTheme.of(
                                      context,
                                    ).textTheme.navLargeTitleTextStyle.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.receipt_long_outlined,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Product List
                            ...cartProvider.invoiceItems.map(
                              (item) => Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      MediaQuery.of(
                                                context,
                                              ).platformBrightness ==
                                              Brightness.dark
                                          ? CupertinoColors.secondarySystemFill
                                          : CupertinoColors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow:
                                      MediaQuery.of(
                                                context,
                                              ).platformBrightness ==
                                              Brightness.dark
                                          ? []
                                          : [
                                            BoxShadow(
                                              color: CupertinoColors.systemGrey
                                                  .withOpacity(0.2),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                ),
                                child: Row(
                                  children: [
                                    // Product Name and Quantity
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: CupertinoTheme.of(
                                              context,
                                            ).textTheme.textStyle.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "x${item.quantity}",
                                            style: TextStyle(
                                              color: CupertinoColors.systemGrey,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Price
                                    Text(
                                      "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                                      style: CupertinoTheme.of(
                                        context,
                                      ).textTheme.textStyle.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const Divider(height: 32, thickness: 0.5),

                            // Total Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total",
                                  style: CupertinoTheme.of(
                                    context,
                                  ).textTheme.textStyle.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "\$${cartProvider.calculateCheckoutItemsTotalPrice().toStringAsFixed(2)}",
                                  style: CupertinoTheme.of(
                                    context,
                                  ).textTheme.textStyle.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Payment Method",
                              style: CupertinoTheme.of(
                                context,
                              ).textTheme.navLargeTitleTextStyle.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.only(
                              left: 8,
                              right: 8,
                              top: 8,
                              bottom: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.dark
                                      ? CupertinoColors.secondarySystemFill
                                      : CupertinoColors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.dark
                                      ? []
                                      : [
                                        BoxShadow(
                                          color: CupertinoColors.systemGrey
                                              .withOpacity(0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Pay on Delivery"),

                                    Icon(
                                      CupertinoIcons.check_mark_circled_solid,
                                      color: CupertinoColors.activeGreen,
                                    ),
                                  ],
                                ),
                                Divider(height: 16, thickness: 0.5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Credit Card",
                                      style: TextStyle(
                                        color: CupertinoColors.systemGrey,
                                      ),
                                    ),

                                    Row(
                                      children: [
                                        Text(
                                          "Not Available",
                                          style: TextStyle(
                                            color: CupertinoColors.systemGrey,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          CupertinoIcons.circle,
                                          color: CupertinoColors.systemGrey,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Delivery Address",
                              style: CupertinoTheme.of(
                                context,
                              ).textTheme.navLargeTitleTextStyle.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          // Checking if the user has a delivery address set to shared prefs
                          // If not, show the static delivery address (set/or edit).
                          !userProvider.isDeliveryAddressSet
                              ? !cartProvider.isDeliveryAddressSet
                                  ? CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        CupertinoSheetRoute(
                                          builder:
                                              (BuildContext context) =>
                                                  const EnterDeliveryAddressScreen(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 40,
                                      padding: EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            MediaQuery.of(
                                                      context,
                                                    ).platformBrightness ==
                                                    Brightness.dark
                                                ? CupertinoColors
                                                    .secondarySystemFill
                                                : CupertinoColors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow:
                                            MediaQuery.of(
                                                      context,
                                                    ).platformBrightness ==
                                                    Brightness.dark
                                                ? []
                                                : [
                                                  BoxShadow(
                                                    color: CupertinoColors
                                                        .systemGrey
                                                        .withOpacity(0.2),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Add Delivery Address"),
                                          Icon(CupertinoIcons.add_circled),
                                        ],
                                      ),
                                    ),
                                  )
                                  : DeliveryAddressInvoiceComponent(
                                    deliveryAddress:
                                        cartProvider.deliveryAddress,
                                  )
                              : DeliveryAddressSharedPrefsComponent(
                                deliveryAddress:
                                    userProvider.userDeliveryAddress,
                              ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    // Next Button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AnimatedOpacity(
                        opacity:
                            userProvider.isDeliveryAddressSet
                                ? 1
                                : cartProvider.isDeliveryAddressSet
                                ? 1
                                : 0.5,
                        duration: const Duration(milliseconds: 300),
                        child: SizedBox(
                          width: double.infinity,
                          child: CupertinoButton.filled(
                            borderRadius: BorderRadius.circular(12),
                            child: const Text(
                              "Place Order",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.white,
                              ),
                            ),
                            onPressed: () async {
                              if (cartProvider.isDeliveryAddressSet ||
                                  userProvider.isDeliveryAddressSet) {
                                ///This line below is important
                                await cartProvider.placeOrder(context);

                                if (cartProvider.isOrderPlacedSuccesfully) {
                                  // ignore: use_build_context_synchronously
                                  await cartProvider.fetchCart(context);
                                  // ignore: use_build_context_synchronously
                                  navigateToHomeAndShowConfirmation(context);
                                } else {
                                  // Show error message
                                  showCupertinoDialog(
                                    // ignore: use_build_context_synchronously
                                    context: context,
                                    builder:
                                        (context) => CupertinoAlertDialog(
                                          title: const Text("Error"),
                                          content: const Text(
                                            "Failed to place order. Please try again.",
                                          ),
                                          actions: [
                                            CupertinoDialogAction(
                                              child: const Text("OK"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              IgnorePointer(
                child: AnimatedOpacity(
                  opacity: cartProvider.isOrderPlacing ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Stack(
                      children: [
                        Container(
                          height: 160,
                          width: 250,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: CupertinoColors.activeBlue.withValues(
                              alpha: 0.9,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Your order is processing...",
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Text(
                            "Aurora Jewelery",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Georgia',
                              color: CupertinoColors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: CupertinoActivityIndicator(
                            color: CupertinoColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}

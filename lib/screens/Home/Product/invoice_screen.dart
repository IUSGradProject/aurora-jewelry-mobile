import 'package:aurora_jewelry/components/Cart/delivery_address_invoice_component.dart';
import 'package:aurora_jewelry/providers/Cart/cart_provider.dart';
import 'package:aurora_jewelry/screens/Home/Product/enter_delivery_address_screen.dart';
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
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder:
          (context, cartProvider, child) => CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              padding: EdgeInsetsDirectional.zero,
              middle: Text("Invoice"),

              leading: CupertinoNavigationBarBackButton(
                previousPageTitle: "Back",
                onPressed: () {
                  if (widget.isBuyNowRoot) {
                    cartProvider.resetInvoiceScreen();
                    Navigator.of(context).pop();
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
                                  color: CupertinoColors.systemGrey.withOpacity(
                                    0.2,
                                  ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      !cartProvider.isDeliveryAddressSet
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
                              padding: EdgeInsets.only(left: 8, right: 8),
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
                            deliveryAddress: cartProvider.deliveryAddress,
                          ),
                    ],
                  ),
                ),
                SizedBox(height: 70),
                // Next Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AnimatedOpacity(
                    opacity: cartProvider.isDeliveryAddressSet ? 1 : 0.5,
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
                          if (cartProvider.isDeliveryAddressSet) {
                            await cartProvider.placeOrder(context);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

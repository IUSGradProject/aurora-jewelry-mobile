import 'package:aurora_jewelry/screens/Home/Product/enter_address_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InvoiceItem {
  final String name;
  final int quantity;
  final double price;

  InvoiceItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  double get total => quantity * price;
}

class InvoiceScreen extends StatelessWidget {
  InvoiceScreen({super.key});

  final List<InvoiceItem> invoiceItems = [
    InvoiceItem(name: "Lancin", quantity: 2, price: 525),
    // InvoiceItem(name: "Aurix", quantity: 1, price: 790),
    // InvoiceItem(name: "Zeline", quantity: 3, price: 800),
  ];

  @override
  Widget build(BuildContext context) {
    final totalAmount = invoiceItems.fold<double>(
      0,
      (sum, item) => sum + item.total,
    );

    return CupertinoPageScaffold(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text("Invoice"),
                previousPageTitle: "Back",
                stretch: true,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.tertiarySystemFill,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Text(
                          "Product Details",
                          style: CupertinoTheme.of(
                            context,
                          ).textTheme.navTitleTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Product List
                        ...invoiceItems.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Product Name
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: CupertinoTheme.of(
                                      context,
                                    ).textTheme.textStyle.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                // Quantity
                                Text(
                                  "x${item.quantity}",
                                  style: TextStyle(
                                    color: CupertinoColors.systemGrey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Price
                                Text(
                                  "${item.total.toStringAsFixed(2)} BAM",
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Divider(height: 32),

                        // Total Row
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
                              "${totalAmount.toStringAsFixed(2)} BAM",
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
              ),
            ],
          ),

          Positioned(
            bottom: 60,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(12),
                color: CupertinoColors.systemBlue,
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoSheetRoute<void>(
                      builder:
                          (BuildContext context) => const EnterAddressScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:aurora_jewelry/models/Products/product_order_model.dart';
import 'package:aurora_jewelry/screens/Home/Product/image_preview_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PreviousOrderMultipleProductsComponent extends StatelessWidget {
  final List<ProductOrder> items;

  const PreviousOrderMultipleProductsComponent({
    super.key,

    required this.items,
  });

  double get total =>
      items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? CupertinoColors.secondarySystemFill
                : CupertinoColors.white,
        border: Border.all(
          color:
              MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? CupertinoColors.transparent
                  : CupertinoColors.systemGrey5,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('d MMM yyyy \'at\' HH:mm').format(items[0].date),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: CupertinoColors.systemGrey,
            ),
          ),
          SizedBox(height: 16),

          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(items.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoDialogRoute(
                            builder:
                                (context) => ImagePreviewScreen(
                                  imageURL: items[index].imageURL,
                                ),
                            context: context,
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.dark
                                        ? CupertinoColors.systemGrey
                                        : CupertinoColors.systemGrey5,
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                height: 80,
                                width: 80,
                                child: CachedNetworkImage(
                                  imageUrl: items[index].imageURL,
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
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.dark
                                      ? Colors.grey[300]
                                      : CupertinoColors.white,
                              border: Border.all(
                                color:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.dark
                                        ? CupertinoColors.systemGrey
                                        : CupertinoColors.systemGrey5,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 16),

          // List of Products
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${index + 1}.   ${item.name} x${item.quantity}",
                    ),
                  ),
                  Text(
                    "${(item.price * item.quantity).toStringAsFixed(2)} BAM",
                  ),
                ],
              ),
            );
          }),

          Divider(height: 24),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                "${total.toStringAsFixed(2)} BAM",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

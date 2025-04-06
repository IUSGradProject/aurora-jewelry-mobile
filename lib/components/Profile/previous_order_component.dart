import 'package:aurora_jewelry/models/Products/product_order_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviousOrderComponent extends StatelessWidget {
  final String date;
  final String time;
  final List<ProductOrder> items;
  final double total;

  const PreviousOrderComponent({
    super.key,
    required this.date,
    required this.time,
    required this.items,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemFill,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Date and Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(time, style: TextStyle(color: CupertinoColors.systemGrey)),
            ],
          ),
          SizedBox(height: 12),

          // Item List
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text("${item.name} x${item.quantity}")),
                  Text("${(item.price * item.quantity).toStringAsFixed(2)} BAM"),
                ],
              ),
            ),
          ),

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

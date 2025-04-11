import 'package:flutter/cupertino.dart';

class CartItemComponent extends StatelessWidget {
  final String itemName;
  final int quantity;
  final double price;
  final VoidCallback onFinishOrder;

  const CartItemComponent({
    super.key,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.onFinishOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemFill,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cart Item Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(itemName, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Text("x$quantity"),
            ],
          ),
          SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Price: \$${price.toStringAsFixed(2)}"),
              Text("Total: \$${(price * quantity).toStringAsFixed(2)}"),
            ],
          ),
          SizedBox(height: 16),

          // Action Button to Finish the Order
          CupertinoButton.filled(
            onPressed: onFinishOrder,
            child: Text("Finish Order"),
          ),
        ],
      ),
    );
  }
}

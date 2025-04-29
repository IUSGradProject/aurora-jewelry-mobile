import 'package:aurora_jewelry/models/Cart/delivery_address_model.dart';
import 'package:aurora_jewelry/providers/Cart/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DeliveryAddressInvoiceComponent extends StatelessWidget {
  final DeliveryAddressModel deliveryAddress;
  const DeliveryAddressInvoiceComponent({
    super.key,
    required this.deliveryAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? CupertinoColors.secondarySystemFill
                    : CupertinoColors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow:
                MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? []
                    : [
                      BoxShadow(
                        color: CupertinoColors.systemGrey.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              Text(
                deliveryAddress.fullName,
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Address Line 1
              Text(
                deliveryAddress.address,
                style: CupertinoTheme.of(
                  context,
                ).textTheme.textStyle.copyWith(fontSize: 16),
              ),

              const SizedBox(height: 8),

              // City, State, and Zip Code
              Text(
                "${deliveryAddress.city}, ${deliveryAddress.postalCode} ",
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontSize: 16,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: CupertinoButton(
            minimumSize: const Size(0, 0),
            padding: EdgeInsets.zero,
            onPressed: () {
              Provider.of<CartProvider>(
                context,
                listen: false,
              ).clearDeliveryAddress();
            },
            child: Icon(
              CupertinoIcons.xmark_circle_fill,
              color: CupertinoColors.destructiveRed,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}

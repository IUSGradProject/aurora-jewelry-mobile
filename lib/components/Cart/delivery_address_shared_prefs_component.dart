import 'package:aurora_jewelry/models/Cart/delivery_address_model.dart';
import 'package:aurora_jewelry/screens/Home/Product/enter_delivery_address_screen.dart';
import 'package:flutter/cupertino.dart';

class DeliveryAddressSharedPrefsComponent extends StatelessWidget {
  final DeliveryAddressModel deliveryAddress;
  const DeliveryAddressSharedPrefsComponent({
    super.key,
    required this.deliveryAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Saved Delivery Address",
                style: TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 15,
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text("Edit "),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoSheetRoute(
                      builder:
                          (BuildContext context) =>
                              const EnterDeliveryAddressScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 8),
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
    );
  }
}

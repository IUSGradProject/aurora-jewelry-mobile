import 'package:aurora_jewelry/components/Cart/cart_item_component.dart';
import 'package:aurora_jewelry/screens/Home/Product/enter_address_screen.dart';
import 'package:aurora_jewelry/widgets/profile_avatar_widget.dart';
import 'package:flutter/cupertino.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            alwaysShowMiddle: false,
            middle: Text("Cart"),
            enableBackgroundFilterBlur: false,
            largeTitle: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Cart"), ProfileAvatarWidget()],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: CartItemComponent(
              itemName: "Necklace",
              quantity: 2,
              price: 129.99,
              onFinishOrder: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoSheetRoute<void>(
                    builder:
                        (BuildContext context) => const EnterAddressScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

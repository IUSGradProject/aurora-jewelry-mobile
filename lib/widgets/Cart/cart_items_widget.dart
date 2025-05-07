import 'package:aurora_jewelry/components/Cart/cart_item_component.dart';
import 'package:aurora_jewelry/models/Cart/cart_item_contract_model.dart';
import 'package:flutter/cupertino.dart';

class CartItemsWidget extends StatelessWidget {
  final List<CartItemContractModel> cartItems;
  const CartItemsWidget({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        padding: EdgeInsets.only(top: 150, bottom: 160),
        children: List.generate(cartItems.length, (index) {
          return CartItemComponent(cartItem: cartItems[index]);
        }),
      ),
    );
  }
}

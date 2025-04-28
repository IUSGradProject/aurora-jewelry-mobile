import 'package:aurora_jewelry/components/Cart/cart_item_component.dart';
import 'package:aurora_jewelry/models/Cart/cart_item_contract_model.dart';
import 'package:flutter/cupertino.dart';

class CartItemsWidget extends StatelessWidget {
  final List<CartItemContractModel> cartItems;
  const CartItemsWidget({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              Column(
                children: List.generate(cartItems.length, (index) {
                  return CartItemComponent(cartItem: cartItems[index]);
                }),
              ),
              SizedBox(height: 160,)
            ],
          ),
        ),
      ),
    );
  }
}

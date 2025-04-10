import 'package:aurora_jewelry/components/Profile/previous_order_component.dart';
import 'package:aurora_jewelry/models/Products/product_order_model.dart';
import 'package:aurora_jewelry/providers/Auth/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Profile")),
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 16, right: 16),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                child: Icon(CupertinoIcons.person, size: 50),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Mirza",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
            ),
            Consumer<AuthProvider>(
              builder:
                  (context, authProvider, child) => CupertinoButton(
                    child: Text("Sign Out"),
                    onPressed: () {
                      authProvider.logout();
                      Navigator.pop(context);
                    },
                  ),
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Previous Orders 📦", style: TextStyle(fontSize: 17)),
            ),
            PreviousOrderComponent(
              date: "12 Dec 2024",
              time: "14:30",
              items: [
                ProductOrder(name: "Necklace", quantity: 1, price: 129.99),
                ProductOrder(name: "Earrings", quantity: 2, price: 39.99),
              ],
              total: 209.97,
            ),
            PreviousOrderComponent(
              date: "11 Dec 2024",
              time: "14:30",
              items: [
                ProductOrder(
                  name: "Necklace With Safire",
                  quantity: 1,
                  price: 129.99,
                ),
                ProductOrder(name: "Earrings", quantity: 2, price: 39.99),
              ],
              total: 209.97,
            ),
          ],
        ),
      ),
    );
  }
}

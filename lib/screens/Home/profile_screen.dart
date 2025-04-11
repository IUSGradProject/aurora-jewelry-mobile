import 'package:aurora_jewelry/components/Profile/previous_order_component.dart';
import 'package:aurora_jewelry/models/Products/product_order_model.dart';
import 'package:aurora_jewelry/providers/Auth/auth_provider.dart';
import 'package:aurora_jewelry/providers/Auth/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Profile")),
      child: Consumer2<AuthProvider, UserProvider>(
        builder:
            (context, authProvider, userProvider, child) => Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 16, right: 16),
              child: Column(
                children: [
                  PullDownButton(
                    buttonAnchor: PullDownMenuAnchor.end,
                    menuOffset: -16,
                    itemBuilder: (context) {
                      return [
                        PullDownMenuItem(
                          onTap: () async {
                            await authProvider.logout();
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          },
                          title: "Logout",
                        ),
                        PullDownMenuItem(
                          isDestructive: true,
                          onTap: () {},
                          title: "Delete Account",
                        ),
                      ];
                    },
                    buttonBuilder: (context, showMenu) {
                      return CupertinoButton(
                        onPressed: showMenu,
                        padding: EdgeInsets.zero,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    child: Icon(
                                      CupertinoIcons.person,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            userProvider.currentUser!.firstName,
                                            style: CupertinoTheme.of(
                                              context,
                                            ).textTheme.textStyle.copyWith(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                         " ${userProvider.currentUser!.lastName}",
                                            style: CupertinoTheme.of(
                                              context,
                                            ).textTheme.textStyle.copyWith(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        userProvider.currentUser!.email,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: CupertinoColors.systemGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.tertiarySystemFill,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(Icons.more_horiz),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 8),

                  // Consumer<AuthProvider>(
                  //   builder:
                  //       (context, authProvider, child) => CupertinoButton(
                  //         child: Text("Sign Out"),
                  //         onPressed: () {
                  //           authProvider.logout();
                  //           Navigator.pop(context);
                  //         },
                  //       ),
                  // ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Orders 📦", style: TextStyle(fontSize: 24)),
                  ),
                  SizedBox(height: 120),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      "Your sparkle orders will shine here once you make one ✨.",
                      style: TextStyle(color: CupertinoColors.systemGrey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // PreviousOrderComponent(
                  //   date: "12 Dec 2024",
                  //   time: "14:30",
                  //   items: [
                  //     ProductOrder(
                  //       name: "Necklace",
                  //       quantity: 1,
                  //       price: 129.99,
                  //     ),
                  //     ProductOrder(name: "Earrings", quantity: 2, price: 39.99),
                  //   ],
                  //   total: 209.97,
                  // ),
                  // PreviousOrderComponent(
                  //   date: "11 Dec 2024",
                  //   time: "14:30",
                  //   items: [
                  //     ProductOrder(
                  //       name: "Necklace With Safire",
                  //       quantity: 1,
                  //       price: 129.99,
                  //     ),
                  //     ProductOrder(name: "Earrings", quantity: 2, price: 39.99),
                  //   ],
                  //   total: 209.97,
                  // ),
                ],
              ),
            ),
      ),
    );
  }
}

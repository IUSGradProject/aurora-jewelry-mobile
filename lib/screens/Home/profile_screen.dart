import 'package:aurora_jewelry/components/Profile/previous_order_component.dart';
import 'package:aurora_jewelry/models/Products/product_order_model.dart';
import 'package:aurora_jewelry/providers/Auth/auth_provider.dart';
import 'package:aurora_jewelry/providers/Auth/user_provider.dart';
import 'package:aurora_jewelry/providers/Database/database_provider.dart';
import 'package:aurora_jewelry/screens/Home/Product/enter_delivery_address_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final databaseProvider = Provider.of<DatabaseProvider>(
        context,
        listen: false,
      );

      databaseProvider.fetchPreviousUserOrders(
        userProvider.currentUser!.authToken!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        padding: EdgeInsetsDirectional.only(end: 8, top: 8),
        middle: Text("Profile"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: Icon(CupertinoIcons.xmark_circle_fill, size: 32),
          ),
        ),
      ),
      child: Consumer3<AuthProvider, UserProvider, DatabaseProvider>(
        builder:
            (
              context,
              authProvider,
              userProvider,
              databaseProvider,
              child,
            ) => Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 16, right: 16),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  PullDownButton(
                    buttonAnchor: PullDownMenuAnchor.end,
                    menuOffset: -16,
                    itemBuilder: (context) {
                      return [
                        PullDownMenuItem(
                          icon: CupertinoIcons.cube_box,
                          onTap: () async {
                            Navigator.of(context).push(
                              CupertinoSheetRoute(
                                builder:
                                    (BuildContext context) =>
                                        const EnterDeliveryAddressScreen(),
                              ),
                            );
                          },
                          title: "Delivery Address",
                        ),
                        PullDownMenuDivider.large(),
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
                          onTap: () {
                            showCupertinoModalPopup<void>(
                              context: context,
                              builder:
                                  (
                                    BuildContext context,
                                  ) => CupertinoActionSheet(
                                    title: const Text(
                                      'Are you sure you want to deactivate your Account?',
                                    ),
                                    message: const Text(
                                      "After deactivating it there is no comming back! Your history of orders will vanish.",
                                    ),
                                    actions: <CupertinoActionSheetAction>[
                                      CupertinoActionSheetAction(
                                        isDestructiveAction: true,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Deactivate Account'),
                                      ),
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                      isDestructiveAction: true,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: CupertinoColors.activeBlue,
                                        ),
                                      ),
                                    ),
                                  ),
                            );
                          },
                          title: "Deactivate Account",
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
                                    radius: 35,
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
                                      Text(
                                        userProvider.currentUser!.username,
                                        style: CupertinoTheme.of(
                                          context,
                                        ).textTheme.textStyle.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            userProvider.currentUser!.firstName,
                                            style: CupertinoTheme.of(
                                              context,
                                            ).textTheme.textStyle.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: CupertinoColors.systemGrey,
                                            ),
                                          ),
                                          Text(
                                            " ${userProvider.currentUser!.lastName}",
                                            style: CupertinoTheme.of(
                                              context,
                                            ).textTheme.textStyle.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: CupertinoColors.systemGrey,
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
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child:
                        databaseProvider.isUserOrdersFetched
                            ? (databaseProvider.previousUserOrders.isEmpty
                                ? Column(
                                  children: [
                                    SizedBox(height: 120),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32.0,
                                      ),
                                      child: Text(
                                        "Your sparkle orders will shine here once you make one ✨.",
                                        style: TextStyle(
                                          color: CupertinoColors.systemGrey,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                )
                                : ListView.builder(
                                  padding: EdgeInsets.only(bottom: 60),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                      databaseProvider
                                          .previousUserOrders
                                          .length,
                                  itemBuilder: (context, index) {
                                    return PreviousOrderComponent(
                                      imageUrl:
                                          databaseProvider
                                              .previousUserOrders[index]
                                              .productImage,
                                      date:
                                          databaseProvider
                                              .previousUserOrders[index]
                                              .orderDate,

                                      items: [
                                        ProductOrder(
                                          name:
                                              databaseProvider
                                                  .previousUserOrders[index]
                                                  .productName,
                                          quantity:
                                              databaseProvider
                                                  .previousUserOrders[index]
                                                  .quantity,
                                          price:
                                              databaseProvider
                                                  .previousUserOrders[index]
                                                  .productPrice
                                                  .toDouble(),
                                        ),
                                      ],
                                      total:
                                          databaseProvider
                                              .previousUserOrders[index]
                                              .productPrice
                                              .toDouble(),
                                    );
                                  },
                                ))
                            : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

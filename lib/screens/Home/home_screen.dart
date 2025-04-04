import 'package:animated_digit/animated_digit.dart';
import 'package:aurora_jewelry/providers/Cart/cart_provider.dart';
import 'package:aurora_jewelry/screens/Home/cart_screen.dart';
import 'package:aurora_jewelry/screens/Home/discover_screen.dart';
import 'package:aurora_jewelry/screens/Home/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey cartKey = GlobalKey();
  final pages = [DiscoverScreen(), SearchScreen(), CartScreen()];

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder:
          (context, cartProvider, child) => CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.home)),
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.search)),
                BottomNavigationBarItem(
                  icon: Builder(
                    builder: (context) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            key:
                                cartProvider
                                    .cartIconButtonKey, // Assign key here
                            child: Icon(CupertinoIcons.cart),
                          ),
                          Positioned(
                            top: -5,
                            right: -10,
                            child: AnimatedScale(
                              scale: cartProvider.cartItems.isNotEmpty ? 1 : 0,
                              duration: Duration(milliseconds: 300),
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemRed,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child:
                                      cartProvider.cartItems.length < 9
                                          ? AnimatedDigitWidget(
                                            
                                            value:
                                                cartProvider.cartItems.length,
                                            textStyle: TextStyle(
                                              color: CupertinoColors.white,
                                              fontSize: 17,
                                            ),
                                          )
                                          : Text(
                                            "9+",
                                            style: TextStyle(
                                              color: CupertinoColors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            tabBuilder: (BuildContext context, index) {
              return Stack(
                children: [
                  CupertinoTabView(
                    builder: (BuildContext context) {
                      return pages[index];
                    },
                  ),
                ],
              );
            },
          ),
    );
  }
}

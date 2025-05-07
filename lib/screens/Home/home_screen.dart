import 'package:aurora_jewelry/providers/Auth/auth_provider.dart';
import 'package:aurora_jewelry/providers/Cart/cart_provider.dart';
import 'package:aurora_jewelry/providers/Home/navigation_bar_provider.dart';
import 'package:aurora_jewelry/screens/Authentication/login_screen.dart';
import 'package:aurora_jewelry/screens/Home/cart_screen.dart';
import 'package:aurora_jewelry/screens/Home/discover_screen.dart';
import 'package:aurora_jewelry/screens/Home/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static GlobalKey? cartIconKeyGlobal;
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey cartIconKey = GlobalKey(); // move this from CartProvider

  final pages = [
    () => DiscoverScreen(),
    () => SearchScreen(),
    () => CartScreen(),
  ];

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    HomeScreen.cartIconKeyGlobal = cartIconKey;

    // Delay the call until after build is done
    Future.microtask(() async {
      // ignore: use_build_context_synchronously
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // ignore: use_build_context_synchronously
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      // ignore: use_build_context_synchronously
      await authProvider.checkIfAuthenticated(context);
      if (authProvider.isUserAuthenticated) {
        // ignore: use_build_context_synchronously
        await cartProvider.fetchCart(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CartProvider, NavigationBarProvider>(
      builder:
          (
            context,
            cartProvider,
            navigationBarProvider,
            child,
          ) => CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              currentIndex: navigationBarProvider.currentIndex,
              onTap: (index) {
                final isUserRegistered =
                    Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    ).isUserAuthenticated;
                if (index == 2 && !isUserRegistered) {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoSheetRoute<void>(
                      builder: (BuildContext context) => const LoginScreen(),
                    ),
                  );
                  return;
                }  else {
                  navigationBarProvider.setCurrentIndex(index);
                }
              },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.home,
                    color:
                        navigationBarProvider.currentIndex == 0
                            ? CupertinoColors.activeBlue
                            : CupertinoColors.systemGrey,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.search,
                    color:
                        navigationBarProvider.currentIndex == 1
                            ? CupertinoColors.activeBlue
                            : CupertinoColors.systemGrey,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Builder(
                    builder: (context) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            key: cartIconKey, //Key for animation
                            child: Icon(
                              CupertinoIcons.cart,
                              color:
                                  navigationBarProvider.currentIndex == 2
                                      ? CupertinoColors.activeBlue
                                      : CupertinoColors.systemGrey,
                            ),
                          ),
                          Positioned(
                            top: -5,
                            right: -10,
                            child: IgnorePointer(
                              child: AnimatedScale(
                                scale:
                                    cartProvider.cartItems.isNotEmpty ? 1 : 0,
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
                                            ? Text(
                                              cartProvider.cartItems.length
                                                  .toString(),
                                              style: TextStyle(
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
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            tabBuilder: (BuildContext context, index) {
              return CupertinoTabView(
                builder: (BuildContext context) {
                  return pages[navigationBarProvider.currentIndex]();
                },
              );
            },
          ),
    );
  }
}

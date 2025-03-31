import 'package:aurora_jewelry/screens/Home/cart_screen.dart';
import 'package:aurora_jewelry/screens/Home/discover_screen.dart';
import 'package:aurora_jewelry/screens/Home/search_screen.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final pages = [DiscoverScreen(), SearchScreen(), CartScreen()];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.home)),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.search)),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.cart)),
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
    );
  }
}

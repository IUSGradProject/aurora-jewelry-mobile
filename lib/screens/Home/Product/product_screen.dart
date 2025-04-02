import 'package:aurora_jewelry/screens/Home/Product/checkout_screen.dart';
import 'package:flutter/cupertino.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        //  backgroundColor: CupertinoColors.transparent,
        // enableBackgroundFilterBlur: false,
        // automaticBackgroundVisibility: false,
        previousPageTitle: "Search",
        // middle: Text("Gucci"),
      ),
      child: Container(
        padding: EdgeInsets.only(top: 16, ),
        child: ListView(
          padding: EdgeInsets.only(bottom: 116, top: 100),
          children: [
            SizedBox(
              height: 400,
              child: PageView(
                controller: PageController(viewportFraction: 0.7),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage("lib/assets/necklace.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage("lib/assets/necklace.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),

              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Lancinc",
                  style:
                      CupertinoTheme.of(
                        context,
                      ).textTheme.navLargeTitleTextStyle,
                ),
              ),
            ),
            // SizedBox(height: 0),
            // Padding(
            //   padding: const EdgeInsets.only(left: 16, right: 16),
            //   child: Align(
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       "Gucci",
            //       style: TextStyle(
            //         color: CupertinoColors.systemGrey,
            //         fontWeight: FontWeight.w700,
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(
                "Description about this product, something long this is very nice text explaining what this product is really about. You will need to buy it. I really liked it!",
                style: TextStyle(color: CupertinoColors.systemGrey),
              ),
            ),

            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "1050 BAM",
                  style:
                      CupertinoTheme.of(
                        context,
                      ).textTheme.dateTimePickerTextStyle,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Quantity",
                        style: TextStyle(color: CupertinoColors.systemGrey),
                      ),
                      Text(
                        "1",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: CupertinoColors.secondarySystemFill,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(
                            CupertinoIcons.minus,
                            color:
                                MediaQuery.of(context).platformBrightness ==
                                        Brightness.dark
                                    ? CupertinoColors.white
                                    : CupertinoColors.black,
                          ),
                          onPressed: () {},
                        ),
                        Container(
                          height: 22,
                          width: 1,
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(
                            CupertinoIcons.plus,
                            color:
                                MediaQuery.of(context).platformBrightness ==
                                        Brightness.dark
                                    ? CupertinoColors.white
                                    : CupertinoColors.black,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                children: [
                  CupertinoButton(
                    color: CupertinoColors.activeBlue,
                    borderRadius: BorderRadius.circular(8),
                    sizeStyle: CupertinoButtonSize.medium,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.cart_fill_badge_plus,
                          color: CupertinoColors.white,
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Add to Cart",
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(height: 8),
                  CupertinoButton(
                    color: CupertinoColors.activeGreen,
                    sizeStyle: CupertinoButtonSize.medium,
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.cart_fill,
                          color: CupertinoColors.white,
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Buy Now",
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => CheckoutScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

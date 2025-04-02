import 'package:aurora_jewelry/screens/Home/Product/product_screen.dart';
import 'package:flutter/cupertino.dart';

class ListProductComponent extends StatelessWidget {
  const ListProductComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Stack(
        children: [
          CupertinoButton(
            pressedOpacity: 0.6,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => ProductScreen()),
              );
            },
            padding: EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? CupertinoColors.tertiarySystemFill
                        : CupertinoColors.white,
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withValues(
                      alpha: 0.16,
                    ), // Shadow color
                    offset: const Offset(0, 4), // Shadow offset
                    blurRadius: 12, // Shadow blur radius
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: AssetImage("lib/assets/necklace.jpg"),
                            fit: BoxFit.cover,
                          ),
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lancic",
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Dior",
                            style: TextStyle(
                              color: CupertinoColors.systemGrey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4), // Spacing
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width -
                                200, // Adjust width dynamically
                            child: Text(
                              "This is very good lancic it is used to cover your beautiful neck with Swarowski Crs",
                              style: TextStyle(
                                color: CupertinoColors.systemGrey,
                                fontSize: 15,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "1050 BAM",
                        style: CupertinoTheme.of(
                          context,
                        ).textTheme.textStyle.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(CupertinoIcons.chevron_right),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              // color: CupertinoColors.activeBlue,
              child: Row(
                children: [Icon(CupertinoIcons.cart_badge_plus, size: 32)],
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

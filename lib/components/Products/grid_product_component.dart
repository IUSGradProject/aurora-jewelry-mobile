import 'package:aurora_jewelry/screens/Home/Product/product_screen.dart';
import 'package:flutter/cupertino.dart';

class GridProductComponent extends StatelessWidget {
  const GridProductComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      pressedOpacity: 0.6,
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => ProductScreen()),
        );
      },
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? CupertinoColors.tertiarySystemFill
                  : CupertinoColors.white,
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withOpacity(0.16),
              offset: Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage("lib/assets/necklace.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Lancic sa ovonekom",
              style: CupertinoTheme.of(context)
                  .textTheme
                  .textStyle
                  .copyWith(
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
              maxLines: 1,
            ),
            Text(
              "Dior",
              style: TextStyle(
                color: CupertinoColors.systemGrey,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Swarovski crystal necklace",
              style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "1050 BAM",
                  style: CupertinoTheme.of(context).textTheme.textStyle
                      .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Icon(CupertinoIcons.cart_badge_plus, size: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

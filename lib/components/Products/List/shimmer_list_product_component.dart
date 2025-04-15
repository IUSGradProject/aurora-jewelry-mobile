import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListProductComponent extends StatefulWidget {
  const ShimmerListProductComponent({super.key});

  @override
  State<ShimmerListProductComponent> createState() =>
      _ShimmerListProductComponentState();
}

class _ShimmerListProductComponentState
    extends State<ShimmerListProductComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
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
                Shimmer(
                  period: Duration(seconds: 2),
                  gradient: LinearGradient(
                    colors: [
                      CupertinoColors.systemGrey.withOpacity(0.2),
                      CupertinoColors.systemGrey.withOpacity(0.4),
                      CupertinoColors.systemGrey.withOpacity(0.2),
                    ],
                  ),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: CupertinoColors.systemGrey.withOpacity(0.6),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer(
                      period: Duration(seconds: 2),
                      gradient: LinearGradient(
                        colors: [
                          CupertinoColors.systemGrey.withOpacity(0.2),
                          CupertinoColors.systemGrey.withOpacity(0.4),
                          CupertinoColors.systemGrey.withOpacity(0.2),
                        ],
                      ),
                      child: Container(
                        height: 16,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: CupertinoColors.systemGrey.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Shimmer(
                      period: Duration(seconds: 2),
                      gradient: LinearGradient(
                        colors: [
                          CupertinoColors.systemGrey.withOpacity(0.2),
                          CupertinoColors.systemGrey.withOpacity(0.4),
                          CupertinoColors.systemGrey.withOpacity(0.2),
                        ],
                      ),
                      child: Container(
                        height: 16,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: CupertinoColors.systemGrey.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: 8), // Spacing
                    Shimmer(
                      period: Duration(seconds: 2),
                      gradient: LinearGradient(
                        colors: [
                          CupertinoColors.systemGrey.withOpacity(0.2),
                          CupertinoColors.systemGrey.withOpacity(0.4),
                          CupertinoColors.systemGrey.withOpacity(0.2),
                        ],
                      ),

                      child: Container(
                        height: 40,

                        width:
                            MediaQuery.of(context).size.width -
                            200, // Adjust width dynamically

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: CupertinoColors.systemGrey.withOpacity(0.6),
                        ),
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
                Shimmer(
                  period: Duration(seconds: 2),
                  gradient: LinearGradient(
                    colors: [
                      CupertinoColors.systemGrey.withOpacity(0.2),
                      CupertinoColors.systemGrey.withOpacity(0.4),
                      CupertinoColors.systemGrey.withOpacity(0.2),
                    ],
                  ),
                  child: Container(
                    height: 20,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: CupertinoColors.systemGrey.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

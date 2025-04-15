import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerGridProductComponent extends StatefulWidget {
  const ShimmerGridProductComponent({super.key});

  @override
  State<ShimmerGridProductComponent> createState() =>
      _ShimmerGridProductComponentState();
}

class _ShimmerGridProductComponentState
    extends State<ShimmerGridProductComponent>
  {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color:
                    MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? CupertinoColors.tertiarySystemFill
                        : CupertinoColors.white,
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withValues(alpha: 0.16),
                    offset: Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
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
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: CupertinoColors.systemGrey.withOpacity(0.6),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
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
                  SizedBox(height: 8),
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
                      height: 30,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: CupertinoColors.systemGrey.withOpacity(0.6),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
        
            Positioned(
              bottom: 16,
              left: 16,
              child: Shimmer(
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
            ),
          ],
        ),
      ],
    );
  }
}

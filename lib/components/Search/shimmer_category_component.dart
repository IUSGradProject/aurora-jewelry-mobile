import 'package:aurora_jewelry/providers/Search/search_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCategoryComponent extends StatelessWidget {
  const ShimmerCategoryComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder:
          (context, searchProvider, child) => Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
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
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: CupertinoColors.systemGrey.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
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
          ),
    );
  }
}

import 'package:aurora_jewelry/providers/Cart/cart_provider.dart';
import 'package:aurora_jewelry/providers/Database/database_provider.dart';
import 'package:aurora_jewelry/providers/Search/search_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProductScreen extends StatefulWidget {
  const ShimmerProductScreen({super.key});
  @override
  State<ShimmerProductScreen> createState() => _ShimmerProductScreenState();
}

class _ShimmerProductScreenState extends State<ShimmerProductScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder:
          (context, databaseProvider, child) => CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(),
            child: Consumer2<SearchProvider, CartProvider>(
              builder:
                  (context, searchProvider, cartProvider, child) => Container(
                    padding: EdgeInsets.only(top: 16),
                    child: ListView(
                      padding: EdgeInsets.only(bottom: 116, top: 100),
                      children: [
                        ///Single Image Product
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
                            height: 250,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: CupertinoColors.systemGrey.withOpacity(
                                0.6,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: CupertinoColors.systemGrey.withOpacity(
                                  0.6,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 8,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Shimmer(
                                  period: Duration(seconds: 2),
                                  gradient: LinearGradient(
                                    colors: [
                                      CupertinoColors.systemGrey.withOpacity(
                                        0.2,
                                      ),
                                      CupertinoColors.systemGrey.withOpacity(
                                        0.4,
                                      ),
                                      CupertinoColors.systemGrey.withOpacity(
                                        0.2,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: CupertinoColors.systemGrey
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                ),
                                Shimmer(
                                  period: Duration(seconds: 2),
                                  gradient: LinearGradient(
                                    colors: [
                                      CupertinoColors.systemGrey
                                          .withOpacity(0.2),
                                      CupertinoColors.systemGrey
                                          .withOpacity(0.4),
                                      CupertinoColors.systemGrey
                                          .withOpacity(0.2),
                                    ],
                                  ),
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        8,
                                      ),
                                      color: CupertinoColors.systemGrey
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                              height: 100,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: CupertinoColors.systemGrey.withOpacity(
                                  0.6,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
    );
  }
}

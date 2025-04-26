import 'package:aurora_jewelry/components/Products/list_product_component.dart';
import 'package:aurora_jewelry/providers/Database/database_provider.dart';
import 'package:aurora_jewelry/providers/Search/search_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SearchResultComponent extends StatefulWidget {
  const SearchResultComponent({super.key});

  @override
  State<SearchResultComponent> createState() => _SearchResultComponentState();
}

class _SearchResultComponentState extends State<SearchResultComponent> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<SearchProvider, DatabaseProvider>(
      builder:
          (context, searchProvider, databaseProvider, child) => Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CupertinoButton(
                  padding: EdgeInsets.only(bottom: 16, top: 8),
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 6,
                      bottom: 6,
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.tertiarySystemFill,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        databaseProvider.filterRequestModel.categories.isEmpty
                            ? Text("See Categories")
                            : Text(
                              "See all ${databaseProvider.categories.firstWhere((category) => category.id == databaseProvider.filterRequestModel.categories[0]).name}",
                            ),
                  ),
                  onPressed: () {
                    searchProvider.setSearchingStatus(false);
                    final currentFocus = FocusScope.of(context);
                    if (currentFocus.hasFocus) {
                      currentFocus.unfocus();
                    }
                    HapticFeedback.mediumImpact();
                  },
                ),
              ),

              databaseProvider.searchedProducts.isNotEmpty
                  ? ListView.builder(
                    shrinkWrap: true,
                    clipBehavior: Clip.none,
                    padding: EdgeInsets.only(bottom: 800),
                    itemCount: databaseProvider.searchedProducts.length,
                    itemBuilder: (context, index) {
                      final products = databaseProvider.searchedProducts;
                      return ListProductComponent(product: products[index]);
                    },
                  )
                  : Column(
                    children: [
                      Lottie.asset(
                        "lib/assets/nothing-found.json",
                        height: 200,
                      ),
                    ],
                  ),
            ],
          ),
    );
  }
}

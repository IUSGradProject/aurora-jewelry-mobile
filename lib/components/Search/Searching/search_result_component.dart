import 'package:aurora_jewelry/components/Products/list_product_component.dart';
import 'package:aurora_jewelry/providers/Database/database_provider.dart';
import 'package:aurora_jewelry/providers/Search/search_provider.dart';
import 'package:flutter/cupertino.dart';
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
          (context, searchProvider, databaseProvider, child) =>
              databaseProvider.searchedProducts.isNotEmpty
                  ? ListView.builder(
                    itemCount: databaseProvider.searchedProducts.length,
                    itemBuilder: (context, index) {
                      final products = databaseProvider.searchedProducts;
                      return ListProductComponent(product: products[index]);
                    },
                  )
                  : ListView(
                    children: [
                      Lottie.asset(
                        "lib/assets/nothing-found.json",
                        height: 200,
                      ),
                    ],
                  ),
    );
  }
}

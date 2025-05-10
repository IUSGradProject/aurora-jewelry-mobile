import 'package:aurora_jewelry/components/Products/List/shimmer_list_product_component.dart';
import 'package:aurora_jewelry/components/Products/list_product_component.dart';
import 'package:aurora_jewelry/components/Search/Category/all_category_component.dart';
import 'package:aurora_jewelry/components/Search/Category/category_component.dart';
import 'package:aurora_jewelry/components/Search/Category/shimmer_category_component.dart';
import 'package:aurora_jewelry/components/Search/Searching/search_result_component.dart';
import 'package:aurora_jewelry/components/Search/upper_component.dart';
import 'package:aurora_jewelry/models/Products/filter_request_model.dart';
import 'package:aurora_jewelry/providers/Database/database_provider.dart';
import 'package:aurora_jewelry/providers/Search/search_provider.dart';
import 'package:aurora_jewelry/widgets/profile_avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<DatabaseProvider>(context, listen: false).fetchCategories();

    //Check if there is some change inside of [_filterRequestModel]
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (Provider.of<DatabaseProvider>(
            context,
            listen: false,
          ).filterRequestModel !=
          FilterRequestModel(categories: [], brands: [], styles: [])) {
        Provider.of<DatabaseProvider>(
          context,
          listen: false,
        ).fetchFilteredProducts();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar.large(
        backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
        border: null,
        largeTitle: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Search"), ProfileAvatarWidget()],
          ),
        ),
      ),
      child: Consumer2<SearchProvider, DatabaseProvider>(
        builder: (context, searchProvider, databaseProvider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                UpperComponent(),
                SizedBox(height: 16),
                !searchProvider.isSearchingActive
                    ? Expanded(
                      child: ListView(
                      
                        padding: const EdgeInsets.only(bottom: 80),
                        children: [
                          // MAIN BODY: CATEGORIES OR PRODUCTS
                searchProvider.selectedCategories.isNotEmpty
                                        ? databaseProvider.areProductsFetched
                                            ? databaseProvider
                                                    .products
                                                    .isNotEmpty
                                                ? ListView.builder(
                                                  key: const ValueKey(
                                                    'ProductList',
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      databaseProvider
                                                          .products
                                                          .length,
                                                  itemBuilder: (
                                                    context,
                                                    index,
                                                  ) {
                                                    return ListProductComponent(
                                                      product:
                                                          databaseProvider
                                                              .products[index],
                                                    );
                                                  },
                                                )
                                                : Column(
                                                  children: [
                                                    SizedBox(height: 60),
                                                    Text(
                                                      "Sorry, No products found!",
                                                      style: CupertinoTheme.of(
                                                            context,
                                                          ).textTheme.textStyle
                                                          .copyWith(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                CupertinoColors
                                                                    .systemGrey,
                                                          ),
                                                    ),
                                                    Lottie.asset(
                                                      "lib/assets/nothing-found.json",
                                                      height: 200,
                                                    ),
                                                  ],
                                                )
                                            : ListView.builder(
                                              key: const ValueKey(
                                                'ProductShimmer',
                                              ),
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              itemCount: 6,
                                              itemBuilder: (context, index) {
                                                return ShimmerListProductComponent();
                                              },
                                            )
                                        : databaseProvider.areCategoriesFetched
                                        ? GridView.builder(
                                          key: const ValueKey('CategoryList'),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width /
                                                    2,
                                                mainAxisSpacing: 8,
                                                crossAxisSpacing: 8,
                                                childAspectRatio: 1.7,
                                              ),
                                          itemCount:
                                              databaseProvider
                                                  .categories
                                                  .length +
                                              1,
                                          itemBuilder: (context, index) {
                                            if (index ==
                                                databaseProvider
                                                    .categories
                                                    .length) {
                                              return AllCategoryComponent();
                                            }
                                            return CategoryComponent(
                                              category:
                                                  databaseProvider
                                                      .categories[index],
                                            );
                                          },
                                        )
                                        : GridView.builder(
                                          key: const ValueKey(
                                            'CategoryShimmer',
                                          ),
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width /
                                                    2,
                                                mainAxisSpacing: 8,
                                                crossAxisSpacing: 8,
                                                childAspectRatio: 1.7,
                                              ),
                                          itemCount: 6,
                                          itemBuilder: (context, index) {
                                            return ShimmerCategoryComponent();
                                          },
                                        ),
                        ],
                      ),
                    )
                    : Expanded(child: SearchResultComponent()),
              ],
            ),
          );
        },
      ),
    );
  }
}

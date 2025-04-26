import 'package:animations/animations.dart';
import 'package:aurora_jewelry/components/Products/List/shimmer_list_product_component.dart';
import 'package:aurora_jewelry/components/Products/list_product_component.dart';
import 'package:aurora_jewelry/components/Search/Category/all_category_component.dart';
import 'package:aurora_jewelry/components/Search/Category/category_component.dart';
import 'package:aurora_jewelry/components/Search/Category/shimmer_category_component.dart';
import 'package:aurora_jewelry/components/Search/Searching/search_result_component.dart';
import 'package:aurora_jewelry/providers/Database/database_provider.dart';
import 'package:aurora_jewelry/providers/Search/search_provider.dart';
import 'package:aurora_jewelry/widgets/Search/filter_bottom_sheet_widget.dart';
import 'package:aurora_jewelry/widgets/profile_avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<DatabaseProvider>(context, listen: false).fetchCategories();
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
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.tertiarySystemFill,
            width: 0.5,
          ),
        ),
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
                Column(
                  children: [
                    SizedBox(height: 60),
                    CupertinoTextField(
                      controller: _searchController,
                      enabled: databaseProvider.areProductsFetched,
                      placeholder: searchProvider.returnNameOfSearcTextField(),
                      placeholderStyle: CupertinoTheme.of(context)
                          .textTheme
                          .textStyle
                          .copyWith(color: CupertinoColors.systemGrey),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          CupertinoIcons.search,
                          size: 20,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onTap: () async {
                        if (databaseProvider
                            .filterRequestModel
                            .categories
                            .isEmpty) {
                          await databaseProvider.fetchProducts();
                        }
                        searchProvider.setSearchingStatus(true);
                      },
                      onChanged: (query) {
                        if (query.isNotEmpty) {
                          searchProvider.setSearchQuery(query);
                          databaseProvider.setSearchedProducts(query);
                        } else {
                          searchProvider.clearSearchQuery();
                          databaseProvider.clearSearchedProducts();
                        }
                      },
                      onTapOutside: (event) {
                        if (_searchController.text.isEmpty) {
                          searchProvider.setSearchingStatus(false);
                        }
                        FocusScope.of(context).unfocus(); // dismiss keyboard
                      },
                    ),

                    SizedBox(height: 16),
                    // FILTER & SORT ROW
                    Row(
                      children: [
                        Flexible(
                          // Use Flexible instead of Expanded
                          child: CupertinoButton(
                            onPressed: () {
                              if (databaseProvider.areProductsFetched) {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder:
                                      (context) => FilterBottomSheetWidget(),
                                );
                              }
                            },
                            padding: EdgeInsets.zero,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: CupertinoColors.tertiarySystemFill,
                                border: Border.all(
                                  color:
                                      searchProvider
                                              .checkIfThereWasChangesInFilters()
                                          ? CupertinoColors.activeBlue
                                          : CupertinoColors.transparent,
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.square_stack_3d_down_right,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ), // Replace Spacer to avoid layout issues
                                    Text(
                                      "Filters",
                                      style:
                                          CupertinoTheme.of(
                                            context,
                                          ).textTheme.textStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          // Use Flexible instead of Expanded
                          child: PullDownButton(
                            itemBuilder: (context) {
                              return [
                                PullDownMenuItem.selectable(
                                  selected: searchProvider.selectedSorting
                                      .contains("Lowest Price"),
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    searchProvider.selectSort("Lowest Price");
                                  },
                                  title: "Lowest Price",
                                  icon: CupertinoIcons.arrow_down,
                                ),

                                PullDownMenuItem.selectable(
                                  selected: searchProvider.selectedSorting
                                      .contains("Highest Price"),
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    searchProvider.selectSort("Highest Price");
                                  },
                                  title: "Highest Price",
                                  icon: CupertinoIcons.arrow_up,
                                ),
                                PullDownMenuItem.selectable(
                                  selected: searchProvider.selectedSorting
                                      .contains("A to Z"),
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    searchProvider.selectSort("A to Z");
                                  },
                                  title: "A to Z",
                                  icon: CupertinoIcons.textformat_abc,
                                ),

                                PullDownMenuItem.selectable(
                                  selected: searchProvider.selectedSorting
                                      .contains("Z to A"),
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    searchProvider.selectSort("Z to A");
                                  },
                                  title: "Z to A",
                                  icon:
                                      CupertinoIcons
                                          .textformat_abc_dottedunderline,
                                ),
                              ];
                            },
                            buttonBuilder: (context, showMenu) {
                              return CupertinoButton(
                                onPressed: () {
                                  if (databaseProvider.areProductsFetched) {
                                    showMenu();
                                  }
                                },
                                padding: EdgeInsets.zero,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  height: 44,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: CupertinoColors.tertiarySystemFill,
                                    border: Border.all(
                                      color:
                                          searchProvider.selectedSorting.isEmpty
                                              ? CupertinoColors.transparent
                                              : CupertinoColors.activeBlue,
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons
                                              .arrow_2_circlepath_circle,
                                        ),
                                        SizedBox(width: 8), // Replace Spacer
                                        Text(
                                          "Sort",
                                          style:
                                              CupertinoTheme.of(
                                                context,
                                              ).textTheme.textStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        AnimatedContainer(
                          padding: EdgeInsets.only(left: 8),
                          duration: Duration(milliseconds: 300),
                          width:
                              searchProvider.selectedCategories.isEmpty
                                  ? 0
                                  : searchProvider.selectedCategories.length > 1
                                  ? searchProvider.getTextWidth(context, "All")
                                  : searchProvider.getTextWidth(
                                    context,
                                    searchProvider.selectedCategories[0].name,
                                  ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: CupertinoColors.tertiarySystemFill,
                              // border: Border.all(
                              //   color: CupertinoColors.activeBlue,
                              // ),
                            ),
                            child: Center(
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                onPressed:
                                    () => searchProvider
                                        .clearSelectedCategories(context),
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Icon(
                                      CupertinoIcons.xmark_circle_fill,
                                      color: CupertinoColors.destructiveRed,
                                    ),
                                    SizedBox(width: 8), // Replace Spacer
                                    SizedBox(
                                      height: 44,
                                      child: Center(
                                        child: Text(
                                          searchProvider
                                                  .selectedCategories
                                                  .isEmpty
                                              ? ""
                                              : searchProvider
                                                      .selectedCategories
                                                      .length >
                                                  1
                                              ? "All"
                                              : searchProvider
                                                  .selectedCategories[0]
                                                  .name,
                                          style:
                                              CupertinoTheme.of(
                                                context,
                                              ).textTheme.textStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: searchProvider.isSearchingActive ? 50 : 0,
                      child: ListView(
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
                                    databaseProvider
                                            .filterRequestModel
                                            .categories
                                            .isEmpty
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
                        ],
                      ),
                    ),
                  ],
                ),
                !searchProvider.isSearchingActive
                    ? SizedBox(height: 16)
                    : SizedBox.shrink(),

                !searchProvider.isSearchingActive
                    ? Expanded(
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 80),
                        children: [
                          // MAIN BODY: CATEGORIES OR PRODUCTS
                          AnimatedBuilder(
                            animation: databaseProvider,
                            builder: (context, _) {
                              return PageTransitionSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (
                                  Widget child,
                                  Animation<double> primaryAnimation,
                                  Animation<double> secondaryAnimation,
                                ) {
                                  return FadeThroughTransition(
                                    fillColor:
                                        CupertinoTheme.of(
                                          context,
                                        ).scaffoldBackgroundColor,
                                    animation: primaryAnimation,
                                    secondaryAnimation: secondaryAnimation,
                                    child: child,
                                  );
                                },
                                child:
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
                              );
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

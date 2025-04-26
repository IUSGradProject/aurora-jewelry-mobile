import 'package:animations/animations.dart';
import 'package:aurora_jewelry/components/Products/List/shimmer_list_product_component.dart';
import 'package:aurora_jewelry/components/Products/list_product_component.dart';
import 'package:aurora_jewelry/components/Search/Category/all_category_component.dart';
import 'package:aurora_jewelry/components/Search/Category/category_component.dart';
import 'package:aurora_jewelry/components/Search/Category/shimmer_category_component.dart';
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
  @override
  void initState() {
    super.initState();
    Provider.of<DatabaseProvider>(context, listen: false).fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Consumer2<SearchProvider, DatabaseProvider>(
        builder: (context, searchProvider, databaseProvider, child) {
          return NestedScrollView(
            headerSliverBuilder:
                (context, innerBoxIsScrolled) => [
                  CupertinoSliverNavigationBar.search(
                    alwaysShowMiddle: false,
                    middle: Text("Search"),
                    largeTitle: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Search"), ProfileAvatarWidget()],
                      ),
                    ),
                    bottomMode: NavigationBarBottomMode.always,
                    searchField: CupertinoSearchTextField(
                      enabled: databaseProvider.areProductsFetched,
                      placeholder: searchProvider.returnNameOfSearcTextField(),
                    ),
                  ),
                ],
            body: ListView(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 96),
              children: [
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
                              builder: (context) => FilterBottomSheetWidget(),
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
                                Icon(CupertinoIcons.square_stack_3d_down_right),
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
                              selected: searchProvider.selectedSorting.contains(
                                "Lowest Price",
                              ),
                              onTap: () {
                                HapticFeedback.selectionClick();
                                searchProvider.selectSort("Lowest Price");
                              },
                              title: "Lowest Price",
                              icon: CupertinoIcons.arrow_down,
                            ),

                            PullDownMenuItem.selectable(
                              selected: searchProvider.selectedSorting.contains(
                                "Highest Price",
                              ),
                              onTap: () {
                                HapticFeedback.selectionClick();
                                searchProvider.selectSort("Highest Price");
                              },
                              title: "Highest Price",
                              icon: CupertinoIcons.arrow_up,
                            ),
                            PullDownMenuItem.selectable(
                              selected: searchProvider.selectedSorting.contains(
                                "A to Z",
                              ),
                              onTap: () {
                                HapticFeedback.selectionClick();
                                searchProvider.selectSort("A to Z");
                              },
                              title: "A to Z",
                              icon: CupertinoIcons.textformat_abc,
                            ),

                            PullDownMenuItem.selectable(
                              selected: searchProvider.selectedSorting.contains(
                                "Z to A",
                              ),
                              onTap: () {
                                HapticFeedback.selectionClick();
                                searchProvider.selectSort("Z to A");
                              },
                              title: "Z to A",
                              icon:
                                  CupertinoIcons.textformat_abc_dottedunderline,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.arrow_2_circlepath_circle,
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
                                () => searchProvider.clearSelectedCategories(
                                  context,
                                ),
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
                                      searchProvider.selectedCategories.isEmpty
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

                SizedBox(height: 16),

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
                                  ? databaseProvider.products.isNotEmpty
                                      ? ListView.builder(
                                        key: const ValueKey('ProductList'),
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            databaseProvider.products.length,
                                        itemBuilder: (context, index) {
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
                                            ).textTheme.textStyle.copyWith(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              color: CupertinoColors.systemGrey,
                                            ),
                                          ),
                                          Lottie.asset(
                                            "lib/assets/nothing-found.json",
                                            height: 200,
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      )
                                  : ListView.builder(
                                    key: const ValueKey('ProductShimmer'),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
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
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent:
                                          MediaQuery.of(context).size.width / 2,
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8,
                                      childAspectRatio: 1.7,
                                    ),
                                itemCount:
                                    databaseProvider.categories.length + 1,
                                itemBuilder: (context, index) {
                                  if (index ==
                                      databaseProvider.categories.length) {
                                    return AllCategoryComponent();
                                  }
                                  return CategoryComponent(
                                    category:
                                        databaseProvider.categories[index],
                                  );
                                },
                              )
                              : GridView.builder(
                                key: const ValueKey('CategoryShimmer'),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent:
                                          MediaQuery.of(context).size.width / 2,
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
          );
        },
      ),
    );
  }
}

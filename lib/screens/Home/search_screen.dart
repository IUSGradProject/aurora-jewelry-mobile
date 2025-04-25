import 'package:animations/animations.dart';
import 'package:aurora_jewelry/components/Products/List/shimmer_list_product_component.dart';
import 'package:aurora_jewelry/components/Products/list_product_component.dart';
import 'package:aurora_jewelry/components/Search/Category/category_component.dart';
import 'package:aurora_jewelry/components/Search/Category/shimmer_category_component.dart';
import 'package:aurora_jewelry/providers/Database/database_provider.dart';
import 'package:aurora_jewelry/providers/Search/search_provider.dart';
import 'package:aurora_jewelry/widgets/Search/filter_bottom_sheet_widget.dart';
import 'package:aurora_jewelry/widgets/profile_avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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
    if (mounted) {
      Provider.of<DatabaseProvider>(context, listen: false).fetchCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Consumer2<SearchProvider, DatabaseProvider>(
        builder:
            (
              context,
              searchProvider,
              databaseProvider,
              child,
            ) => CustomScrollView(
              slivers: [
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Row(
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
                                    () =>
                                        searchProvider
                                            .clearSelectedCategories(),
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
                  ),
                ),
                SliverPadding(padding: EdgeInsets.only(bottom: 32)),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverFillRemaining(
                    child: AnimatedBuilder(
                      animation: searchProvider,
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
                                      ? ListView(
                                        key: ValueKey('ProductsFetched'),
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        clipBehavior: Clip.none,
                                        children: [
                                          ListProductComponent(),
                                          ListProductComponent(),
                                          ListProductComponent(),
                                          ListProductComponent(),
                                        ],
                                      )
                                      : ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: 6,
                                        itemBuilder: (context, index) {
                                          return ShimmerListProductComponent();
                                        },
                                      )
                                  : databaseProvider.areCategoriesFetched
                                  ? GridView.builder(
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                    itemCount: databaseProvider.categories.length,
                                    itemBuilder: (context, index) {
                                      final category = databaseProvider
                                          .categories[index];
                                      return CategoryComponent(
                                        category: category,
                                      );
                                    },
                                  )
                                  : GridView.builder(
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                  ),
                ),
              ],
            ),
      ),
    );
  }
}

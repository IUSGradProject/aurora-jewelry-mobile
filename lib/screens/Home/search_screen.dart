import 'package:animations/animations.dart';
import 'package:aurora_jewelry/components/Products/list_product_component.dart';
import 'package:aurora_jewelry/components/Search/category_component.dart';
import 'package:aurora_jewelry/providers/Search/search_provider.dart';
import 'package:aurora_jewelry/widgets/Search/filter_bottom_sheet_widget.dart';
import 'package:aurora_jewelry/widgets/profile_avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Consumer<SearchProvider>(
        builder:
            (context, searchProvider, child) => CustomScrollView(
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
                              showCupertinoModalPopup(
                                context: context,
                                builder: (context) => FilterBottomSheetWidget(),
                              );
                            },
                            padding: EdgeInsets.zero,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: CupertinoColors.tertiarySystemFill,
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
                                onPressed: showMenu,
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
                                  ? ListView(
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    clipBehavior: Clip.none,
                                    children: [
                                      ListProductComponent(),
                                      ListProductComponent(),
                                      ListProductComponent(),
                                      ListProductComponent(),
                                    ],
                                  ) // Show empty container when a category is selected
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
                                    itemCount: searchProvider.categories.length,
                                    itemBuilder: (context, index) {
                                      final category =
                                          searchProvider.categories[index];
                                      return CategoryComponent(
                                        category: category,
                                      );
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

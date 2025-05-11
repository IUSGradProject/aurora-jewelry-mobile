import 'package:aurora_jewelry/providers/Database/database_provider.dart';
import 'package:aurora_jewelry/providers/Search/search_provider.dart';
import 'package:aurora_jewelry/widgets/Search/filter_bottom_sheet_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';

class UpperComponent extends StatefulWidget {
  const UpperComponent({super.key});

  @override
  State<UpperComponent> createState() => _UpperComponentState();
}

class _UpperComponentState extends State<UpperComponent> {
  final TextEditingController _searchController = TextEditingController();

  bool isComponentOpened = true;

  @override
  Widget build(BuildContext context) {
    return Consumer2<SearchProvider, DatabaseProvider>(
      builder:
          (context, searchProvider, databaseProvider, child) => Stack(
            clipBehavior: Clip.none,
            children: [
              Container(height: 93),
              AnimatedContainer(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 400),
                height:
                    isComponentOpened
                        ? searchProvider.isSearchingActive
                            ? 215
                            : 175
                        : 0,

                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
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

                    SizedBox(height: 8),
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
                              return List.generate(
                                searchProvider.sortingOptions.length,
                                (index) {
                                  return PullDownMenuItem.selectable(
                                    selected: searchProvider.selectedSorting
                                        .contains(
                                          searchProvider.sortingOptions[index],
                                        ),
                                    onTap: () async {
                                      HapticFeedback.selectionClick();
                                      searchProvider.selectSort(
                                        context,
                                        searchProvider.sortingOptions[index],
                                      );
                                      if (databaseProvider
                                          .products
                                          .isNotEmpty) {
                                        await databaseProvider
                                            .fetchFilteredProducts();
                                      }
                                    },
                                    title:
                                        searchProvider
                                            .sortingOptions[index]
                                            .name,
                                    //icon: CupertinoIcons.arrow_up,
                                  );
                                },
                              );
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
                    SizedBox(height: 8),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: searchProvider.isSearchingActive ? 50 : 0,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              searchProvider.setSearchingStatus(false);
                              final currentFocus = FocusScope.of(context);
                              if (currentFocus.hasFocus) {
                                currentFocus.unfocus();
                              }
                              setState(() {
                                _searchController.clear();
                              });
                              HapticFeedback.mediumImpact();
                            },
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
                                    databaseProvider
                                            .filterRequestModel
                                            .categories
                                            .isEmpty
                                        ? Text("See Categories")
                                        : Text(
                                          "See all ${databaseProvider.categories.firstWhere((category) => category.id == databaseProvider.filterRequestModel.categories[0]).name}",
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),

              AnimatedPositioned(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 300),
                bottom: 0,
                // right:
                //     isComponentOpened
                //         ? 0
                //         : MediaQuery.of(context).size.width / 3,
                right: 0,
                child: AnimatedScale(
                  alignment: Alignment.topCenter,
                  scale:
                      databaseProvider.filterRequestModel.categories.isEmpty
                          ? 0
                          : 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        isComponentOpened = !isComponentOpened;
                      });
                      HapticFeedback.mediumImpact();
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: isComponentOpened ? 35 : 94,
                      height: 35,
                      padding: EdgeInsets.only(right: 8, left: 7),
                      decoration: BoxDecoration(
                        color:
                            MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark
                                ? Colors.grey[900]
                                : Colors.white,

                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: CupertinoColors.activeBlue,
                          width: 1,
                        ),
                      ),
                      child: AnimatedRotation(
                        turns: isComponentOpened ? 0 : 0,
                        duration: Duration(milliseconds: 300),

                        child:
                            !isComponentOpened
                                ? ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        AnimatedRotation(
                                          turns: isComponentOpened ? 0 : 0,
                                          duration: Duration(milliseconds: 300),
                                          child: Row(
                                            children: [
                                              Icon(
                                                CupertinoIcons
                                                    .slider_horizontal_3,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Refine",
                                                style: TextStyle(
                                                  color:
                                                      MediaQuery.of(
                                                                context,
                                                              ).platformBrightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                                : ListView(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Icon(
                                      CupertinoIcons.chevron_up,
                                      color:
                                          MediaQuery.of(
                                                    context,
                                                  ).platformBrightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}

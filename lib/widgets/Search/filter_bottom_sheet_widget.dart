import 'package:animated_digit/animated_digit.dart';
import 'package:aurora_jewelry/models/Products/filter_request_model.dart';
import 'package:aurora_jewelry/providers/Database/database_provider.dart';
import 'package:aurora_jewelry/providers/Search/search_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  const FilterBottomSheetWidget({super.key});

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  @override
  void initState() {
    // Fetch brands, and styles when the widget is initialized
    if (mounted) {
      Provider.of<DatabaseProvider>(context, listen: false).fetchBrands();
      Provider.of<DatabaseProvider>(context, listen: false).fetchStyles();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: CupertinoPopupSurface(
        child: Consumer2<SearchProvider, DatabaseProvider>(
          builder:
              (context, searchProvider, databaseProvider, child) => SafeArea(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Stack(
                    children: [
                      ListView(
                        padding: EdgeInsets.zero,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Price Range",
                            style:
                                CupertinoTheme.of(
                                  context,
                                ).textTheme.navLargeTitleTextStyle,
                          ),
                          SizedBox(height: 16),
                          Material(
                            //  color:CupertinoDynamicColor.resolve(CupertinoColors.tertiaryLabel, context),
                            color: CupertinoColors.tertiarySystemFill,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(
                                // color: CupertinoDynamicColor.resolve(CupertinoColors.tertiaryLabel, context),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  RangeSlider(
                                    min: 1,
                                    max: 100000,
                                    divisions: 15,
                                    labels: RangeLabels(
                                      searchProvider.priceRange.start
                                          .round()
                                          .toString(),
                                      searchProvider.priceRange.end
                                          .round()
                                          .toString(),
                                    ),
                                    values: searchProvider.priceRange,
                                    onChanged: (RangeValues priceRange) {
                                      searchProvider.setPriceRange(priceRange);
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color:
                                                  CupertinoColors
                                                      .quaternarySystemFill,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            height: 80,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Minimum",
                                                  style: CupertinoTheme.of(
                                                        context,
                                                      ).textTheme.textStyle
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15,
                                                      ),
                                                ),

                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: AnimatedDigitWidget(
                                                    loop: false,
                                                    value:
                                                        searchProvider
                                                            .priceRange
                                                            .start
                                                            .round(),
                                                    textStyle:
                                                        CupertinoTheme.of(
                                                              context,
                                                            )
                                                            .textTheme
                                                            .textStyle
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 30,
                                                            ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color:
                                                  CupertinoColors
                                                      .quaternarySystemFill,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            height: 80,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Maximum",
                                                  style: CupertinoTheme.of(
                                                        context,
                                                      ).textTheme.textStyle
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15,
                                                      ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: AnimatedDigitWidget(
                                                    loop: false,
                                                    value:
                                                        searchProvider
                                                            .priceRange
                                                            .end
                                                            .round(),
                                                    textStyle:
                                                        CupertinoTheme.of(
                                                              context,
                                                            )
                                                            .textTheme
                                                            .textStyle
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 30,
                                                            ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            padding: EdgeInsets.all(8),
                            height:
                                searchProvider.checkIsRangeChanged() ? 36 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 20),
                                      child: Text("Restart"),
                                      onPressed: () {
                                        searchProvider.restartPriceRange();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16,
                            ),
                            child: Text(
                              "You can adjust minimum and maximum price of items that will be shown to you.",
                              style: CupertinoTheme.of(
                                context,
                              ).textTheme.navTitleTextStyle.copyWith(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: CupertinoColors.systemGrey,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(height: 32),
                          Text(
                            "Brands",
                            style:
                                CupertinoTheme.of(
                                  context,
                                ).textTheme.navLargeTitleTextStyle,
                          ),
                          SizedBox(height: 16),
                          PullDownButton(
                            buttonAnchor: PullDownMenuAnchor.end,
                            itemBuilder:
                                (context) =>
                                    databaseProvider.brands.map((brand) {
                                      return PullDownMenuItem.selectable(
                                        selected: searchProvider
                                            .checkIfBrandIsAdded(brand),
                                        onTap: () {
                                          searchProvider.selectBrand(brand);
                                        },
                                        title: brand.name,
                                      );
                                    }).toList(),
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
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            searchProvider
                                                    .selectedFilterBrands
                                                    .isNotEmpty
                                                ? searchProvider
                                                    .formatBrandList()
                                                : 'All',
                                            style:
                                                CupertinoTheme.of(
                                                  context,
                                                ).textTheme.textStyle,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(CupertinoIcons.arrow_up_down),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          AnimatedContainer(
                            padding: EdgeInsets.all(8),
                            height:
                                searchProvider.selectedFilterBrands.isNotEmpty
                                    ? 36
                                    : 0,
                            duration: const Duration(milliseconds: 300),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 20),
                                      child: Text("Clear"),
                                      onPressed: () {
                                        searchProvider.clearSelectedBrands();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16,
                            ),
                            child: Text(
                              "You can add brends that will only be shown to you.",
                              style: CupertinoTheme.of(
                                context,
                              ).textTheme.navTitleTextStyle.copyWith(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: CupertinoColors.systemGrey,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Styles",
                            style:
                                CupertinoTheme.of(
                                  context,
                                ).textTheme.navLargeTitleTextStyle,
                          ),
                          SizedBox(height: 16),
                          PullDownButton(
                            buttonAnchor: PullDownMenuAnchor.end,
                            itemBuilder:
                                (context) =>
                                    databaseProvider.styles.map((style) {
                                      return PullDownMenuItem.selectable(
                                        selected: searchProvider
                                            .checkIfStyleIsAdded(style),
                                        onTap: () {
                                          searchProvider.selectStyle(style);
                                        },
                                        title: style.name,
                                      );
                                    }).toList(),
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
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            searchProvider
                                                    .selectedFilterStyles
                                                    .isNotEmpty
                                                ? searchProvider
                                                    .formatStyleList()
                                                : 'All',
                                            style:
                                                CupertinoTheme.of(
                                                  context,
                                                ).textTheme.textStyle,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(CupertinoIcons.arrow_up_down),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          AnimatedContainer(
                            padding: EdgeInsets.all(8),
                            height:
                                searchProvider.selectedFilterStyles.isNotEmpty
                                    ? 36
                                    : 0,
                            duration: const Duration(milliseconds: 300),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 20),
                                      child: Text("Clear"),
                                      onPressed: () {
                                        searchProvider.clearSelectedStyles();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16,
                            ),
                            child: Text(
                              "You can add brends that will only be shown to you.",
                              style: CupertinoTheme.of(
                                context,
                              ).textTheme.navTitleTextStyle.copyWith(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: CupertinoColors.systemGrey,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if (searchProvider
                                .checkIfThereWasChangesInFilters()) {
                              showCupertinoDialog(
                                context: context,
                                builder:
                                    (context) => CupertinoAlertDialog(
                                      title: const Text("Are you sure?"),
                                      content: const Text(
                                        "If you close this window, all filters will be cleared.",
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: const Text("Cancel"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        CupertinoDialogAction(
                                          child: const Text("Discard"),
                                          onPressed: () {
                                            searchProvider.clearAllFilters();
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                              );
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              CupertinoIcons.xmark_circle_fill,
                              size: 32,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: AnimatedOpacity(
                          opacity:
                              searchProvider.checkIfThereWasChangesInFilters()
                                  ? 1
                                  : 0.5,
                          duration: const Duration(milliseconds: 300),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 32,
                            child: CupertinoButton(
                              borderRadius: BorderRadius.circular(12),
                              color: CupertinoColors.systemBlue,
                              child:
                                  databaseProvider.areProductsFetched
                                      ? const Text(
                                        "Apply Filters",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: CupertinoColors.white,
                                        ),
                                      )
                                      : CupertinoActivityIndicator(color: CupertinoColors.white,),
                              onPressed: () async {
                                if (databaseProvider.areProductsFetched) {
                                  if (searchProvider
                                      .checkIfThereWasChangesInFilters()) {
                                    Provider.of<DatabaseProvider>(
                                      context,
                                      listen: false,
                                    ).setFilterRequestModel(
                                      FilterRequestModel(
                                        categories:
                                            databaseProvider.categories
                                                .map((category) => category.id)
                                                .toList(),
                                        brands:
                                            searchProvider.selectedFilterBrands
                                                .map((brand) => brand.id)
                                                .toList(),
                                        styles:
                                            searchProvider.selectedFilterStyles
                                                .map((style) => style.id)
                                                .toList(),
                                        minPrice:
                                            searchProvider.priceRange.start,
                                        maxPrice: searchProvider.priceRange.end,
                                      ),
                                    );
                                    await Provider.of<DatabaseProvider>(
                                      context,
                                      listen: false,
                                    ).fetchFilteredProducts();
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context);
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}

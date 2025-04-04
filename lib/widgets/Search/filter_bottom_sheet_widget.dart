import 'package:animated_digit/animated_digit.dart';
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
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: CupertinoPopupSurface(
        child: Stack(
          children: [
            Consumer<SearchProvider>(
              builder:
                  (context, searchProvider, child) => Container(
                    padding: EdgeInsets.all(16),
                    // height: 680, // Adjust height as needed
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 96,),
                    
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
                                  min: 10,
                                  max: 100,
                                  divisions: 5,
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          height: 80,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Minimum",
                                                style: CupertinoTheme.of(
                                                  context,
                                                ).textTheme.textStyle.copyWith(
                                                  fontWeight: FontWeight.w600,
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
                                                  textStyle: CupertinoTheme.of(
                                                        context,
                                                      ).textTheme.textStyle
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          height: 80,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Maximum",
                                                style: CupertinoTheme.of(
                                                  context,
                                                ).textTheme.textStyle.copyWith(
                                                  fontWeight: FontWeight.w600,
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
                                                  textStyle: CupertinoTheme.of(
                                                        context,
                                                      ).textTheme.textStyle
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
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
                          height: searchProvider.checkIsRangeChanged() ? 36 : 0,
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
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
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
                                  searchProvider.availableBrands.map((brand) {
                                    return PullDownMenuItem.selectable(
                                      selected: searchProvider
                                          .checkIfBrandIsAdded(brand),
                                      onTap: () {
                                        searchProvider.selectBrand(brand);
                                      },
                                      title: brand,
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
                                              ? searchProvider.formatBrandList()
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
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
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
                        // SizedBox(height: 32),
                        Spacer(),
                        Center(
                          child: Row(
                            children: [
                              Expanded(
                                child: CupertinoButton(
                                  sizeStyle: CupertinoButtonSize.large,
                                  color: CupertinoColors.activeBlue,
                                  child: Text(
                                    "Apply Filters",
                                    style: TextStyle(
                                      color: CupertinoColors.white,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 60,),
                      ],
                    ),
                  ),
            ),
            Positioned(
              top: 68,
              right: 8,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
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
          ],
        ),
      ),
    );
  }
}

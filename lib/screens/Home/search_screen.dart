import 'package:aurora_jewelry/components/Search/category_component.dart';
import 'package:aurora_jewelry/widgets/Search/filter_bottom_sheet_widget.dart';
import 'package:aurora_jewelry/widgets/profile_avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
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
            searchField: CupertinoSearchTextField(placeholder: "Search Aurora"),
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
                            selected: true,
                            onTap: () {},
                            title: "Lower Price",
                            icon: CupertinoIcons.arrow_down,
                          ),

                          PullDownMenuItem.selectable(
                            onTap: () {},
                            title: "Higher Price",
                            icon: CupertinoIcons.arrow_up,
                          ),
                          PullDownMenuItem.selectable(
                            onTap: () {},
                            title: "A to Z",
                            icon: CupertinoIcons.textformat_abc,
                          ),

                          PullDownMenuItem.selectable(
                            onTap: () {},
                            title: "Z to A",
                            icon: CupertinoIcons.textformat_abc_dottedunderline,
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
                              // border: Border.all(
                              //   color: CupertinoColors.activeBlue,
                              // ),
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
                ],
              ),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(bottom: 80)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: CategoryComponent(
                      name: "Necklace",
                      icon: CupertinoIcons.right_chevron,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: CategoryComponent(
                      name: "Necklace",
                      icon: CupertinoIcons.right_chevron,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(bottom: 8)),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: CategoryComponent(
                      name: "Necklace",
                      icon: CupertinoIcons.right_chevron,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: CategoryComponent(
                      name: "Necklace",
                      icon: CupertinoIcons.right_chevron,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(bottom: 8)),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: CategoryComponent(
                      name: "Necklace",
                      icon: CupertinoIcons.right_chevron,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: CategoryComponent(
                      name: "Necklace",
                      icon: CupertinoIcons.right_chevron,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

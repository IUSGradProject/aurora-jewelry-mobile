import 'package:aurora_jewelry/models/Products/category_model.dart';

import 'package:aurora_jewelry/providers/Search/search_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CategoryComponent extends StatelessWidget {
  final CategoryModel category;
  const CategoryComponent({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder:
          (context, searchProvider, child) => CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              if (searchProvider.checkIfCategoryIsSelected(category)) {
                searchProvider.deselectCategory(category, context);
              } else {
                await searchProvider.selectCategory(category, context);
              }
              HapticFeedback.selectionClick();
            },
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? CupertinoColors.tertiarySystemFill
                        : CupertinoColors.white,
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withValues(
                      alpha: 0.16,
                    ), // Shadow color
                    offset: const Offset(0, 4), // Shadow offset
                    blurRadius: 12, // Shadow blur radius
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Icon(
                      Icons.category,
                      color: CupertinoTheme.of(context).primaryColor,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      category.name,
                      style: CupertinoTheme.of(context).textTheme.textStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

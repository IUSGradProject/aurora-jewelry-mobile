import 'package:flutter/cupertino.dart';

class FilterBottomSheetWidget extends StatelessWidget {
  const FilterBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16,bottom: 16),
      child: CupertinoPopupSurface(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              height: 400, // Adjust height as needed
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("Filters", style: TextStyle(fontSize: 30),), ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
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

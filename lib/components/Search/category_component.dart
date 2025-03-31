import 'package:flutter/cupertino.dart';

class CategoryComponent extends StatelessWidget {
  final String name;
  final IconData icon;
  const CategoryComponent({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: CupertinoColors.secondarySystemFill,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(alignment: Alignment.topLeft, child: Icon(icon)),
          Align(alignment: Alignment.bottomRight, child: Text(name)),
        ],
      ),
    );
  }
}

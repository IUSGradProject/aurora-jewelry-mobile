import 'package:aurora_jewelry/components/Products/grid_product_component.dart';
import 'package:aurora_jewelry/widgets/profile_avatar_widget.dart';
import 'package:flutter/cupertino.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            alwaysShowMiddle: false,
            middle: Text("Discover"),
        
            largeTitle: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Discover"), ProfileAvatarWidget()],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: GridView.builder(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 96),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.65,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return GridProductComponent();
              },
            ),
          ),
          // SliverGrid(
          //   // padding: EdgeInsets.zero,
          //   // physics: const NeverScrollableScrollPhysics(),
          //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //     maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
          //     mainAxisSpacing: 200,
          //     crossAxisSpacing: 8,
          //     childAspectRatio: 1,
          //   ),
          //   delegate: SliverChildListDelegate([
          //     GridProductComponent(),
          //     GridProductComponent(),
          //     GridProductComponent(),
          //   ]),

          //   // itemCount: searchProvider.categories.length,
          //   // itemBuilder: (context, index) {
          //   //   final category = searchProvider.categories[index];
          //   //   return GridProductComponent();
          //   // },
          // ),
        ],
      ),
    );
  }
}

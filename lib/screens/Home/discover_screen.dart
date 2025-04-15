import 'package:aurora_jewelry/components/Products/Grid/grid_product_component.dart';
import 'package:aurora_jewelry/components/Products/Grid/shimmer_grid_product_component.dart';
import 'package:aurora_jewelry/providers/Database/database_provider.dart';
import 'package:aurora_jewelry/widgets/profile_avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(Duration(seconds: 2), () {
      Provider.of<DatabaseProvider>(
        context,
        listen: false,
      ).setProductsFetchValue(true);
    });

    super.initState();
  }

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
            child: Consumer<DatabaseProvider>(
              builder: (context, databaseProvider, child) => AnimatedSwitcher(
                duration: Duration(milliseconds: 600),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: databaseProvider.areProductsFetched
                    ? GridView.builder(
                        key: ValueKey('ProductsFetched'),
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 96,
                          top: 8,
                        ),
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
                      )
                    : GridView.builder(
                        key: ValueKey('ShimmerLoading'),
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 96,
                          top: 8,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return ShimmerGridProductComponent();
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (mounted) {
      Provider.of<DatabaseProvider>(context, listen: false).fetchProducts();
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<DatabaseProvider>(
          context,
          listen: false,
        ).fetchMoreProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        controller: _scrollController,
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
              builder:
                  (context, databaseProvider, child) => AnimatedSwitcher(
                    duration: Duration(milliseconds: 600),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child:
                        databaseProvider.areProductsFetched
                            ? Column(
                              children: [
                                GridView.builder(
                                  key: ValueKey('ProductsFetched'),
                                  padding: EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    bottom: 96,
                                    top: 8,
                                  ),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                        childAspectRatio: 0.65,
                                      ),
                                  itemCount: databaseProvider.products.length,
                                  itemBuilder: (context, index) {
                                    return GridProductComponent(
                                      product: databaseProvider.products[index],
                                    );
                                  },
                                ),
                                if (databaseProvider.isFetchingMoreProducts)
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 160),
                                    child: CupertinoActivityIndicator(),
                                  ),
                              ],
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
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
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

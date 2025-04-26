import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imageURL;
  const ImagePreviewScreen({super.key, required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        CupertinoPageScaffold(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InteractiveViewer(
                panEnabled: true,
                minScale: 1,
                maxScale: 4,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: imageURL,
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    placeholder: (context, url) => const CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => const Icon(CupertinoIcons.exclamationmark_triangle),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 60,
          child: CupertinoButton(
            child: const Icon(CupertinoIcons.xmark_circle_fill, size: 32),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}

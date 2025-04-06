import 'package:flutter/cupertino.dart';

class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({super.key});

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
                  child: Image.asset(
                    "lib/assets/necklace2.jpg",
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 60,
          child: CupertinoButton(
            child: Icon(CupertinoIcons.xmark_circle_fill, size: 32),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}

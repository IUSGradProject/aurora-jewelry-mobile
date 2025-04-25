import 'package:flutter/cupertino.dart';

class CupertinoSnackBar extends StatefulWidget {
  final String message;
  final int animationDurationMillis;
  final int waitDurationMillis;

  const CupertinoSnackBar({
    super.key,
    required this.message,
    required this.animationDurationMillis,
    required this.waitDurationMillis,
  });

  @override
  State<CupertinoSnackBar> createState() => _CupertinoSnackBarState();
}

class _CupertinoSnackBarState extends State<CupertinoSnackBar> {
  bool _show = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => setState(() => _show = true));
    Future.delayed(Duration(milliseconds: widget.waitDurationMillis), () {
      if (mounted) {
        setState(() => _show = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: _show ? 120.0 : -50.0,
      left: 8.0,
      right: 8.0,
      curve: _show ? Curves.linearToEaseOut : Curves.easeInToLinear,
      duration: Duration(milliseconds: widget.animationDurationMillis),
      child: CupertinoPopupSurface(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(CupertinoIcons.info),
              SizedBox(width: 16),
              Text(
                widget.message,
                
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

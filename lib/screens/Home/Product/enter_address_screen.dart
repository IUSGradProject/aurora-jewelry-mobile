import 'package:aurora_jewelry/screens/Home/home_screen.dart';
import 'package:aurora_jewelry/screens/Home/profile_screen.dart';
import 'package:flutter/cupertino.dart';

class EnterAddressScreen extends StatefulWidget {
  const EnterAddressScreen({super.key});

  @override
  State<EnterAddressScreen> createState() => _EnterAddressScreenState();
}

class _EnterAddressScreenState extends State<EnterAddressScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  bool isPlaceOrderPressed = false;

  void placeOrder(BuildContext context) async {
    await Future.delayed(Duration(seconds: 3));

    // Push HomeScreen and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (_) => HomeScreen()),
      (route) => false, // Remove all previous routes
    );
    // Wait a frame to ensure the new screen is rendered before showing popup
    await Future.delayed(Duration(milliseconds: 300));

    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: CupertinoColors.activeGreen,
                    size: 45,
                  ),
                  SizedBox(height: 32),
                  Text(
                    "Thank you Mirza for ordering from Aurora Jewelry !",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Text(
                      "You can see you current and previous orders inside of your Profile.",
                      style: CupertinoTheme.of(
                        context,
                      ).textTheme.navTitleTextStyle.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: CupertinoColors.systemGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),
                  CupertinoButton(
                    child: Text("Open Orders"),
                    onPressed:
                        () {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                          CupertinoSheetRoute<void>(
                            builder:
                                (BuildContext context) =>
                                    const ProfileScreen(),
                          ),
                        );
                        },
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = CupertinoTheme.of(context).textTheme;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text("Checkout"),

            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 56),
            children: [
              Text(
                "One more step",
                style:
                    CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
              ),
              Text(
                "Delivery Details",
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
              ),
              SizedBox(height: 32),
              // Address Label
              Text(
                "Address",
                style: textTheme.textStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              // Address Input
              CupertinoTextField(
                controller: _addressController,
                placeholder: "Enter your address...",
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemFill,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 16),

              // City Label and Input
              Text(
                "City",
                style: textTheme.textStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _cityController,
                placeholder: "Enter your city...",
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemFill,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 16),

              // Postal Code Label and Input
              Text(
                "Postal Code",
                style: textTheme.textStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _postalCodeController,
                placeholder: "Enter postal code...",
                keyboardType: TextInputType.number,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemFill,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 24),

              // Payment Note
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(
                    CupertinoIcons.info,
                    size: 20,
                    color: CupertinoColors.systemGrey,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "You will pay when the order is delivered to your address.",
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 60,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 32,
            child: CupertinoButton(
              borderRadius: BorderRadius.circular(12),
              color:
                  !isPlaceOrderPressed
                      ? CupertinoColors.systemBlue
                      : CupertinoColors.systemBlue.withOpacity(0.2),
              child:
                  !isPlaceOrderPressed
                      ? const Text(
                        "Place Order",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.white,
                        ),
                      )
                      : CupertinoActivityIndicator(
                        color: CupertinoColors.white,
                      ),
              onPressed: () {
                // if (_textEditingController.text != "Appo Salon" &&
                //     _textEditingController.text != "") {
                //   Navigator.pop(context);
                // }
                placeOrder(context);
                setState(() {
                  isPlaceOrderPressed = !isPlaceOrderPressed;
                });
              },
            ),
          ),
        ),
        // Positioned(
        //   bottom: 0,
        //   right: 16,
        //   child: Container(
        //     height: 120,

        //     child: CupertinoButton.filled(
        //       borderRadius: BorderRadius.circular(12),
        //       // padding: const EdgeInsets.symmetric(vertical: 16),
        //       onPressed: () {
        //         // Handle order logic here
        //         if (_addressController.text.trim().isEmpty ||
        //             _cityController.text.trim().isEmpty ||
        //             _postalCodeController.text.trim().isEmpty) {
        //           showCupertinoDialog(
        //             context: context,
        //             builder:
        //                 (context) => CupertinoAlertDialog(
        //                   title: const Text("Missing Information"),
        //                   content: const Text("Please fill in all fields."),
        //                   actions: [
        //                     CupertinoDialogAction(
        //                       child: const Text("OK"),
        //                       onPressed: () => Navigator.pop(context),
        //                     ),
        //                   ],
        //                 ),
        //           );
        //         } else {
        //           // Navigate or show confirmation
        //           showCupertinoDialog(
        //             context: context,
        //             builder:
        //                 (context) => CupertinoAlertDialog(
        //                   title: const Text("Order Placed"),
        //                   content: const Text(
        //                     "Your order has been placed successfully!",
        //                   ),
        //                   actions: [
        //                     CupertinoDialogAction(
        //                       child: const Text("OK"),
        //                       onPressed: () => Navigator.pop(context),
        //                     ),
        //                   ],
        //                 ),
        //           );
        //         }
        //       },
        //       child: const Text("Order Now"),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

import 'package:aurora_jewelry/models/Cart/delivery_address_model.dart';
import 'package:aurora_jewelry/providers/Auth/user_provider.dart';
import 'package:aurora_jewelry/providers/Cart/cart_provider.dart';
import 'package:aurora_jewelry/screens/Home/home_screen.dart';
import 'package:aurora_jewelry/screens/Home/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterDeliveryAddressScreen extends StatefulWidget {
  const EnterDeliveryAddressScreen({super.key});

  @override
  State<EnterDeliveryAddressScreen> createState() =>
      _EnterDeliveryAddressScreenState();
}

class _EnterDeliveryAddressScreenState
    extends State<EnterDeliveryAddressScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  // This variable is used to store prefs delivery address
  DeliveryAddressModel _prefsDeliveryAddress = DeliveryAddressModel(
    fullName: '',
    address: '',
    city: '',
    postalCode: 0,
  );

  bool canUserPressDone() {
    if (_fullNameController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        _postalCodeController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void placeOrder(BuildContext context) async {
    await Future.delayed(Duration(seconds: 3));

    // Push HomeScreen and remove all previous routes
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (_) => HomeScreen()),
      (route) => false, // Remove all previous routes
    );
    // Wait a frame to ensure the new screen is rendered before showing popup
    await Future.delayed(Duration(milliseconds: 300));

    showCupertinoModalPopup(
      // ignore: use_build_context_synchronously
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
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        CupertinoSheetRoute<void>(
                          builder:
                              (BuildContext context) => const ProfileScreen(),
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

  Future<void> _initDeliveryAddress() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final isSet = await userProvider.isUserDeliveryAddressSet();
    if (isSet) {
      final deliveryAddress = await userProvider.getUserDeliveryAddress();
      setState(() {
        _prefsDeliveryAddress = deliveryAddress;
        _fullNameController.text = deliveryAddress.fullName;
        _addressController.text = deliveryAddress.address;
        _cityController.text = deliveryAddress.city;
        _postalCodeController.text = deliveryAddress.postalCode.toString();
      });
      // Do something with deliveryAddress if needed
    }
  }

  bool wereThereDifferenceBetweenDeliveryAddress() {
    if (_fullNameController.text != _prefsDeliveryAddress.fullName ||
        _addressController.text != _prefsDeliveryAddress.address ||
        _cityController.text != _prefsDeliveryAddress.city ||
        int.parse(_postalCodeController.text) !=
            _prefsDeliveryAddress.postalCode) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initDeliveryAddress();
      final user = userProvider.currentUser!;
      _fullNameController.text = "${user.firstName} ${user.lastName}";
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = CupertinoTheme.of(context).textTheme;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text("Delivery Address"),

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
                "Full Name",
                style: textTheme.textStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              // Address Input
              CupertinoTextField(
                controller: _fullNameController,
                placeholder: "John Doe",
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
                clearButtonMode: OverlayVisibilityMode.editing,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemFill,
                  borderRadius: BorderRadius.circular(12),
                ),
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 16),
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
                placeholder: "Address",
                clearButtonMode: OverlayVisibilityMode.editing,

                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemFill,
                  borderRadius: BorderRadius.circular(12),
                ),
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          placeholder: "City",
                          clearButtonMode: OverlayVisibilityMode.editing,

                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemFill,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          placeholder: "Postal Code",
                          keyboardType: TextInputType.number,
                          clearButtonMode: OverlayVisibilityMode.editing,

                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemFill,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Consumer<UserProvider>(
                builder:
                    (context, userProvider, child) =>
                        !userProvider.isDeliveryAddressSet
                            ? AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              opacity: canUserPressDone() ? 1 : 0.5,
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  if (canUserPressDone()) {
                                    await userProvider
                                        .saveUserDeliveryAddressToPrefs(
                                          _fullNameController.text,
                                          _addressController.text,
                                          _cityController.text,
                                          int.parse(_postalCodeController.text),
                                        );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),

                                    border: Border.all(
                                      color:
                                          MediaQuery.of(
                                                    context,
                                                  ).platformBrightness ==
                                                  Brightness.dark
                                              ? Colors.grey[800]!
                                              : CupertinoColors.systemGrey5,
                                    ),
                                  ),

                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          FutureBuilder<bool>(
                                            future:
                                                userProvider
                                                    .isUserDeliveryAddressSet(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return CupertinoActivityIndicator(
                                                  radius: 15,
                                                ); // or a loading indicator
                                              }

                                              return Transform.scale(
                                                scale: 1.5,
                                                child: CupertinoCheckbox(
                                                  value: snapshot.data,
                                                  onChanged: (value) {},
                                                ),
                                              );
                                            },
                                          ),

                                          SizedBox(
                                            width: 8,
                                          ), // optional spacing between checkbox and text
                                          Expanded(
                                            child: Text(
                                              "Save this Delivery Address for Future Orders.",
                                              style: TextStyle(
                                                fontSize: 17,
                                                color:
                                                    CupertinoColors.activeBlue,
                                              ),
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 50,
                                          right: 16,
                                        ),
                                        child: Text(
                                          "After saving your address you will be able to edit it in future.",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: CupertinoColors.systemGrey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            : Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),

                                border: Border.all(
                                  color:
                                      MediaQuery.of(
                                                context,
                                              ).platformBrightness ==
                                              Brightness.dark
                                          ? Colors.grey[800]!
                                          : CupertinoColors.systemGrey5,
                                ),
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "You have a saved Delivery Address.",
                                    style: TextStyle(fontSize: 17),
                                    softWrap: true,
                                  ),
                                  AnimatedContainer(
                                    height:
                                        wereThereDifferenceBetweenDeliveryAddress()
                                            ? 25
                                            : 0,
                                    duration: Duration(milliseconds: 300),
                                    child: ListView(
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          "Delivery Address Updated",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: CupertinoColors.systemGrey
                                                .withValues(alpha: 0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
              ),

              AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity:
                    Provider.of<UserProvider>(
                          context,
                          listen: true,
                        ).isDeliveryAddressSet
                        ? 1
                        : 0,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(
                      "Remove",
                      style: TextStyle(color: CupertinoColors.systemRed),
                    ),
                    onPressed: () {
                      if (Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).isDeliveryAddressSet) {
                        //Remove delivery address from shared prefs
                        Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).removeSharedPrefsDeliveryAddress();
                        Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).checkIfDeliveryAddressIsSavedToSharedPrefs();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 60,
          child: AnimatedOpacity(
            opacity: canUserPressDone() ? 1 : 0.5,
            duration: Duration(milliseconds: 300),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(12),
                color: CupertinoColors.activeBlue,
                onPressed: () {
                  if (canUserPressDone()) {
                    // Set the delivery address
                    Provider.of<CartProvider>(
                      context,
                      listen: false,
                    ).setDeliveryAddress(
                      DeliveryAddressModel(
                        fullName: _fullNameController.text,
                        address: _addressController.text,
                        city: _cityController.text,
                        postalCode: int.parse(_postalCodeController.text),
                      ),
                    );
                    // Place the order
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Done",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

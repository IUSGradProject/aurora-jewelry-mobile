

import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier {

  bool _isUserAuthenticated = false;

  //Getters

  bool get isUserAuthenticated => _isUserAuthenticated;

}
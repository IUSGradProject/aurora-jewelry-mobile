import 'package:flutter/cupertino.dart';

class DatabaseProvider extends ChangeNotifier {
  bool _areProductsFetched = false;

  //Getters

  bool get areProductsFetched => _areProductsFetched;

  //Setters
  void setProductsFetchValue(bool value) {
    _areProductsFetched = value;
    notifyListeners();
  }
}

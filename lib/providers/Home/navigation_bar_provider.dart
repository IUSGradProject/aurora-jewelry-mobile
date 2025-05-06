import 'package:flutter/cupertino.dart';

class NavigationBarProvider extends ChangeNotifier{

  int _currentIndex = 0;


  //Getters
  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

}
import 'package:flutter/cupertino.dart';

class NavigationBarProvider extends ChangeNotifier {
  int _previousIndex = 0;
  int _currentIndex = 0;

  //Getters
  int get currentIndex => _currentIndex;
  int get previousIndex => _previousIndex;

  void setCurrentIndex(int newIndex) {
    if (_currentIndex != newIndex) {
      _previousIndex = _currentIndex;
      _currentIndex = newIndex;
      notifyListeners();
    }
  }
}

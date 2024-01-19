import 'package:flutter/material.dart';

class AddressChanger with ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;
  displayCounterResult(int counter) {
    _counter = counter;
    notifyListeners();
  }


  
}

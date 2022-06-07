
import 'package:flutter/material.dart';

class TabsProvider with ChangeNotifier {
  int _current = 0;
  get current => _current;
  switchtabs(tabNo) {
    _current = tabNo;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class TabsProvider with ChangeNotifier {
  int _current = 0;
  var _show = false;
  get show => _show;
  get current => _current;
  switchtabs(tabNo) {
    _current = tabNo;
    notifyListeners();
  }

  change() {
    _show = !_show;
    notifyListeners();
  }
}

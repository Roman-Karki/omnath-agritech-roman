import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../stock/validator.dart';

class TabsProvider with ChangeNotifier {
  int _current = 0;
  var _show = false;
  Map map = {};
  List l = [];
  get show => _show;
  get current => _current;
  switchtabs(tabNo, context) {
    _current = tabNo;
    if (tabNo == 2) {
    } else {
      final validationService =
          Provider.of<ProductValidation>(context, listen: false);
      validationService.changeForm(
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        map,
        l,
        reset: true
      );
    }
    notifyListeners();
  }

  change() {
    _show = !_show;
    notifyListeners();
  }
}

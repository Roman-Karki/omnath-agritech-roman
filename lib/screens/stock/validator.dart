import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapItem {
  String? name;
  Map<String, String>? map;

  MapItem(this.name, this.map);
  @override
  String toString() {
    return '{ ${this.name}, ${this.map} }';
  }
}

class ValidationItem {
  final String? value;
  final String? error;

  ValidationItem(this.value, this.error);
}

class ProductValidation with ChangeNotifier {
  ValidationItem _docId = ValidationItem(null, null);
  ValidationItem _nameEN = ValidationItem(null, null);
  ValidationItem _nameHN = ValidationItem(null, null);
  ValidationItem _desEN = ValidationItem(null, null);
  ValidationItem _desHN = ValidationItem(null, null);
  ValidationItem _productCategory = ValidationItem(null, null);
  ValidationItem _status = ValidationItem(null, null);
  ValidationItem _price = ValidationItem(null, null);
  ValidationItem _quantity = ValidationItem(null, null);
  ValidationItem _company = ValidationItem(null, null);
  ValidationItem _stock = ValidationItem(null, null);
  ValidationItem _discount = ValidationItem(null, null);
  ValidationItem _gst = ValidationItem(null, null);
  ValidationItem _searchKey = ValidationItem(null, null);
  ValidationItem _option = ValidationItem(null, null);
  ValidationItem _displayOffer = ValidationItem(null, null);

//Getters
  ValidationItem get docId => _docId;
  ValidationItem get nameEN => _nameEN;
  ValidationItem get nameHN => _nameHN;
  ValidationItem get desEN => _desEN;
  ValidationItem get desHN => _desHN;
  ValidationItem get productCategory => _productCategory;
  ValidationItem get status => _status;
  ValidationItem get price => _price;
  ValidationItem get quantity => _quantity;
  ValidationItem get company => _company;
  ValidationItem get stock => _stock;
  ValidationItem get discount => _discount;
  ValidationItem get gst => _gst;
  ValidationItem get searchKey => _searchKey;
  ValidationItem get option => _option;
  ValidationItem get displayOffer => _displayOffer;

  bool get isValid {
    if (_nameEN.value != null &&
        _nameHN.value != null &&
        _desEN.value != null &&
        _desHN.value != null &&
        _productCategory.value != null &&
        _status.value != null &&
        _price.value != null &&
        _company.value != null &&
        _stock.value != null &&
        _discount.value != null &&
        _gst.value != null &&
        _searchKey.value != null &&
        _option.value != null &&
        _displayOffer.value != null &&
        _quantity.value != null) {
      return true;
    } else {
      return false;
    }
  }

  bool get isValid1 {
    if (_price.value != null &&
        _stock.value != null &&
        _discount.value != null &&
        _quantity.value != null) {
      return true;
    } else {
      return false;
    }
  }

//Setters
  void changeDocId(String value) {
    _nameEN = ValidationItem(value, null);
    notifyListeners();
  }

  void changenameEN(String value) {
    if (value.length >= 3) {
      _nameEN = ValidationItem(value, null);
    } else {
      _nameEN = ValidationItem(null, "Must be at least 3 characters");
    }
    notifyListeners();
  }

  void changenameHN(String value) {
    if (value.length >= 3) {
      _nameHN = ValidationItem(value, null);
    } else {
      _nameHN = ValidationItem(null, "Must be at least 3 characters");
    }
    notifyListeners();
  }

  void changedesEN(String value) {
    if (value.length >= 10) {
      _desEN = ValidationItem(value, null);
    } else {
      _desEN = ValidationItem(null, "Must be at least 10 characters");
    }
    notifyListeners();
  }

  void changedesHN(String value) {
    if (value.length >= 10) {
      _desHN = ValidationItem(value, null);
    } else {
      _desHN = ValidationItem(null, "Must be at least 10 characters");
    }
    notifyListeners();
  }

  void changeproductCategory(String value) {
    if (value.toString().isNotEmpty) {
      _productCategory = ValidationItem(value.toString(), null);
    } else {
      _productCategory = ValidationItem(null, "Select Valid Product Category");
    }
    notifyListeners();
  }

  void changecompany(String value) {
    if (value.length >= 3) {
      _company = ValidationItem(value, null);
    } else {
      _company = ValidationItem(null, "Must be at least 3 characters");
    }
    notifyListeners();
  }

  void changestatus(String value) {
    if (value.toString().isNotEmpty) {
      _status = ValidationItem(value.toString(), null);
    } else {
      _status = ValidationItem(null, "Select Valid Status");
    }
    notifyListeners();
  }

  void changeprice(int value) {
    if (value.toString().isNotEmpty) {
      _price = ValidationItem(value.toString(), null);
    } else {
      _price = ValidationItem(null, "Insert Price ");
    }
    notifyListeners();
  }

  void changequantity(int value) {
    if (value.toString().isNotEmpty) {
      _quantity = ValidationItem(value.toString(), null);
    } else {
      _quantity = ValidationItem(null, "Insert Quantity");
    }
    notifyListeners();
  }

  void changestock(String value) {
    if (value.isNotEmpty) {
      _stock = ValidationItem(value, null);
    } else {
      _stock = ValidationItem(null, "Insert Stock");
    }
    notifyListeners();
  }

  void changediscount(String value) {
    if (value.isNotEmpty) {
      _discount = ValidationItem(value, null);
    } else {
      _discount = ValidationItem(null, "Insert Discount");
    }
    notifyListeners();
  }

  void changegst(String value) {
    if (value.isNotEmpty) {
      _gst = ValidationItem(value, null);
    } else {
      _gst = ValidationItem(null, "Must be at least 3 characters");
    }
    notifyListeners();
  }

  void changesearchKey(String value) {
    if (value.length >= 3) {
      _searchKey = ValidationItem(value, null);
    } else {
      _searchKey = ValidationItem(null, "Must be at least 3 characters");
    }
    notifyListeners();
  }

  void changeoption(String value) {
    if (value.length >= 3) {
      _option = ValidationItem(value, null);
    } else {
      _option = ValidationItem(null, "Must be at least 3 characters");
    }
    notifyListeners();
  }

  void changedisplayOffer(int? value) {
    if (value == 0) {
      _displayOffer = ValidationItem("Yes", null);
    } else {
      _displayOffer = ValidationItem("No", null);
    }
    notifyListeners();
  }

  var i = 0;
  String? index;
  List options = [];
  final Map<String, Map<String, String>> map = {};

  void submitOption() {
    map[(i++).toString()] = {
      'Quantity': _quantity.value!,
      'Price': _price.value!,
      'Stock': _stock.value!,
      'Discount': _discount.value!,
      'OptionIndex': (i.toString()),
    };

    map.forEach((k, v) => options.add(MapItem(k, v)));
    print(map.toString());
    notifyListeners();
  }

  List<String> downloadUrl = <String>[];
  void submitDownloadUrl(List<String> value) {
    downloadUrl.addAll(value);
    notifyListeners();
  }

  Map<String, Map<String, String>>? get maps1 {
    return map;
  }

  void deleteOption(String value) {
    map.remove(value);
    notifyListeners();
  }

  Future<void> userSetup() async {
    CollectionReference product =
        FirebaseFirestore.instance.collection('Product');
    // FirebaseAuth auth = FirebaseAuth.instance;
    // String uid = auth.currentUser.uid.toString();
    product.add({
      'nameEN': nameEN.value,
      'nameHN': nameHN.value,
      'desEN': desEN.value,
      'desHN': desHN.value,
      'productCategory': productCategory.value,
      'status': status.value,
      'company': company.value,
      'gst': gst.value,
      'searchKey': searchKey.value,
      'displayOffer': displayOffer.value,
      'options': map,
      'images': downloadUrl,
    });
    return;
  }

  void changeForm(
      String id,
      String value1,
      String value2,
      String value3,
      String value4,
      String value5,
      String value6,
      String value7,
      String value8,
      String value9,
      String value10) {
    _docId = ValidationItem(id, null);
    _nameEN = ValidationItem(value1, null);
    _nameHN = ValidationItem(value2, null);
    _desEN = ValidationItem(value3, null);
    _desHN = ValidationItem(value4, null);
    _productCategory = ValidationItem(value5.toString(), null);
    _status = ValidationItem(value6.toString(), null);
    _company = ValidationItem(value7, null);
    _gst = ValidationItem(value8, null);
    _searchKey = ValidationItem(value9, null);
    _displayOffer = ValidationItem(value10, null);

    notifyListeners();
  }

  Future<void> update() async {
    CollectionReference product =
        FirebaseFirestore.instance.collection('Product');

    product.doc('${_docId.value}').update({
      'nameEN': nameEN.value,
      'nameHN': nameHN.value,
      'desEN': desEN.value,
      'desHN': desHN.value,
      'productCategory': productCategory.value,
      'status': status.value,
      'company': company.value,
      'gst': gst.value,
      'searchKey': searchKey.value,
      'displayOffer': displayOffer.value,
      'options': map,
      'images': downloadUrl,
    });
    return;
  }

  void submitData() {
    _docId.value == null ? userSetup() : update();
  }
}

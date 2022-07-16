import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io' show File;
import '../../../constants.dart';
import '../../main/providers/tabs_provider.dart';
import '../validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:provider/provider.dart';
import 'package:omnath_agritech_web/responsive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({
    Key? key,
  }) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  List<Widget> itemPhotosWidgetList = <Widget>[];

  final ImagePicker _picker = ImagePicker();
  File? file;
  List<XFile>? photo = <XFile>[];
  List<XFile> itemImagesList = <XFile>[];

  List<String> downloadUrl = <String>[];
  var _showContainer;
  bool uploading = false;

  var _productId;

  addImage() {
    for (var bytes in photo!) {
      itemPhotosWidgetList.add(Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          height: 90.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(child: Image.network(File(bytes.path).path)),
          ),
        ),
      ));
    }
  }

  pickPhotoFromGallery() async {
    photo = await _picker.pickMultiImage();
    if (photo != null) {
      setState(() {
        itemImagesList = itemImagesList + photo!;
        addImage();
        photo!.clear();
      });
    }
  }

  upload() async {
    String productId = await uplaodImageAndSaveItemInfo();
    setState(() {
      uploading = false;
    });
    return productId;
  }

  Future<String> uplaodImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    PickedFile? pickedFile;
    var rng = Random();
    var n = rng.nextInt(34433224);
    String? productId = n.toString();

    for (int i = 0; i < itemImagesList.length; i++) {
      file = File(itemImagesList[i].path);
      pickedFile = PickedFile(file!.path);

      await uploadImageToStorage(pickedFile, productId, i);
    }
    return productId;
  }

  uploadImageToStorage(PickedFile? pickedFile, String productId, i) async {
    final validationService =
        Provider.of<ProductValidation>(context, listen: false);
    validationService.productid(productId);
    Reference reference =
        FirebaseStorage.instance.ref().child('Items/$productId/$i');
    await reference.putData(
      await pickedFile!.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    String value = await reference.getDownloadURL();
    downloadUrl.add(value);
  }

  @override
  void initState() {
    _showContainer = false;
    companies();

    super.initState();
    setState(() {
      loading = true;
    });
  }

  bool loading = true;
  List<String>? companieslist;
  companies() async {
    var companies = await FirebaseFirestore.instance
        .collection('Providers')
        .doc('companies')
        .get();
    var data = companies.data() as Map;
    List s = data['companies'] as List;
    List<String> l = [];
    s.forEach(
      (element) {
        Map elements = element;
        l.add(elements['companyEN']);
      },
    );
    setState(() {
      companieslist = l;
      loading = false;
      final validationService =
          Provider.of<ProductValidation>(context, listen: false);
      validationService.changeproductCategory("${companieslist?.first}");
    });
  }

  void change() {
    setState(() {
      _showContainer = _showContainer;
    });
  }

  void show() {
    setState(() {
      _showContainer = !_showContainer;
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final validationService =
        Provider.of<ProductValidation>(context, listen: false);

    String dropdownvalue = 'Catagory';
    String dropdownvalueStatus = 'Status';

    // List of items in our dropdown menu
    var items = [
      'Seeds',
      'Fertilizers',
      'Pesticides',
      'Mulchfilms',
      'Machinery',
      'Plant nutrition',
      'Organic products',
    ];
    var itemsStatus = [
      'offline',
      'both',
    ];
    var price = [
      'Show',
      'hide',
    ];
    var offer = [
      'false',
      'true',
    ];
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Product",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(children: [
                    Expanded(
                      child: Selector<ProductValidation, ValidationItem>(
                          selector: (buildContext, counterProvider) =>
                              counterProvider.nameEN,
                          builder: (context, data, child) {
                            // print("object");
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                onChanged: (String value) {
                                  validationService.changenameEN(value);
                                },
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 30.0, horizontal: 10.0),
                                    labelText: 'Product Name in English',
                                    errorText: validationService.nameEN.error,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                              ),
                            );
                          }),
                    ),
                    Expanded(
                      child: Selector<ProductValidation, ValidationItem>(
                          selector: (buildContext, counterProvider) =>
                              counterProvider.nameHN,
                          builder: (context, data, child) {
                            // print("object");
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                onChanged: (String value) {
                                  validationService.changenameHN(value);
                                },
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 30.0, horizontal: 10.0),
                                    labelText: 'Product Name in Hindi',
                                    errorText: validationService.nameHN.error,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                              ),
                            );
                          }),
                    ),
                  ]),
                  Row(
                    children: [
                      Expanded(
                        child: Selector<ProductValidation, ValidationItem>(
                            selector: (buildContext, counterProvider) =>
                                counterProvider.desEN,
                            builder: (context, data, child) {
                              // print("object");
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onChanged: (String value) {
                                    validationService.changedesEN(value);
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 30.0, horizontal: 10.0),
                                      labelText: 'Description in English',
                                      errorText: validationService.desEN.error,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                  maxLines: 5,
                                  minLines: 3,
                                ),
                              );
                            }),
                      ),
                      Expanded(
                        child: Selector<ProductValidation, ValidationItem>(
                            selector: (buildContext, counterProvider) =>
                                counterProvider.desHN,
                            builder: (context, data, child) {
                              // print("object");
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onChanged: (String value) {
                                    validationService.changedesHN(value);
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 30.0, horizontal: 10.0),
                                      labelText: 'Description in Hindi',
                                      errorText: validationService.desHN.error,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                  maxLines: 5,
                                  minLines: 3,
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Selector<ProductValidation, ValidationItem>(
                            selector: (buildContext, counterProvider) =>
                                counterProvider.technicalEN,
                            builder: (context, data, child) {
                              // print("object");
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onChanged: (String value) {
                                    validationService.changetechEN(value);
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 30.0, horizontal: 10.0),
                                      labelText: 'Technical in English',
                                      errorText: validationService.desEN.error,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                  maxLines: 5,
                                  minLines: 3,
                                ),
                              );
                            }),
                      ),
                      Expanded(
                        child: Selector<ProductValidation, ValidationItem>(
                            selector: (buildContext, counterProvider) =>
                                counterProvider.technicalHN,
                            builder: (context, data, child) {
                              // print("object");
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onChanged: (String value) {
                                    validationService.changetechHN(value);
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 30.0, horizontal: 10.0),
                                      labelText: 'Technical in Hindi',
                                      errorText: validationService.desHN.error,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                  maxLines: 5,
                                  minLines: 3,
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Selector<ProductValidation, ValidationItem>(
                              selector: (buildContext, counterProvider) =>
                                  counterProvider.productCategory,
                              builder: (context, data, child) {
                                // print("object");
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 30.0,
                                                horizontal: 10.0),
                                        labelText: 'Product Catagory',
                                        errorText: validationService
                                            .productCategory.error,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0))),
                                    // value: dropdownvalue,
                                    icon: const Icon(
                                        Icons.arrow_drop_down_circle_sharp),
                                    // iconSize: 42,
                                    items: items.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    onChanged: (String? newValue) {
                                      validationService
                                          .changeproductCategory(newValue!);
                                    },
                                  ),
                                );
                              },
                            ),
                            Selector<ProductValidation, ValidationItem>(
                                selector: (buildContext, counterProvider) =>
                                    counterProvider.company,
                                builder: (context, data, child) {
                                  // print("object");
                                  return Padding(
                                    key: Key(loading.toString()),
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 30.0,
                                                  horizontal: 10.0),
                                          labelText: 'Companies',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                      // value: dropdownvalue,
                                      icon: const Icon(
                                          Icons.arrow_drop_down_circle_sharp),
                                      // iconSize: 42,
                                      items: companieslist?.map((items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      onChanged: (String? newValue) {
                                        validationService
                                            .changecompany(newValue!);
                                      },
                                    ),
                                  );
                                }),
                            Row(children: [
                              Container(
                                width: size.width * 0.13,
                                child:
                                    Selector<ProductValidation, ValidationItem>(
                                  selector: (buildContext, counterProvider) =>
                                      counterProvider.status,
                                  builder: (context, data, child) {
                                    // print("object");
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 30.0,
                                                    horizontal: 10.0),
                                            labelText: 'Status',
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0))),
                                        // value: dropdownvalue,
                                        icon: const Icon(
                                            Icons.arrow_drop_down_circle_sharp),
                                        // iconSize: 42,
                                        items: itemsStatus.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                        onChanged: (String? newValue) {
                                          validationService
                                              .changestatus(newValue!);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                width: size.width * 0.13,
                                child:
                                    Selector<ProductValidation, ValidationItem>(
                                  selector: (buildContext, counterProvider) =>
                                      counterProvider.status,
                                  builder: (context, data, child) {
                                    // print("object");
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 30.0,
                                                    horizontal: 10.0),
                                            labelText: 'Price',
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0))),
                                        // value: dropdownvalue,
                                        icon: const Icon(
                                            Icons.arrow_drop_down_circle_sharp),
                                        // iconSize: 42,
                                        items: price.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                        onChanged: (String? newValue) {
                                          validationService
                                              .changepriceshow(newValue!);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                width: size.width * 0.13,
                                child:
                                    Selector<ProductValidation, ValidationItem>(
                                  selector: (buildContext, counterProvider) =>
                                      counterProvider.status,
                                  builder: (context, data, child) {
                                    // print("object");
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 30.0,
                                                    horizontal: 10.0),
                                            labelText: 'Offer',
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0))),
                                        // value: dropdownvalue,
                                        icon: const Icon(
                                            Icons.arrow_drop_down_circle_sharp),
                                        // iconSize: 42,
                                        items: offer.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                        onChanged: (String? newValue) {
                                          validationService
                                              .changeoffershow(newValue!);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ]),
                            Selector<ProductValidation, ValidationItem>(
                                selector: (buildContext, counterProvider) =>
                                    counterProvider.gst,
                                builder: (context, data, child) {
                                  // print("object");
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      onChanged: (String value) {
                                        validationService.changegst(value);
                                      },
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 30.0,
                                                  horizontal: 10.0),
                                          labelText: 'Gst',
                                          errorText:
                                              validationService.gst.error,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                    ),
                                  );
                                }),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Visibility(
                              visible: !_showContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton.icon(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: defaultPadding * 1.5,
                                      vertical: defaultPadding /
                                          (Responsive.isMobile(context)
                                              ? 2
                                              : 1),
                                    ),
                                  ),
                                  onPressed: () {
                                    show();
                                  },
                                  // onPressed: (!validationService.isValid)
                                  //     ? null
                                  //     : validationService.submitData,
                                  icon: const Icon(Icons.add),
                                  label: const Text("Add Option"),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !_showContainer,
                              child: Selector<ProductValidation,
                                      Map<String, Map<String, String>>?>(
                                  selector: (buildContext, counterProvider) =>
                                      counterProvider.maps1,
                                  builder: (context, data, child) {
                                    return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.25,
                                          child: ListView.builder(
                                              padding: const EdgeInsets.all(8),
                                              itemCount: validationService
                                                  .maps1!.values
                                                  .toList()
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Container(
                                                  height: 50,
                                                  margin: EdgeInsets.all(2),
                                                  child: Center(
                                                      child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Price: ${validationService.maps1!.values.toList()[index]['Price']}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          'Quantity: ${validationService.maps1!.values.toList()[index]['Quantity']}${validationService.maps1!.values.toList()[index]['Type']}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          'Stock: ${validationService.maps1!.values.toList()[index]['Stock']}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          'Discount: ${validationService.maps1!.values.toList()[index]['Discount']}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                      ),
                                                      // Expanded(
                                                      //   child: Text(
                                                      //     'Option Index: ${validationService.maps1!.values.toList()[index]['OptionIndex']}',
                                                      //     style: TextStyle(
                                                      //         fontSize: 14),
                                                      //   ),
                                                      // ),

                                                      Expanded(
                                                        child: IconButton(
                                                          icon: const Icon(Icons
                                                              .cancel_outlined),
                                                          color: Colors.red,
                                                          onPressed: () {
                                                            validationService.deleteOption(
                                                                validationService
                                                                    .maps1!.keys
                                                                    .toList()[
                                                                        index]
                                                                    .toString());
                                                            change();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                                );
                                              }),
                                        ));
                                  }),
                            ),
                            Visibility(
                              visible: _showContainer,
                              child: Column(
                                children: [
                                  const Option(),
                                  Selector<ProductValidation, bool>(
                                      selector:
                                          (buildContext, counterProvider) =>
                                              counterProvider.isValid1,
                                      builder: (context, data, child) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton.icon(
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    defaultPadding * 1.5,
                                                vertical: defaultPadding /
                                                    (Responsive.isMobile(
                                                            context)
                                                        ? 2
                                                        : 1),
                                              ),
                                            ),
                                            onPressed: () {
                                              show();
                                              validationService.submitOption();
                                            },
                                            // onPressed: (!validationService.isValid)
                                            //     ? null
                                            //     : validationService.submitOption(),
                                            icon: const Icon(Icons.add),
                                            label: const Text("Save"),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  //

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding * 1.5,
                              vertical: defaultPadding /
                                  (Responsive.isMobile(context) ? 2 : 1),
                            ),
                          ),
                          onPressed: pickPhotoFromGallery,
                          child: Text("Choose Images"),
                          // onPressed: (!validationService.isValid)
                          //     ? null
                          //     : validationService.submitData,
                        ),
                      ),
                      Center(
                        child: itemPhotosWidgetList.isEmpty
                            ? Center(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Center(
                                      child:
                                          Icon(Icons.photo_library_outlined)),
                                ),
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Wrap(
                                  spacing: 5.0,
                                  direction: Axis.horizontal,
                                  children: itemPhotosWidgetList,
                                  alignment: WrapAlignment.spaceEvenly,
                                  runSpacing: 10.0,
                                ),
                              ),
                      ),
                    ],
                  ),

                  Selector<ProductValidation, bool>(
                    selector: (buildContext, counterProvider) =>
                        counterProvider.isValid,
                    builder: (context, data, child) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding * 1.5,
                              vertical: defaultPadding /
                                  (Responsive.isMobile(context) ? 2 : 1),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              uploading ? null : await upload();

                              validationService.submitDownloadUrl(downloadUrl);
                              validationService.submitData(context);
                              Map map = {};
                              List l = [];
                              var provider = Provider.of<TabsProvider>(context,
                                  listen: false);
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
                                '',
                                '',
                                '',
                                '',
                                reset: true,
                              );
                              provider.switchtabs(0, context);
                            }
                          },
                          icon: const Icon(Icons.save_rounded),
                          label: const Text("Submit"),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Option extends StatelessWidget {
  const Option({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var itemsStatus = [
      'Gram',
      'Kgs',
      'Liters',
      'ML',
    ];
    final validationService =
        Provider.of<ProductValidation>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              width: 100,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                // value: dropdownvalue,
                icon: const Icon(Icons.arrow_drop_down_circle_sharp),
                // iconSize: 42,
                items: itemsStatus.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onChanged: (String? newValue) {
                  validationService.changetype(newValue!);
                },
              ),
            ),
          ),
          Selector<ProductValidation, ValidationItem>(
              selector: (buildContext, counterProvider) =>
                  counterProvider.quantity,
              builder: (context, data, child) {
                // print("object");
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      validationService.changequantity(value);
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 10.0),
                        labelText: 'Quantity',
                        errorText: validationService.quantity.error,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                );
              }),
          Selector<ProductValidation, ValidationItem>(
              selector: (buildContext, counterProvider) =>
                  counterProvider.quantity,
              builder: (context, data, child) {
                // print("object");
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      validationService.changeunits(value);
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 10.0),
                        labelText: 'Units',
                        errorText: validationService.quantity.error,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                );
              }),
          Selector<ProductValidation, ValidationItem>(
              selector: (buildContext, counterProvider) =>
                  counterProvider.quantity,
              builder: (context, data, child) {
                // print("object");
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      validationService.changecharges(value);
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 10.0),
                        labelText: 'Charges',
                        errorText: validationService.quantity.error,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                );
              }),
          Selector<ProductValidation, ValidationItem>(
              selector: (buildContext, counterProvider) =>
                  counterProvider.stock,
              builder: (context, data, child) {
                // print("object");
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value) {
                      validationService.changestock(value);
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 10.0),
                        labelText: 'Stock',
                        errorText: validationService.stock.error,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                );
              }),
          Selector<ProductValidation, ValidationItem>(
              selector: (buildContext, counterProvider) =>
                  counterProvider.price,
              builder: (context, data, child) {
                // print("object");
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      validationService.changeprice(int.parse(value));
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 10.0),
                        labelText: 'Price',
                        errorText: validationService.price.error,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                );
              }),
          Selector<ProductValidation, ValidationItem>(
              selector: (buildContext, counterProvider) =>
                  counterProvider.discount,
              builder: (context, data, child) {
                // print("object");
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (String value) {
                      validationService.changediscount(value);
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 10.0),
                        labelText: 'Discount',
                        errorText: validationService.discount.error,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omnath_agritech_web/responsive.dart';
import 'package:omnath_agritech_web/screens/dashboard/components/my_fields.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/header.dart';

import 'components/recent_files.dart';
import 'components/storage_details.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController companyEN = TextEditingController();
  TextEditingController companyHN = TextEditingController();
  List<Widget> itemPhotosWidgetList = <Widget>[];

  final ImagePicker _picker = ImagePicker();
  File? file;
  List<XFile>? photo = <XFile>[];
  List<XFile> itemImagesList = <XFile>[];

  List<String> downloadUrl = <String>[];
  var _showContainer;
  bool uploading = false;
  var name;
  Map? items;
  bool? loader;
  var _productId;

  pickPhotoFromGallery() async {
    photo = await _picker.pickMultiImage();
    if (photo != null) {
      setState(() {
        itemImagesList = itemImagesList + photo!;
        photo!.clear();
      });
      setState(() {
        loader = true;
      });
      upload();
    }
  }

  upload() async {
    String productId = await uplaodImageAndSaveItemInfo();
    setState(() {
      uploading = false;
    });
    return productId;
  }

  uplaodImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    PickedFile? pickedFile;

    for (int i = 0; i < itemImagesList.length; i++) {
      file = File(itemImagesList[i].path);
      pickedFile = PickedFile(file!.path);

      await uploadImageToStorage(pickedFile, 'productId', i);
    }
  }

  uploadImageToStorage(PickedFile? pickedFile, String productId, i) async {
    Reference reference =
        FirebaseStorage.instance.ref().child('companies/$name/$i');
    await reference.putData(
      await pickedFile!.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    String value = await reference.getDownloadURL();
    downloadUrl.add(value);
    FirebaseFirestore.instance.collection('Providers').doc('companies').set({
      'companies': FieldValue.arrayRemove([items]),
    }, SetOptions(merge: true));
    items?['icon'] = value;
    FirebaseFirestore.instance.collection('Providers').doc('companies').set({
      'companies': FieldValue.arrayUnion([items]),
    }, SetOptions(merge: true));
    setState(() {
      loader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List l = [];
    final Stream title = FirebaseFirestore.instance
        .collection('Providers')
        .doc('companies')
        .snapshots();
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: loader == true
            ? Center(child: CircularProgressIndicator(),)
            : StreamBuilder(
                stream: title,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading');
                  }
                  List l = snapshot.data['companies'];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width * 0.70,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: size.width * 0.30,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onChanged: (String value) {
                                    companyEN.text = value;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 30.0, horizontal: 10.0),
                                      labelText: 'type company name in English',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                  maxLines: 5,
                                  minLines: 3,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: size.width * 0.30,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onChanged: (String value) {
                                    companyHN.text = value;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 30.0, horizontal: 10.0),
                                      labelText: 'type company name in hindi',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                  maxLines: 5,
                                  minLines: 3,
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (companyEN.text.toString().length > 3 &&
                              companyHN.text.toString().length > 3) {
                            Map map = {
                              'companyEN': companyEN.text,
                              'companyHN': companyHN.text
                            };
                            l.add(map);
                            FirebaseFirestore.instance
                                .collection('Providers')
                                .doc('companies')
                                .set({
                              'companies': FieldValue.arrayUnion(l),
                            }, SetOptions(merge: true));
                          } else {
                            var snackBar =
                                SnackBar(content: Text('check fields'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        child: Text(
                          'Add company',
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text('Companies'),
                      Text(itemImagesList.isEmpty
                          ? 'empty'
                          : "${itemImagesList.length}"),
                      Container(
                        height: size.height * 0.7,
                        width: size.width * 0.5,
                        child: ListView.builder(
                            itemCount: l.length,
                            controller: ScrollController(),
                            itemBuilder: (context, index) {
                              return Container(
                                width: size.width * 0.7,
                                height: size.height * 0.4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                        child: Container(
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0.7)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6))),
                                      child: ListTile(
                                        title: Text(
                                         '${l[index]['companyEN']} \n${l[index]['companyHN']}',
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('Providers')
                                                .doc('companies')
                                                .set(
                                              {
                                                'companies':
                                                    FieldValue.arrayRemove(
                                                        [l[index]]),
                                              },
                                              SetOptions(merge: true),
                                            );
                                          },
                                          icon: Icon(Icons.close),
                                        ),
                                      ),
                                    )),
                                    Container(
                                        width: size.width * 0.14,
                                        height: size.height * 0.2,
                                        child: "${l[index]['icon']}" == "null"
                                            ? InkWell(
                                                onTap: () {
                                                  print(index);
                                                  setState(() {
                                                    name = l[index]['companyEN']
                                                        .toString()
                                                        .substring(1, 2);
                                                    items = l[index];
                                                  });
                                                  pickPhotoFromGallery();
                                                },
                                                child: Center(
                                                    child: Icon(
                                                  Icons.image_sharp,
                                                )),
                                              )
                                            : Image.network(l[index]['icon']))
                                  ],
                                ),
                              );
                            }),
                      )
                    ],
                  );
                },
              ),

        // Header(),
        // SizedBox(height: defaultPadding),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Expanded(
        //       flex: 5,
        //       child: Column(
        //         children: [
        //           MyFiles(),
        //           SizedBox(height: defaultPadding),
        //           RecentFiles(),
        //           if (Responsive.isMobile(context))
        //             SizedBox(height: defaultPadding),
        //           if (Responsive.isMobile(context)) StarageDetails(),
        //         ],
        //       ),
        //     ),
        //     if (!Responsive.isMobile(context))
        //       SizedBox(width: defaultPadding),
        //     // On Mobile means if the screen is less than 850 we dont want to show it
        //     if (!Responsive.isMobile(context))
        //       Expanded(
        //         flex: 2,
        //         child: StarageDetails(),
        //       ),
        //   ],
        // )
      ),
    );
  }
}

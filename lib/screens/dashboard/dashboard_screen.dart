import 'package:cloud_firestore/cloud_firestore.dart';
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
        child: StreamBuilder(
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
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 30.0, horizontal: 10.0),
                                labelText: 'type company name in English',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
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
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 30.0, horizontal: 10.0),
                                labelText: 'type company name in hindi',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
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
                      var snackBar = SnackBar(content: Text('check fields'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text(
                    'Add company',
                  ),
                ),
                SizedBox(height: 50,),
                Text('Companies'),
                Container(
                  height: size.height * 0.7,
                  width: size.width * 0.2,
                  child: ListView.builder(
                      itemCount: l.length,
                      itemBuilder: (context, index) {
                        print(l);
                        return GestureDetector(
                            child: Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.7)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          child: ListTile(
                            title: Text(
                              l[index]
                                  .toString()
                                  .replaceAll('}', '')
                                  .replaceAll('{', ''),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('Providers')
                                    .doc('companies')
                                    .set(
                                  {
                                    'companies':
                                        FieldValue.arrayRemove([l[index]]),
                                  },
                                  SetOptions(merge: true),
                                );
                              },
                              icon: Icon(Icons.close),
                            ),
                          ),
                        ));
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

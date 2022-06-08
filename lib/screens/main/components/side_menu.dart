import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omnath_agritech_web/constants.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../providers/tabs_provider.dart';

import 'package:omnath_agritech_web/screens/stock/stock_screen.dart';

class SideMenu extends StatefulWidget {
  SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final Stream<QuerySnapshot> title =
      FirebaseFirestore.instance.collection('title').snapshots();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TabsProvider>(context);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
            // child: StreamBuilder<QuerySnapshot>(
            //   stream: title,
            //   builder: (BuildContext context,
            //       AsyncSnapshot<QuerySnapshot> snapshot) {
            //     if (snapshot.hasError) {
            //       return Text('Something went wrong');
            //     }
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Text('Loading');
            //     }
            //     final data = snapshot.requireData;

            //     return ListView.builder(
            //         itemCount: data.size,
            //         itemBuilder: (context, index) {
            //           return Text(' ${data.docs[index]['name']}');
            //         });
            //   },
            // ),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {
              provider.switchtabs(0);
            },
          ),
           DrawerListTile(
            title: "Stock",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              provider.switchtabs(1);
            },
          ),
          DrawerListTile(
            title: "Transaction",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Task",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Documents",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Store",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Notification",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {},
          ),
         
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        
        onTap: press,
        
        horizontalTitleGap: 0.0,
        leading: SvgPicture.asset(
          svgSrc,
          color: Colors.white,
          height: 16,
        ),
        title: Text(
          title,
          style: TextStyle(color:blue),
        ),
      ),
    );
  }
}

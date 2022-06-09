import 'package:omnath_agritech_web/controllers/MenuController.dart';
import 'package:omnath_agritech_web/responsive.dart';
import 'package:omnath_agritech_web/screens/dashboard/dashboard_screen.dart';
import 'package:omnath_agritech_web/screens/stock/stock_screen.dart';
import 'package:omnath_agritech_web/screens/stock/add_stock.dart';
import 'package:omnath_agritech_web/screens/stock/update_stock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/tabs_provider.dart';
import './index.dart';

import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  indexclass ind = indexclass();

  final tabs = [StockScreen(), AddStock(), UpdateStock(), DashboardScreen()];

  @override
  Widget build(BuildContext context) {
    print(ind.index);
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              // child: tabs[ind.index],
              child: Consumer<TabsProvider>(
                builder: (_, data, __) {
                  return tabs[data.current];
                  // height: size.height * 0.87,
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:omnath_agritech_web/responsive.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:provider/provider.dart';
import '../../screens/main/providers/tabs_provider.dart';
import 'components/header.dart';
import 'components/update_product.dart';
import 'components/products.dart';

class UpdateStock extends StatefulWidget {
  @override
  State<UpdateStock> createState() => _UpdateStockState();
}

class _UpdateStockState extends State<UpdateStock> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TabsProvider>(context);
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(),
            SizedBox(height: 5),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {
                provider.switchtabs(0);
              },
              icon: const Icon(Icons.keyboard_backspace_sharp),
              label: const Text("Show Product"),
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      // MyFiles(),
                      SizedBox(height: defaultPadding),
                      // AddProduct(),
                      UpdateProduct(),

                      // Visibility(
                      //   visible: provider.show,
                      //   child: AddProduct(),
                      // ),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      // if (Responsive.isMobile(context)) StarageDetails(),
                    ],
                  ),
                ),
                // if (!Responsive.isMobile(context))
                //   SizedBox(width: defaultPadding),
                // // On Mobile means if the screen is less than 850 we dont want to show it
                // if (!Responsive.isMobile(context))
                //   Expanded(
                //     flex: 2,
                //     child: StarageDetails(),
                //   ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

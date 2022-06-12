import 'package:omnath_agritech_web/responsive.dart';
import 'package:flutter/material.dart';
import 'package:omnath_agritech_web/screens/stock/validator.dart';
import '../../constants.dart';
import 'package:provider/provider.dart';
import '../../screens/main/providers/tabs_provider.dart';
import 'components/header.dart';
import 'components/add_product.dart';
import 'components/products.dart';

class AddStock extends StatefulWidget {
  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
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
                Map map = {};
                List l = [];
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
                );
                provider.switchtabs(0, context);
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
                      AddProduct(),

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

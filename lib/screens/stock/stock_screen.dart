import 'package:omnath_agritech_web/responsive.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:provider/provider.dart';
import '../../screens/main/providers/tabs_provider.dart';
import 'components/header.dart';
import 'components/add_product.dart';
import 'components/products.dart';

class StockScreen extends StatefulWidget {
  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  var _show;
  @override
  void initState() {
    _show = false;

    super.initState();
  }

  void show() {
    setState(() {
      _show = !_show;
    });
  }

  void changeShow(value) {
    setState(() {
      _show = value;
    });
  }

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
                provider.change();
              },
              icon: provider.show
                  ? const Icon(Icons.arrow_back_sharp)
                  : const Icon(Icons.add),
              label: provider.show
                  ? const Text("Show Product")
                  : const Text("Add Product"),
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
                      Visibility(
                        visible: !provider.show,
                        child: Products(),
                      ),
                      Visibility(
                        visible: provider.show,
                        child: AddProduct(),
                      ),
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

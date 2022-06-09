import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../validator.dart';
import 'package:provider/provider.dart';
import 'package:omnath_agritech_web/responsive.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../stock_screen.dart';
import '../../main/providers/tabs_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class Products extends StatefulWidget {
  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            const Expanded(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SearchField(),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding * 1.5,
                    vertical:
                        defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                  ),
                ),
                onPressed: () {
                  // show();
                },
                icon: const Icon(Icons.filter_list_alt),
                label: const Text("Filter By"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding * 1.5,
                    vertical:
                        defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                  ),
                ),
                onPressed: () {
                  // show();
                },
                icon: const Icon(Icons.sort_outlined),
                label: const Text("Sort By"),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: size.height * 0.25,
            child: PaginateFirestore(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, documentSnapshots, index) {
                final data = documentSnapshots[index].data() as Map?;
                return ProductCard(
                  data: data,
                );
              },
              query: FirebaseFirestore.instance
                  .collection('Product')
                  .orderBy('nameEN'),
              itemBuilderType: PaginateBuilderType.gridView,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (size.width * 0.5 / size.height * 0.25),
              ),
              isLive: true,
            ),
          ),
        ),
      ]),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: bgColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, this.data}) : super(key: key);
  final data;
  firstImage() {
    List images = data['images'];
    // print(images.first.toString());
    return images.first.toString();
  }

  @override
  Widget build(BuildContext context) {
    final validationService =
        Provider.of<ProductValidation>(context, listen: false);
    var provider = Provider.of<TabsProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.02,
        vertical: size.height * 0.01,
      ),
      child: GestureDetector(
        onTap: () {
          validationService.changeForm(
              'data.reference.documentID}',
              data['nameEN'],
              data['nameHN'],
              data['desEN'],
              data['desHN'],
              data['productCategory'],
              data['status'],
              data['company'],
              data['gst'],
              data['searchKey'],
              data['displayOffer']);
          provider.switchtabs(2);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              color: Colors.grey.shade100),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.02,
              vertical: size.height * 0.01,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        data['nameEN'],
                        style: TextStyle(fontSize: 22, color: Colors.black),
                      ),
                      Text(
                        data['company'],
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      Text(
                        data['productCategory'],
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        child: OptimizedCacheImage(
                          imageUrl: "${firstImage()}",
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),

                          //  Image.network("${firstImage()}"),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

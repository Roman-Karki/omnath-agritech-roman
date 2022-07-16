import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../components/auto_text.dart';
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
        // Row(
        //   children: [
        //     const Expanded(
        //         child: Padding(
        //       padding: EdgeInsets.all(8.0),
        //       child: SearchField(),
        //     )),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: ElevatedButton.icon(
        //         style: TextButton.styleFrom(
        //           padding: EdgeInsets.symmetric(
        //             horizontal: defaultPadding * 1.5,
        //             vertical:
        //                 defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
        //           ),
        //         ),
        //         onPressed: () {
        //           // show();
        //         },
        //         icon: const Icon(Icons.filter_list_alt),
        //         label: const Text("Filter By"),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: ElevatedButton.icon(
        //         style: TextButton.styleFrom(
        //           padding: EdgeInsets.symmetric(
        //             horizontal: defaultPadding * 1.5,
        //             vertical:
        //                 defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
        //           ),
        //         ),
        //         onPressed: () {
        //           // show();
        //         },
        //         icon: const Icon(Icons.sort_outlined),
        //         label: const Text("Sort By"),
        //       ),
        //     ),
        //   ],
        // ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: size.height * 0.8,
            child: PaginateFirestore(
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
                  crossAxisCount: 3, childAspectRatio: 2),
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
    if (data['images'] == null) {
    } else {
      List images = data['images'];
      // print(images.first.toString());
      return images.first.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.3,
      width: size.width * 0.4,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.01,
          vertical: size.height * 0.01,
        ),
        child: GestureDetector(
          onTap: () {
            var validationService =
                Provider.of<ProductValidation>(context, listen: false);
            var provider = Provider.of<TabsProvider>(context, listen: false);
            validationService.changeForm(
              '${data['productID']}',
              '${data['nameEN']}',
              '${data['nameHN']}',
              '${data['desEN']}',
              '${data['desHN']}',
              '${data['productCategory']}',
              '${data['status']}',
              '${data['company']}',
              '${data['gst']}',
              '${data['searchKey']}',
              '${data['displayOffer']}',
              '${data['company']}',
              data['options'] as Map,
              data['images'],
              "${data['technicalHN']}",
              "${data['technicalEN']}",
              "${data['pricestatus']}",
              "${data['displayOffer']}",
            );
            provider.switchtabs(2, context);
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
              child: Container(
                width: size.width * 0.4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      //Autotext
                      child: Container(
                        width: size.width * 0.12,
                        height: size.height * 0.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoText(
                              showcolor: false,
                              height: size.height * 0.04,
                              maxline: 2,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                              text: '${data['nameEN']}',
                              width: size.width * 0.65,
                              centered: false,
                            ),
                            AutoText(
                              showcolor: false,
                              height: size.height * 0.03,
                              maxline: 2,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                              text: '${data['company']}',
                              width: size.width * 0.65,
                              centered: false,
                            ),
                            AutoText(
                              showcolor: false,
                              height: size.height * 0.03,
                              maxline: 2,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                              text: '${data['productCategory']}',
                              width: size.width * 0.65,
                              centered: false,
                            ),
                            AutoText(
                              showcolor: false,
                              height: size.height * 0.08,
                              maxline: 3,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                              text: '${data['desEN']}',
                              width: size.width * 0.65,
                              centered: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
                          child: Container(
                            height: size.height * 0.2,
                            width: size.width * 0.07,
                            child: OptimizedCacheImage(
                              imageUrl: "${firstImage()}",
                              placeholder: (context, url) => Center(
                                  child: Container(
                                      height: 50,
                                      width: 50,
                                      child: CircularProgressIndicator())),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

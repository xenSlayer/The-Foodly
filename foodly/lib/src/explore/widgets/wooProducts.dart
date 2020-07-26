import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodly/components/productTile.dart';
import 'package:foodly/models/product.dart';
import 'package:foodly/services/db_services.dart';

class WooProducts extends StatefulWidget {
  // final List<WooProduct> products;
  // WooProducts({
  //   @required this.products,
  // });
  @override
  _WooProductsState createState() => _WooProductsState();
}

class _WooProductsState extends State<WooProducts> {

  final ScrollController _scrollController = ScrollController();

  int perPage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      // child: FutureBuilder(
      //   future: _ecommerce.getWooProducts(1, perPage),
      //   builder:
      //       (BuildContext context, AsyncSnapshot<List<WooProduct>> snapshot) {
      //     switch (snapshot.connectionState) {
      //       case ConnectionState.none:
      //         return MyShimmer.shimCont(double.maxFinite);
      //         break;
      //       case ConnectionState.waiting:
      //         return MyShimmer.shimCont(double.maxFinite);
      //         break;
      //       case ConnectionState.active:
      //         return MyShimmer.shimCont(double.maxFinite);
      //         break;
      //       case ConnectionState.done:
      //         if (snapshot.data.isNotEmpty) {
      //           return ListView.separated(
      //             controller: _scrollController,
      //             separatorBuilder: (_, index) {
      //               return SizedBox(
      //                 height: 5.0,
      //               );
      //             },
      //             itemCount: snapshot.data.length,
      //             itemBuilder: (_, index) {
      //               WooProduct product = snapshot.data[index];
      //               return ProductTile(
      //                 product: product,
      //               );
      //             },
      //           );
      //         } else {
      //           return Container(
      //             child: Center(
      //               child: Text(
      //                 "Nothing Found",
      //                 style: TextStyle(color: black),
      //               ),
      //             ),
      //           );
      //         }
      //         break;
      //       default:
      //         return MyShimmer.shimCont(double.maxFinite);
      //     }
      //   },
      // ),
      // child: widget.products.isNotEmpty ? ListView.separated(
      //   controller: _scrollController,
      //   separatorBuilder: (_, index) {
      //     return SizedBox(
      //       height: 5.0,
      //     );
      //   },
      //   itemCount: widget.products.length,
      //   itemBuilder: (_, index) {
      //     WooProduct product = widget.products[index];
      //     return ProductTile(
      //       product: product,
      //     );
      //   },
      // ):MyShimmer.shimCont(double.maxFinite),
      child: StreamBuilder(
                          stream: productItemDb.streamList(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Product>> snapshot) {
                            if (snapshot.hasError)
                              return Container(
                                child: Center(
                                  child: Text("There was an error"),
                                ),
                              );
                            if (snapshot.hasData) {
                              var docList = snapshot.data;
                              if (docList.isEmpty) {
                                return Center(
                                    child: Text("No Products Available"));
                              }
                              return ListView.separated(
                                controller: _scrollController,
                                separatorBuilder: (_, i) {
                                  return SizedBox(
                                    height: 5.0,
                                  );
                                },
                                itemCount: docList.length,
                                itemBuilder: (_, i) {
                                  Product product = docList[i];
                                  return ProductTile(product: product);
                                },
                              );
                            }
                            return Center(
                              child: Text("..."),
                            );
                          },
                        ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodly/components/shimmering/myshimmer.dart';
import 'package:foodly/constants/colors.dart';
import 'package:foodly/models/product.dart';
import 'package:foodly/providers/cartProvider.dart';
import 'package:foodly/sharedPrefs/preferences.dart';
import 'package:foodly/utilities/utils.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';

class ProductDetail extends StatefulWidget {
  final Product wooProduct;
  ProductDetail({
    @required this.wooProduct,
  });

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _counter = 1;
  String _userID;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    if (_counter > 1)
      setState(() {
        _counter--;
      });
  }

  getUserId() async {
    _userID = await Prefs.getuserId();
    setState(() {});
  }

  void addToCart() {
    context
        .read<CartProvider>()
        .addToCart(widget.wooProduct, _userID, quantity: _counter);
  }

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double radius = 190;
    final double contHeight = 300;
    double width = MediaQuery.of(context).size.width;
    final CachedNetworkImage _cachedImage = CachedNetworkImage(
      imageUrl: widget.wooProduct.imageUrl,
      placeholder: (_, url) {
        return MyShimmer.shimCont(72, width: 72);
      },
      alignment: Alignment.center,
      fit: BoxFit.cover,
      errorWidget: (_, url, error) {
        return MyShimmer.shimCont(72, width: 72);
      },
    );

    final String description = widget.wooProduct.description;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Image
          Stack(
            children: <Widget>[
              Container(
                width: Utils.getWidthByPercentage(context, 100),
                height: contHeight,
                margin: EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  color: mainCol,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius),
                  ),
                  child: _cachedImage,
                ),
              ),
              Positioned(
                  top: 230,
                  left: 40,
                  child: CircularButton(child: '+', onTap: _incrementCounter)),
              Positioned(
                  top: 230,
                  right: 40,
                  child: CircularButton(
                    child: '-',
                    onTap: _decrementCounter,
                  )),
              Positioned(
                  top: 270,
                  left: width / 2 - 25,
                  child: CircularButton(child: _counter.toString())),

              // Back button
              Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context)))
            ],
          ),
          //Product name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
            child: Center(
              child: Text(
                "${widget.wooProduct.name}",
                style: TextStyle(
                    fontSize: 22.0,
                    color: mainCol,
                    fontWeight: FontWeight.w800),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          // Divider(
          //   color: mainCol,
          //   thickness: 1,
          //   indent: 30,
          //   endIndent: 30,
          // ),
          SizedBox(height: 20),

          // Variants
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 36),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: <Widget>[
          //       Text(
          //         "Variants: ",
          //         style: TextStyle(
          //             color: Colors.red,
          //             fontSize: 20,
          //             fontWeight: FontWeight.w700),
          //       ),
          //       SizedBox(height: 10),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: <Widget>[
          //           VariantBox(
          //             child: 'Veg: 120',
          //           ),
          //           VariantBox(
          //             child: 'Veg MoMo',
          //           ),
          //           VariantBox(
          //             child: 'Veg MoMo',
          //           ),
          //         ],
          //       )
          //     ],
          //   ),
          // ),
          SizedBox(height: 30),

          //Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Text(
              "Description:",
              style: TextStyle(
                  color: secondCol, fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 36.0, right: 8.0, top: 10.0),
            child: Text(
              "$description",
              style: TextStyle(fontSize: 12.0, color: thirdCol),
            ),
          ),
          // Divider(
          //   color: mainCol,
          //   thickness: 1,
          //   indent: 30,
          //   endIndent: 30,
          // ),

          //Price
          Container(
            child: Row(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(left: 36),
                //   child: Text(
                //     "Price:",
                //     style: TextStyle(
                //         color: secondCol,
                //         fontSize: 20,
                //         fontWeight: FontWeight.w700),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 5),
                //   child: RichText(
                //     text: TextSpan(
                //       children: <TextSpan>[
                //         widget.wooProduct.regularPrice.toString() != ""
                //             ? TextSpan(
                //                 text:
                //                     "$currency${widget.wooProduct.regularPrice} ",
                //                 style: TextStyle(
                //                     color: thirdCol,
                //                     fontSize: 16,
                //                     decoration: TextDecoration.lineThrough),
                //               )
                //             : TextSpan(),
                //         TextSpan(
                //           text: " $currency${widget.wooProduct.salePrice}",
                //           style: TextStyle(color: mainCol, fontSize: 16),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          // Divider(
          //   color: mainCol,
          //   thickness: 1,
          //   indent: 30,
          //   endIndent: 30,
          // ),

          //Back, counter and Add to cart
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(left: 30.0),
                //   child: GestureDetector(
                //     onTap: () {
                //       Navigator.pop(context);
                //     },
                //     child: Container(
                //       height: 45,
                //       width: 45,
                //       child: backIcon,
                //       color: mainCol,
                //     ),
                //   ),
                // ),
                // Container(
                //   child: Row(
                //     children: [
                //       GestureDetector(
                //         onTap: _decrementCounter,
                //         child: Container(
                //           width: 30,
                //           height: 45,
                //           decoration: BoxDecoration(
                //             border: Border.all(color: thirdCol),
                //           ),
                //           child: Center(child: Icon(Icons.remove)),
                //         ),
                //       ),
                //       Container(
                //         width: 45,
                //         height: 45,
                //         decoration: BoxDecoration(
                //           border: Border.all(color: thirdCol),
                //         ),
                //         child: Center(child: Text("$_counter")),
                //       ),
                //       GestureDetector(
                //         onTap: _incrementCounter,
                //         child: Container(
                //           width: 30,
                //           height: 45,
                //           decoration: BoxDecoration(
                //             border: Border.all(color: thirdCol),
                //           ),
                //           child: Center(child: Icon(Icons.add)),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // RaisedButton(
                //   color: mainCol,
                //   textColor: secondCol,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //         vertical: 30.0, horizontal: 15.0),
                //     child: Text(
                //       "Add to Cart",
                //       style: TextStyle(color: Colors.white),
                //     ),
                //   ),
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.only(
                //         topLeft: Radius.circular(40),
                //         bottomLeft: Radius.circular(40)),
                //   ),
                //   onPressed: () {
                //     context.read<CartProvider>().addToCart(
                //         widget.wooProduct, _userID,
                //         quantity: _counter);
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          child: Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              Icon(
                Icons.shopping_cart,
                size: 38,
                color: Colors.black,
              ),
              Container(
                width: 20,
                height: 20,
                child: Center(
                    child: Text(_counter.toString(),
                        style: TextStyle(fontSize: 11))),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(100)),
              ),
            ],
          ),
          onPressed: addToCart),
    );
  }
}

class CircularButton extends StatelessWidget {
  final String child;
  final Function onTap;

  const CircularButton({Key key, this.child, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: 50,
        height: 50,
        child: Center(
            child: Text("$child",
                style: TextStyle(color: Colors.black, fontSize: 25))),
        decoration: BoxDecoration(
            color: Colors.amber, borderRadius: BorderRadius.circular(100)),
      ),
    );
  }
}

class VariantBox extends StatelessWidget {
  final String child;

  const VariantBox({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 35,
      child: Container(
        padding: EdgeInsets.all(5),
        child: Center(
            child: Text('$child', style: TextStyle(color: Colors.black))),
      ),
      decoration: BoxDecoration(
          color: Colors.amber, borderRadius: BorderRadius.circular(8)),
    );
  }
}

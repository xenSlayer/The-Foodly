import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodly/components/shimmering/myshimmer.dart';
import 'package:foodly/constants/colors.dart';
import 'package:foodly/constants/icons.dart';
import 'package:foodly/constants/strings.dart';
import 'package:foodly/models/product.dart';
import 'package:foodly/providers/cartProvider.dart';
import 'package:foodly/sharedPrefs/preferences.dart';
import 'package:foodly/utilities/utils.dart';
import 'package:provider/provider.dart';

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

  getUserId()async{
    _userID = await Prefs.getuserId();
    setState(() {
    });
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

    final double radius = 30;
    final double contHeight = 250;
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
          Container(
            width: Utils.getWidthByPercentage(context, 100),
            height: contHeight,
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
          //Product name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
            child: Center(
              child: Text(
                "${widget.wooProduct.name}",
                style: TextStyle(fontSize: 28.0, color: mainCol),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Divider(
            color: thirdCol,
            thickness: 1,
            indent: 30,
            endIndent: 30,
          ),

          //Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Text(
              "Description:",
              style: TextStyle(color: secondCol, fontSize: 19),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 36.0, right: 8.0),
            child: Text(
              "$description",
              style: TextStyle(fontSize: 11.0, color: thirdCol),
            ),
          ),
          Divider(
            color: thirdCol,
            thickness: 1,
            indent: 30,
            endIndent: 30,
          ),
          //Price
          Container(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 36),
                  child: Text(
                    "Price:",
                    style: TextStyle(color: secondCol, fontSize: 19),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        widget.wooProduct.regularPrice.toString() != ""
                            ? TextSpan(
                                text:
                                    "$currency${widget.wooProduct.regularPrice} ",
                                style: TextStyle(
                                    color: thirdCol,
                                    fontSize: 16,
                                    decoration: TextDecoration.lineThrough),
                              )
                            : TextSpan(),
                        
                            TextSpan(
                                text:
                                    " $currency${widget.wooProduct.salePrice}",
                                style: TextStyle(color: mainCol, fontSize: 16),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: thirdCol,
            thickness: 1,
            indent: 30,
            endIndent: 30,
          ),
          //Back, counter and Add to cart
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      child: backIcon,
                      color: mainCol,
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _decrementCounter,
                        child: Container(
                          width: 30,
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(color: thirdCol),
                          ),
                          child: Center(child: Icon(Icons.remove)),
                        ),
                      ),
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(color: thirdCol),
                        ),
                        child: Center(child: Text("$_counter")),
                      ),
                      GestureDetector(
                        onTap: _incrementCounter,
                        child: Container(
                          width: 30,
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(color: thirdCol),
                          ),
                          child: Center(child: Icon(Icons.add)),
                        ),
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  color: mainCol,
                  textColor: secondCol,
                  child: Text("Add to Cart"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        bottomLeft: Radius.circular(40)),
                  ),
                  onPressed: () {
                    context.read<CartProvider>().addToCart(widget.wooProduct,_userID, quantity: _counter);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

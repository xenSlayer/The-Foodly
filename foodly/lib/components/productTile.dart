import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodly/components/productDetails.dart';
import 'package:foodly/components/shimmering/myshimmer.dart';
import 'package:foodly/constants/colors.dart';
import 'package:foodly/constants/icons.dart';
import 'package:foodly/constants/strings.dart';
import 'package:foodly/models/product.dart';
import 'package:foodly/providers/cartProvider.dart';
import 'package:foodly/sharedPrefs/preferences.dart';
import 'package:foodly/utilities/utils.dart';
import 'package:provider/provider.dart';

class ProductTile extends StatefulWidget {
  final Product product;
  ProductTile({
    @required this.product,
  });

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  String _userID;

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
  Widget build(BuildContext context) {
    final double wFC = Utils.getWidthByPercentage(context, 30);
    final double wSC = Utils.getWidthByPercentage(context, 52);
    final double wTC = Utils.getWidthByPercentage(context, 10);
    final double hPT = 110.0;

    final CachedNetworkImage _cachedImage = CachedNetworkImage(
      imageUrl: widget.product.imageUrl,
      placeholder: (_, url) {
        return MyShimmer.shimCont(72, width: 72);
      },
      alignment: Alignment.center,
      fit: BoxFit.cover,
      errorWidget: (_, url, error) {
        return MyShimmer.shimCont(72, width: 72);
      },
    );

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return ProductDetail(
            wooProduct: widget.product,
          );
        }));
      },
      child: Container(
        color: bgCol,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Image
            Container(
              height: hPT,
              width: wFC,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: _cachedImage,
            ),
            //Name, Description and Price
            Container(
              width: wSC,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "${widget.product.name}",
                      style: TextStyle(fontSize: 19.0, color: secondCol),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                    child: Text(
                      "$currency${widget.product.salePrice}",
                      style: TextStyle(fontSize: 16.0, color: mainCol),
                    ),
                  ),
                ],
              ),
            ),
            //Add to cart button
            Container(
              width: wTC,
              height: hPT,
              color: secondCol,
              child: Center(
                child: IconButton( 
                  icon: addIcon,
                  onPressed: () {
                    context.read<CartProvider>().addToCart(widget.product, _userID);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

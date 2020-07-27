import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodly/components/shimmering/myshimmer.dart';
import 'package:foodly/constants/colors.dart';
import 'package:foodly/constants/icons.dart';
import 'package:foodly/constants/strings.dart';
import 'package:foodly/models/cartItem.dart';
import 'package:foodly/providers/cartProvider.dart';
import 'package:foodly/utilities/utils.dart';
import 'package:provider/provider.dart';

class CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  // final String userId;
  final int index;
  CartItemTile({
    @required this.cartItem,
    @required this.index,
    // @required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final double wTC = Utils.getWidthByPercentage(context, 10);
    final String imageUrl = cartItem.imageUrl;
    final int price = cartItem.price;
    final String name = cartItem.name;
    final int quantity = cartItem.quantity;

    final CachedNetworkImage _cachedImage = CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (_, url) {
        return MyShimmer.shimCont(72, width: 72);
      },
      alignment: Alignment.center,
      fit: BoxFit.cover,
      errorWidget: (_, url, error) {
        return MyShimmer.shimCont(72, width: 72);
      },
    );

    final double height = Utils.getHeightByPercentage(context, 15);

    return Container(
      margin: EdgeInsets.all(8),
      height: height,
      child: Row(
        children: [
          //photo
          Badge(
            badgeColor: secondCol,
            badgeContent: Text(
              "$quantity",
              style: TextStyle(color: mainCol, fontSize: 11),
            ),
            child: Container(
              height: height - 5,
              width: Utils.getWidthByPercentage(context, 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: _cachedImage,
            ),
          ),
          //name-quantity , variation
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 13.0, right: 4.0),
                  child: Text(
                    "$name",
                    style: TextStyle(fontSize: 16.0, color: secondCol),
                  ),
                ),
                //price,
                Padding(
                  padding: const EdgeInsets.only(left: 13.0, top: 8.0),
                  child: Text(
                    "$quantity *$currency $price",
                    style: TextStyle(fontSize: 12.0, color: mainCol),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 13.0, top: 0.0),
                  child: Text(
                    "= $currency ${quantity * price}",
                    style: TextStyle(fontSize: 12.0, color: mainCol),
                  ),
                ),
              ],
            ),
          ),

          //Delete
          Container(
            width: wTC,
            height: height,
            color: secondCol,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  iconSize: 20,
                  icon: Icon(
                    cartaddIcon,
                    color: mainCol,
                  ),
                  onPressed: () {
                    context.read<CartProvider>().incrementCart(cartItem);
                  },
                ),
                IconButton(
                  iconSize: 24,
                  icon: Icon(
                    cartminusIcon,
                    color: mainCol,
                  ),
                  onPressed: () {
                    context.read<CartProvider>().decrementCart(cartItem);
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

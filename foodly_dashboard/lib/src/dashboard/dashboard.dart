import 'package:flutter/material.dart';
import 'package:foodly_dashboard/components/appbar.dart';
import 'package:foodly_dashboard/constants/colors.dart';
import 'package:foodly_dashboard/constants/icons.dart';
import 'package:foodly_dashboard/constants/styles.dart';
import 'package:foodly_dashboard/models/category.dart';
import 'package:foodly_dashboard/models/product.dart';
import 'package:foodly_dashboard/services/db_services.dart';
import 'package:foodly_dashboard/src/dashboard/widget/dashTile.dart';
import 'package:foodly_dashboard/utilities/utils.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: dashboardIcon,
        title: Text(
          "Foodly Dashboard",
          style: appTitleStyle,
        ),
        centerTitle: false,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Orders, Products, Add Products, Processing Orders
            Container(
              // height: Utils.getHeightByPercentage(context, 50),
              width: Utils.getWidthByPercentage(context, 100),
              margin: EdgeInsets.all(10),
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  //Orders Tile
                  DashTile(
                    routeName: "/dashOrders",
                    icon: orderIcon,
                    name: "ORDERS",
                  ),
                  DashTile(
                    routeName: "/dashProducts",
                    icon: Icons.fastfood,
                    name: "PRODUCTS",
                  ),
                  DashTile(
                    routeName: "/dashCarts",
                    icon: Icons.shopping_cart,
                    name: "CARTS",
                  ),
                  DashTile(
                    routeName: "/dashCategories",
                    icon: Icons.category,
                    name: "CATEGORIES",
                  ),
                ],
              ),
            ),
            // //Total Sales
            // Padding(
            //   padding: const EdgeInsets.only(left: 25.0, top: 25.0, bottom: 5),
            //   child: Text(
            //     "TOTAL SALES",
            //     style: TextStyle(fontSize: 20.0, color: mainCol),
            //   ),
            // ),
            // //TSA
            // Padding(
            //   padding: const EdgeInsets.only(left: 25.0, top: 5.0, bottom: 5),
            //   child: Text(
            //     "NRs. 1000",
            //     style: TextStyle(fontSize: 20.0, color: secondCol),
            //   ),
            // ),
            //PRODUCT COUNT
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 25.0, bottom: 5),
              child: Text(
                "PRODUCT COUNT",
                style: TextStyle(fontSize: 20.0, color: mainCol),
              ),
            ),
            //PC
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 5.0, bottom: 5),
              child: StreamBuilder(
                stream: productItemDb.streamList(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Product>> snapshot) {
                  if (snapshot.hasError)
                    return Text(
                      "0",
                      style: TextStyle(fontSize: 20.0, color: secondCol),
                    );
                  if (snapshot.hasData) {
                    var docList = snapshot.data;
                    if (docList.isEmpty) {
                      return Text(
                        "0",
                        style: TextStyle(fontSize: 20.0, color: secondCol),
                      );
                    }

                    return Text(
                      "${docList.length}",
                      style: TextStyle(fontSize: 20.0, color: secondCol),
                    );
                  }
                  return Text(
                    "...",
                    style: TextStyle(fontSize: 20.0, color: secondCol),
                  );
                },
              ),
            ),
            //Category COUNT
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 25.0, bottom: 5),
              child: Text(
                "CATEGORY COUNT",
                style: TextStyle(fontSize: 20.0, color: mainCol),
              ),
            ),
            //PC
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 5.0, bottom: 5),
              child: StreamBuilder(
                stream: categoryItemDb.streamList(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Category>> snapshot) {
                  if (snapshot.hasError)
                    return Text(
                      "0",
                      style: TextStyle(fontSize: 20.0, color: secondCol),
                    );
                  if (snapshot.hasData) {
                    var docList = snapshot.data;
                    if (docList.isEmpty) {
                      return Text(
                        "0",
                        style: TextStyle(fontSize: 20.0, color: secondCol),
                      );
                    }

                    return Text(
                      "${docList.length}",
                      style: TextStyle(fontSize: 20.0, color: secondCol),
                    );
                  }
                  return Text(
                    "...",
                    style: TextStyle(fontSize: 20.0, color: secondCol),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

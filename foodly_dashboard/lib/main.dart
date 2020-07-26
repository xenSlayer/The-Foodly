import 'package:flutter/material.dart';
import 'package:foodly_dashboard/src/dashboard/dashCarts.dart/dashCarts.dart';
import 'package:foodly_dashboard/src/dashboard/dashCategories/dashCategories.dart';
import 'package:foodly_dashboard/src/dashboard/dashOrders/dashOrders.dart';
import 'package:foodly_dashboard/src/dashboard/dashProducts/dashProducts.dart';
import 'package:foodly_dashboard/src/dashboard/dashboard.dart';


void main() {
  runApp(
    App(),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Foodly Dashboard",
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/":(_) => Dashboard(),
        "/dashboard":(_) => Dashboard(),
        "/dashOrders":(_) => DashOrders(),
        "/dashCategories":(_) => DashCategories(),
        "/dashProducts":(_) => DashProducts(),
        "/dashCarts":(_) => DashCarts(),
      },
    );
  }
}

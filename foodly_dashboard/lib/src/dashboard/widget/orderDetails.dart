import 'package:flutter/material.dart';
import 'package:foodly_dashboard/components/appbar.dart';
import 'package:foodly_dashboard/constants/colors.dart';
import 'package:foodly_dashboard/constants/icons.dart';
import 'package:foodly_dashboard/constants/strings.dart';
import 'package:foodly_dashboard/constants/styles.dart';
import 'package:foodly_dashboard/models/order.dart';
import 'package:foodly_dashboard/utilities/utils.dart';

class OrderDetails extends StatelessWidget {
  final Order order;
  OrderDetails({@required this.order});
  @override
  Widget build(BuildContext context) {
    Widget dataDetailView(String first, String second) => Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 25.0, top: 15.0, bottom: 5),
                child: Text(
                  first,
                  style: TextStyle(fontSize: 20.0, color: mainCol),
                ),
              ),
              //TSA
              Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 5.0, bottom: 5),
                child: Text(
                  second,
                  style: TextStyle(fontSize: 20.0, color: secondCol),
                ),
              ),
            ],
          ),
        );
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: backIcon,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Order Details",
          style: appTitleStyle,
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Date, id
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25.0, top: 5.0, bottom: 5),
                    child: Text(
                      "${Utils.getFirstInitials(order.orderDate.toString())} #${order.id}",
                      style: TextStyle(fontSize: 16.0, color: black),
                    ),
                  ),
                  //emailAdress
                  dataDetailView("Email Address:", "${order.emailAddress}"),
                  //order Status
                  dataDetailView("Order Status:", "${order.orderState}"),
                  //order Items
                  //order total
                  dataDetailView(
                      "Order Total:", "$currency ${order.totalAmount}"),
                  //contact number
                  dataDetailView("Contact Number:", "${order.mobileNumber}"),
                  //billing address
                  dataDetailView(
                      "Billing Address:", "${order.deliveryAddress}"),
                  //coupon
                  order.coupon != "" ? dataDetailView("Coupon:", "${order.coupon}"): Container(),
                  //special note
                  order.specialNote != "" ?dataDetailView("Special Note:", "${order.specialNote}"):Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
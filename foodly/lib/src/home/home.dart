import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:foodly/constants/colors.dart';
import 'package:foodly/constants/icons.dart';
import 'package:foodly/models/cartItem.dart';
import 'package:foodly/services/db_services.dart';
import 'package:foodly/sharedPrefs/preferences.dart';
import 'package:foodly/src/cart/cart.dart';
import 'package:foodly/src/explore/explore.dart';
import 'package:foodly/src/orders/myOrders.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController _pageController;
  int _page = 0;
  String _userID;

  getUserId() async {
    _userID = await Prefs.getuserId();
    setState(() {});
  }

  @override
  void initState() {
    _pageController = PageController();
    getUserId();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      getUserId();
      _page = page;
    });
  }

  void navigationTapped(int page) {
    getUserId();
    _pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          Explore(),
          MyOrders(
            userID: _userID,
          ),
          Cart(),
        ],
        controller: _pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: mainCol,
        currentIndex: _page,
        onTap: navigationTapped,
        type: BottomNavigationBarType.shifting,
        selectedItemColor: secondCol,
        unselectedItemColor: bgCol,
        items: [
          BottomNavigationBarItem(
            icon: Icon(exploreIcon),
            title: Text("Explore"),
            backgroundColor: mainCol,
          ),
          BottomNavigationBarItem(
            icon: Icon(orderIcon),
            title: Text("Orders"),
            backgroundColor: mainCol,
          ),
          BottomNavigationBarItem(
            icon: Badge(
              badgeColor: secondCol,
              badgeContent: _userID == null
                  ? Text(
                      "0",
                      style: TextStyle(fontSize: 10.0),
                    )
                  : StreamBuilder(
                      stream: cartItemDb.streamListByUserId(_userID),
                      builder: (_, AsyncSnapshot<List<CartItem>> snapshot) {
                        if (snapshot.hasData) {
                          var docList = snapshot.data;
                          return Text(
                            "${docList.length}",
                            style: TextStyle(fontSize: 10.0),
                          );
                        }
                        return Text(
                          "0",
                          style: TextStyle(fontSize: 10.0),
                        );
                      },
                    ),
              child: Icon(cartIcon),
            ),
            title: Text("Cart"),
            backgroundColor: mainCol,
          ),
        ],
      ),
    );
  }
}

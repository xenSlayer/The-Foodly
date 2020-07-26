import 'package:flutter/material.dart';
import 'package:foodly/components/appbar.dart';
import 'package:foodly/constants/colors.dart';
import 'package:foodly/constants/icons.dart';
import 'package:foodly/src/explore/widgets/allCategories.dart';
import 'package:foodly/src/explore/widgets/mybanner.dart';
import 'package:foodly/src/explore/widgets/searchBar.dart';
import 'package:foodly/src/explore/widgets/userCircle.dart';
import 'package:foodly/src/explore/widgets/allProducts.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  bool showSearch;
  String _location = "";
  getLocation() async {
    _location = "Nepalgunj";
    setState(() {});
  }

  @override
  void initState() {
    showSearch = false;
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: Container(
          decoration: BoxDecoration(
            color: mainCol,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: searchIcon,
            onPressed: () {
              setState(() {
                showSearch = !showSearch;
              });
            },
          ),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: thirdCol,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: locationIcon,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      _location,
                      style: TextStyle(color: mainCol, fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 8.0),
                child: downArrowIcon,
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          UserCircle(),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 95,
            backgroundColor: bgCol,
            flexibleSpace: FlexibleSpaceBar(
              background: MyBanner(),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //search
                  showSearch ? SearchBar() : Container(),
                  //categories
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0, top: 5.0, bottom: 5),
                    child: Text(
                      "Categories",
                      style: TextStyle(fontSize: 20.0, color: secondCol),
                    ),
                  ),
                  AllCategories(),
                  //products
                  Flexible(
                    child: AllProducts(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

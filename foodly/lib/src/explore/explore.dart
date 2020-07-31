import 'package:flutter/material.dart';
import 'package:foodly/components/appbar.dart';
import 'package:foodly/constants/colors.dart';
import 'package:foodly/constants/icons.dart';
import 'package:foodly/sharedPrefs/preferences.dart';
import 'package:foodly/src/explore/widgets/allCategories.dart';
import 'package:foodly/src/explore/widgets/mySlider.dart';
import 'package:foodly/src/explore/widgets/userCircle.dart';
import 'package:foodly/src/explore/widgets/allProducts.dart';
import 'package:geolocator/geolocator.dart';

import '../../constants/colors.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  // bool showSearch;
  Position _currentPosition;
  String _currentAddress = "";
  String _exactLocation = "";
  // String _location = "Nepalgunj";
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  _getMyCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatitudeLongitude();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatitudeLongitude() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.subLocality},${place.locality}";
        _exactLocation =
            "${place.subLocality}, ${place.locality}, ${place.postalCode},${place.subAdministrativeArea}, ${place.country}, ${place.position}";
            Prefs.saveDeciceAddress(_exactLocation);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // showSearch = false;
    _getMyCurrentLocation();
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
              // setState(() {
              //   showSearch = !showSearch;
              // });
              Navigator.of(context).pushNamed("/searchScreen");
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
                      _currentAddress,
                      style: TextStyle(color: mainCol, fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              // Container(
              //   alignment: Alignment.centerRight,
              //   padding: const EdgeInsets.only(right: 8.0),
              //   child: downArrowIcon,
              // ),
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
            expandedHeight: 200,
            backgroundColor: bgCol,
            flexibleSpace: FlexibleSpaceBar(
              background: MySlider(),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //search
                  // showSearch ? SearchBar() : Container(),
                  // //slider
                  // MySlider(),
                  //categories
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 17.0, bottom: 17.0),
                    child: Text(
                      "Categories",
                      style: TextStyle(
                          fontSize: 25.0,
                          color: mainCol,
                          fontWeight: FontWeight.w700),
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

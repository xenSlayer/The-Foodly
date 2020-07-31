import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:foodly/models/caroSlide.dart';
import 'package:foodly/services/db_services.dart';
import 'package:foodly/utilities/utils.dart';

class MySlider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: caroSlideItemDb.streamList(),
      builder: (_, AsyncSnapshot<List<CaroSlide>> snapshot) {
        if (snapshot.hasError) {
          return Container();
        }
        if (snapshot.hasData) {
          var docList = snapshot.data;
          if (docList.isEmpty) {
            return Container();
          }
          return CarouselSlider(
            height: 200.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 0.8,
            // items: [
            //   Slide(
            //     imgUrl: imageUrl,
            //     heading: "Foodly offer",
            //     subHeading: "10% off on first order",
            //   ),
            //   Slide(
            //     imgUrl: imageUrl,
            //     heading: "Usable Flower for Health",
            //     subHeading:
            //         "Lorem Ipsum is simply dummy text use for printing and type script",
            //   ),
            //   Slide(
            //     imgUrl: imageUrl,
            //   ),
            // ],
            items: docList.map((caroSlide){
              return Slide(
                imgUrl: caroSlide.imageUrl,
                heading: caroSlide.heading,
                subHeading: caroSlide.subHeading,
              );
            }).toList(),
          );
        }
        return Container();
      },
    );
  }
}

class Slide extends StatelessWidget {
  final String imgUrl;
  final String heading;
  final String subHeading;
  Slide({this.heading, this.imgUrl, this.subHeading});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      width: Utils.getWidthByPercentage(context, 80),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          // image: AssetImage('assets/images/slide1.jpg'),
          image: CachedNetworkImageProvider(imgUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          heading != null
              ? Text(
                  heading,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                )
              : Container(),
          subHeading != null
              ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    subHeading,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

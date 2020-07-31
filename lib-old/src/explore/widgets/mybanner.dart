import 'package:flutter/material.dart';
import 'package:foodly/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class MyBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
              width: double.maxFinite,
              height: 95,
              margin: EdgeInsets.only(left:16, right: 16, top: 5),
              color: mainCol,
              child: Padding(
                padding: const EdgeInsets.only(left: 37.0, top: 10.0),
                child: RichText(
                    text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "Apply Coupon",
                      style: GoogleFonts.roboto(
                        fontSize: 29.0,
                      ),
                    ),
                    TextSpan(
                      text: "\nFind on facebook page",
                      style: GoogleFonts.robotoMono(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                )),
              ),
            );
  }
}
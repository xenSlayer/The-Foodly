import 'package:flutter/material.dart';
import 'package:foodly/components/cachedImage/cachedImage.dart';
import 'package:foodly/components/productCategoryDetail.dart';
import 'package:foodly/constants/colors.dart';
import 'package:foodly/models/category.dart';
import 'package:foodly/utilities/utils.dart';

import '../constants/colors.dart';

class ProductCategoryTile extends StatelessWidget {
  final Category productCategory;
  ProductCategoryTile({
    this.productCategory,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return ProductCategoryDetail(category: productCategory);
        }));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 11.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.23,
          height: MediaQuery.of(context).size.height * 0.07,
          //color: mainCol,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 0.6, color: mainCol),
            color: bgCol,
            boxShadow: [
              BoxShadow(
                color: secondCol.withOpacity(0.08),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(2, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              //Image
              SizedBox(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CachedImage(
                      productCategory.imageUrl,
                      fit: BoxFit.cover,
                      isRound: false,
                      height: 60.0,
                      width: 60.0,
                    ),
                  ),
                ),
              ),
              //name with count
              SizedBox(
                height: 4.0,
              ),
              Text(
                "${Utils.getFirstInitials(productCategory.name)}",
                style: TextStyle(
                  color: secondCol,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

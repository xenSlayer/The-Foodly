import 'package:flutter/material.dart';
import 'package:foodly/components/cachedImage/cachedImage.dart';
import 'package:foodly/components/productCategoryDetail.dart';
import 'package:foodly/constants/colors.dart';
import 'package:foodly/models/category.dart';
import 'package:foodly/utilities/utils.dart';

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
      child: Container(
        width: Utils.getWidthByPercentage(context, 23),
        height: 100,
        color: Colors.grey[200],
        child: Column(
          children: [
            //Image
            SizedBox(
              width: 72,
              height: 72,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedImage(
                  productCategory.imageUrl,
                  fit: BoxFit.cover,
                  isRound: false,
                  width: 72,
                  height: 72,
                ),
              ),
            ),
            //name with count
            Text(
              "${Utils.getFirstInitials(productCategory.name)}",
              style: TextStyle(
                color: secondCol,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

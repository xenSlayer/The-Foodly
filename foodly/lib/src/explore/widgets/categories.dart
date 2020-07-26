import 'package:flutter/material.dart';
import 'package:foodly/components/productCategoryTile.dart';
import 'package:foodly/models/category.dart';
import 'package:foodly/services/db_services.dart';

class Categories extends StatelessWidget {
  // final List<WooProductCategory> categories;
  // Categories({@required this.categories});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 10),
      // child: categories.isNotEmpty ? ListView.separated(
      //           scrollDirection: Axis.horizontal,
      //           separatorBuilder: (_, index) {
      //             return SizedBox(
      //               width: 1.0,
      //             );
      //           },
      //           itemCount: categories.length,
      //           itemBuilder: (_, index) {
      //             WooProductCategory productCategory = categories[index];
      //             return ProductCategoryTile(
      //               productCategory: productCategory,
      //             );
      //           },
      //         ):MyShimmer.shimCont(100),
      child: StreamBuilder(
        stream: categoryItemDb.streamList(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          if (snapshot.hasError)
            return Container(
              child: Center(
                child: Text("There was an error"),
              ),
            );
          if (snapshot.hasData) {
            var docList = snapshot.data;
            if (docList.isEmpty) {
              return Center(child: Text("No Categories Available"));
            }
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                Category category = docList[i];
                return ProductCategoryTile(
                  productCategory: category,
                );
              },
              separatorBuilder: (_, i) {
                return SizedBox(
                    width: 1.0,
                  );
              },
              itemCount: docList.length,
            );
          }
          return Center(
            child: Text("..."),
          );
        },
      ),
    );
  }
}

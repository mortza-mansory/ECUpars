import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/api/ApiCategory.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/treeView/IssusScreen.dart';

final categoryController = Get.find<CategoryController>();
Widget IssusContainer(

    double w,
    double h,
    LangController langController,
    ThemeController themeController, {
      required String title,
      required String date,
      required int categoryId,
    }) {
  return Container(
    width: w * 0.9,
    height: h * 0.15,
    margin: EdgeInsets.only(bottom: h * 0.02),
    decoration: BoxDecoration(
      color: Colors.grey.shade600.withOpacity(0.7),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        w * 0.02,
        h * 0.018,
        w * 0.04,
        h * 0.00,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!langController.isRtl)
                Text(
                  title,
                  style: TextStyle(
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkTheme.value
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
            ],
          ),
          //    SizedBox(height: h * 0.07),
          // Row(
          //   children: [
          //     Text(
          //       date,
          //       style: TextStyle(
          //         color: themeController.isDarkTheme.value
          //             ? Colors.white70
          //             : Colors.black54,
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(height: h * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(w*0.08, h*0.06),
                  backgroundColor: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {
                  Get.to(() => Issusscreen(issueId: categoryId));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "View",
                        style: TextStyle(
                          fontFamily: "Sarbaz",
                          fontSize: w * 0.035,
                          color: themeController.isDarkTheme.value ? Colors.black : Colors.white,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

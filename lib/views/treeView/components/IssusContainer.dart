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
    margin: EdgeInsets.only(bottom: h * 0.02),
    decoration: BoxDecoration(
      color: Colors.grey.shade600.withOpacity(0.7),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: h * 0.02),
        Text(
          title,
          style: TextStyle(
            fontSize: w * 0.04,
            fontWeight: FontWeight.bold,
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),

        SizedBox(height: h * 0.02),
        SizedBox(
          width: w * 0.3,
          height: h * 0.06,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(w * 0.08, h * 0.06),
              backgroundColor: themeController.isDarkTheme.value ? Colors.white : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            onPressed: () {
              Get.to(() => Issusscreen(issueId: categoryId));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "View".tr,
                  style: TextStyle(
                    fontFamily: "Sarbaz",
                    fontSize: w * 0.035,
                    color: themeController.isDarkTheme.value ? Colors.black : Colors.white,
                  ),
                ),
                SizedBox(width: w * 0.02),
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: h * 0.02),
      ],
    ),
  );
}

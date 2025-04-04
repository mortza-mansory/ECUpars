import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/api/ApiCategory.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

final categoryController = Get.find<CategoryController>();

Widget CategoryContainer(
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
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AutoSizeText(
          title,
          style: TextStyle(
            fontSize: w * 0.04,
            fontWeight: FontWeight.bold,
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: h * 0.02),
        SizedBox(
          width: w * 0.3,
          height: h * 0.06,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(w * 0.08, h * 0.06),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              foregroundColor: Colors.red,
              splashFactory: InkSparkle.splashFactory,
            ),
            onPressed: () async {
              await Future.delayed(const Duration(milliseconds: 450));
              categoryController.navigateToCategoryDetails(categoryId);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "View".tr,
                  style: TextStyle(
                    fontFamily: "Sarbaz",
                    fontSize: w * 0.035,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: w * 0.02),
                Icon(
                  size: w * 0.045,
                  Icons.arrow_forward,
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
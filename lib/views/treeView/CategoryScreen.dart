import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/api/ApiCategory.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/home/homeScreen.dart';
import 'package:treenode/views/treeView/components/container.dart';

class GenericCategoryScreen extends StatelessWidget {
  final int categoryId;
  final bool isRoot;

  GenericCategoryScreen({required this.categoryId, this.isRoot = false});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<CategoryController>();
    final themeController = Get.find<ThemeController>();
    final langController = Get.find<LangController>();

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    categoryController.loadCategoryDetails(categoryId);

    return WillPopScope(
      onWillPop: () async {
        showConfirmationDialog(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: themeController.isDarkTheme.value
              ? const Color.fromRGBO(44, 45, 49, 1)
              : const Color.fromRGBO(255, 250, 244, 1),
          iconTheme: IconThemeData(
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
          elevation: 0,
          leading: IconButton(
            onPressed: () => categoryController.navigateBack(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Obx(
                () => Text(
              categoryController.category['name'] ?? (isRoot ? 'Main Categories' : 'Sub Category'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
              ),
            ),
          ),
          centerTitle: false,
        ),
        body: Obx(
              () {
            if (categoryController.category.isEmpty) {
              return _buildLoadingScreen(themeController);
            }

            final categoryData = categoryController.category;
            final relatedCategories = categoryController.relatedCategories;
            final issues = categoryController.issues;
            print("Current root: ${categoryId}");
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (relatedCategories.isNotEmpty) ...[
                      _buildSectionHeader("Related Categories", themeController, w),
                      ...relatedCategories.map((category) {
                        return buildItemContainer(
                          w,
                          h,
                          langController,
                          themeController,
                          title: category['name'] ?? "Unnamed",
                          date: category['created_at'] ?? "Unknown",
                          categoryId: category['id'],
                        );
                      }).toList(),
                    ],
                    if (issues.isNotEmpty) ...[
                      _buildSectionHeader("Issues", themeController, w),
                      ...issues.map((issue) {
                        return buildItemContainer(
                          w,
                          h,
                          langController,
                          themeController,
                          title: issue['title'] ?? "Unnamed",
                          date: issue['created_at'] ?? "Unknown",
                          categoryId: issue['id'],
                        );
                      }).toList(),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeController themeController, double w) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildLoadingScreen(ThemeController themeController) {
    return Center(
      child: CircularProgressIndicator(
        color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
      ),
    );
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'.tr),
          content: Text('Do you really want to go back to the home screen?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Get.offAll(() => Homescreen());
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

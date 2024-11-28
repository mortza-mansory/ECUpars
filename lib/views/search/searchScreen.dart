import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/api/ApiController.dart';
import 'package:treenode/controllers/auth/LoginController.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/NavigationController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final NavigationController navigationController =
  Get.put(NavigationController());
  final ThemeController themeController = Get.find<ThemeController>();
  final LangController langController = Get.find<LangController>();
  final ApiController apiController = Get.put(ApiController());
  final LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (!loginController.isLoggedIn.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (apiController.pngAssetsList.isEmpty) {
            apiController.fetchPngAssets();
          }
          return Center(
              child: Text("This Screen is working on.."),);
        }
      }),
    );
  }
}

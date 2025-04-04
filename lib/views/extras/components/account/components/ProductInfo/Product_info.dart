import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/account/AccountController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

class ProductInfo extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();
  final AccountController accountController = Get.find<AccountController>();

  ProductInfo({Key? key}) : super(key: key) {
    accountController.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeController.isDarkTheme.value
            ? Color.fromRGBO(44, 45, 49, 1)
            : Color.fromRGBO(255, 255, 255, 1.0),
        iconTheme: IconThemeData(
          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Product    Information".tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: "Sarbaz",
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
          final user = accountController.userProfile.value;
          final List<String> fields = [
            "User ID".tr,
            "Username".tr,
            "Email".tr,
            "First Name".tr,
            "Last Name".tr,
            "Phone Number".tr,
            "City".tr,
            "Job".tr,
            "Car Brand".tr,
            "National ID".tr,
          ];
          final List<String> answers = [
            user["user_id"]?.toString() ?? "",
            user["username"] ?? "",
            user["email"] ?? "",
            user["first_name"] ?? "",
            user["last_name"] ?? "",
            user["phone_number"] ?? "",
            user["city"] ?? "",
            user["job"] ?? "",
            user["car_brand"] ?? "",
            user["national_id"] ?? "",
          ];
          return SingleChildScrollView(
            child: Center(
              child: InfoContainer(fields, answers, w),
            ),
          );
        }
      ),
    );
  }
}
String _decodeUtf8(String input) {
  return utf8.decode(input.runes.toList(), allowMalformed: true);
}
Widget InfoContainer(List<String> fields, List<String> answers, double w) {
  return Container(
    margin: EdgeInsets.all(w * 0.04),
    padding: EdgeInsets.all(w * 0.04),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(fields.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  fields[index],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: w * 0.02),
              Expanded(
                flex: 3,
                child: Text(_decodeUtf8(answers[index])),
              ),
            ],
          ),
        );
      }),
    ),
  );
}
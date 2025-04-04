import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/bindings/bindings.dart';
import 'package:treenode/controllers/account/AccountController.dart';
import 'package:treenode/controllers/api/ApiController.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/buypro/BuyProScreen.dart';
import 'package:treenode/views/home/components/DayRemaining.dart';

final LangController langController = Get.find<LangController>();
final ThemeController themeController = Get.find<ThemeController>();
final ApiController apiController = Get.find<ApiController>();
final AccountController accountController = Get.find<AccountController>();


Widget Header(double w) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.ltr,
      children: [
        RichText(
          textDirection: TextDirection.ltr,
          text: TextSpan(
            children: [
              const TextSpan(
                text: "ECU  ",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Sarbaz',
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 253, 107, 107),
                ),
              ),
              TextSpan(
                text: "PARS".tr,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Sarbaz",
                  fontWeight: FontWeight.bold,
                  color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () async {
                apiController.isCacheLoaded.value = false;
                await apiController.fetchAndCachePngAssets();
                await accountController.getUserProfile();
              },
              icon: Icon(
                Icons.refresh,
                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
              ),
            ),

            IconButton(
              onPressed: themeController.toggleTheme,
              icon: Icon(
                themeController.isDarkTheme.value ? Icons.nightlight_round : Icons.wb_sunny,
                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget Greeting(double w) {
  final AccountController accountController = Get.find<AccountController>();
  final ThemeController themeController = Get.find<ThemeController>();
  String firstName = accountController.userProfile['first_name'] ?? '';
  if (firstName == '') {
    accountController.getUserProfile();
  }
  String decodedFirstName = utf8.decode(firstName.runes.toList(), allowMalformed: true);

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/hello/hello.png',
                  scale: 2,
                ),
                Text(
                  "Hello".tr,
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: "Sarbaz",
                    color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, w * 0.12, 0),
              child: SizedBox(
                width: w * 0.8,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        "$decodedFirstName !",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: "Sarbaz",
                          fontWeight: FontWeight.bold,
                          color: themeController.isDarkTheme.value
                              ? const Color.fromARGB(255, 253, 107, 107)
                              : Colors.redAccent,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: w * 0.16),
                    if (accountController.subscriptionInfo['is_active'] == true)
                      DayRemaining(width: w * 0.4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
Widget HomeLabel() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
    child: Row(
      children: [
        GestureDetector(
          onTap: () {
            langController.changeLanguage("fa");
          },
          child: Obx(() {
            return Text(
              "HOME".tr,
              style: TextStyle(
                fontSize: 25,
                fontFamily: "Sarbaz",
                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
              ),
            );
          }),
        ),
      ],
    ),
  );
}


Widget BuyPro(double w) {
  return Padding(
    padding: EdgeInsets.fromLTRB(w * 0.08, 0, w * 0.08, 0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(w*0.04),
      ),
      height: w * 0.2,
      child: Padding(
        padding: EdgeInsets.fromLTRB(w * 0.024, 0, w * 0.06, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                "Unload all the features             \nwith the Pro version".tr,
                style: TextStyle(
                    fontSize: w*0.038,
                    fontFamily: "Sarbaz"
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(() => BuyProScreen(), binding: MyBindings());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(w*0.04),
                ),
                fixedSize: Size(w * 0.23, w * 0.11),
              ),
              child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Get".tr,
                      style: TextStyle(color: Colors.white,   fontFamily: "Sarbaz"
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_outlined,
                      color: Colors.white, // Icon color
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
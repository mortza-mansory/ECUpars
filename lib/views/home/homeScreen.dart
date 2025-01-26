import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/api/ApiController.dart';
import 'package:treenode/controllers/auth/LoginController.dart';
import 'package:treenode/controllers/connection/ConnectionController.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/NavigationController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/Inbox/inboxScreen.dart';
import 'package:treenode/views/components/animatedIco.dart';
import 'package:treenode/views/components/customNavigationBar.dart';
import 'package:treenode/views/extras/ExtrasScreen.dart';
import 'package:treenode/views/search/searchScreen.dart';
import 'package:treenode/views/treeView/CategoryScreen.dart';

class Homescreen extends StatelessWidget {
  Homescreen({super.key});

  final NavigationController navigationController =
      Get.find<NavigationController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final LangController langController = Get.find<LangController>();
  final ApiController apiController = Get.find<ApiController>();
  final LoginController loginController = Get.find<LoginController>();
  final ConnectionController connectionController = Get.find<ConnectionController>();

  Widget _buildIconAnimations(BuildContext context) {
    double AdaptivePadding(double width) {
      if (width <= 320) {
        return 10;
      } else if (width >= 360) {
        return 20;
      } else if (width >= 400 && width <= 768) {
        return 35;
      } else {
        return 0;
      }
    }

    double c = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double hPadding = AdaptivePadding(c);
    double d = 0.260 * c;
    double b = d / 8.5;
    double a = max((c - (3 * d + 2 * b)) / 2, 0);

    double baseHeight = d * 1.41;
    double heightToText = 30.0;

    double T = heightToText / 3;
    double currentHeight = baseHeight;
    double F = 0.23 * currentHeight;
    double containerHeight = baseHeight;

    final apiController = Get.find<ApiController>();
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      if (apiController.isLoading.value) {
        return Center(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text(
                      'Please wait...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Data is loading, please wait.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      if (apiController.errorMessage.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                apiController.errorMessage.value,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        });

        return Center(
          child: Container(
            width: double.infinity,
            height: height * 0.15,
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.red.shade50,
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 24.0,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Unauthorized: Please log in again.'.tr,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Divider(thickness: 1, color: Colors.red.shade200),
                    SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          apiController.errorMessage.value,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: a),
        child: Wrap(
          spacing: b,
          runSpacing: 12,
          alignment: WrapAlignment.start,
          children: List.generate(apiController.pngAssetsList.length, (index) {
            // Bug bakhshe karshenas sho
            String decodeUnicode(String input) {
              Map<String, dynamic> tempMap = {"key": input};
              Map<String, dynamic> decodedMap = tempMap.map((key, value) {
                if (value is String) {
                  return MapEntry(
                      key, utf8.decode(value.runes.toList(), allowMalformed: true));
                } else {
                  return MapEntry(key, value);
                }
              });
              return decodedMap["key"];
            }

            return _buildIconContainer(
              imagePath: apiController.pngAssetsList[index]['png'] ?? '',
              categoryName: decodeUnicode(
                  apiController.pngAssetsList[index]['text'] ?? ''),
              font: apiController.pngAssetsList[index]['font'] ?? 'Sarbaz',
              fontWeight: apiController.pngAssetsList[index]['fontW'] ?? '600',
              containerColor: themeController.isDarkTheme.value
                  ? const Color(0xFF545454)
                  : const Color(0xFFFFF2E2),
              d: d,
              hPadding: hPadding,
              containerHeight: containerHeight,
              T: T,
              F: F,
              themeController: themeController,
              apiController: apiController,
              id: apiController.pngAssetsList[index]['id'],
            );
          }),
        ),
      );
    });
  }

  Widget _buildIconContainer({
    required double hPadding,
    required String imagePath,
    required String categoryName,
    required String font,
    required String fontWeight,
    required Color containerColor,
    required double d,
    required double containerHeight,
    required double T,
    required double F,
    required ThemeController themeController,
    required ApiController apiController,
    required int id,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(() => CategoryScreen(
              categoryId: id,
              isRoot: true,
            ));
      },
      child: Container(
        width: d,
        height: containerHeight,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: Offset(0, 2),
              blurRadius: 6,
              spreadRadius: 1,
            ),
            if (themeController.isDarkTheme.value)
              BoxShadow(
                color: Colors.white.withOpacity(0.7),
                offset: Offset(0, 2),
                blurRadius: 1,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(top: F - 20, left: 8.0, right: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TadaLogo(
                width: d / 2,
                height: d / 2,
                path: imagePath,
                pauseBetweenCycle: const Duration(milliseconds: 400),
                smallerScale: 0.9,
                biggerScale: 1.12,
                shakeCycles: 4,
                shakeDuration: const Duration(milliseconds: 300),
                shakeAngle: 0.1,
                initialShrinkTilt: 0.05,
                liftDuringShrink: 30,
              ),
              SizedBox(height: hPadding),
              Text(
                categoryName,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: font,
                  fontWeight: apiController.getFontWeight(fontWeight),
                  color: themeController.isDarkTheme.value
                      ? Colors.white
                      : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
                // ECU part
                TextSpan(
                  text: "ECU  ",
                  style: const TextStyle(
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
                    color: themeController.isDarkTheme.value
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: themeController.toggleTheme,
            icon: Icon(
              themeController.isDarkTheme.value
                  ? Icons.nightlight_round
                  : Icons.wb_sunny,
              color: themeController.isDarkTheme.value
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
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
                      color: themeController.isDarkTheme.value
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
              Text(
                "               User5687 !".tr,
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: "Sarbaz",
                  fontWeight: FontWeight.bold,
                  color: themeController.isDarkTheme.value
                      ? Color.fromARGB(255, 253, 107, 107)
                      : Colors.redAccent,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHomeLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              langController.changeLanguage("en");
            },
            child: Obx(() {
              return Text(
                "HOME".tr,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Sarbaz",
                  color: themeController.isDarkTheme.value
                      ? Colors.white
                      : Colors.black,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  //  if (apiController.pngAssetsList.isEmpty) {
  //  apiController.fetchPngAssets();
  //  }

  @override
  Widget build(BuildContext context) {
    apiController.onInit();
    connectionController.onInit();
    return Scaffold(
      body: Obx(() {
        switch (navigationController.selectedIndex.value) {
          case 0:
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildGreeting(),
                    const SizedBox(height: 20),
                    _buildHomeLabel(),
                    const SizedBox(height: 20),
                    _buildIconAnimations(context),
                  ],
                ),
              ),
            );
          case 1:
            return SearchScreen();
          case 2:
            return Inboxscreen();
          case 3:
            return ExtrasScreen();
          default:
            return const Center(child: Text("Invalid selection"));
        }
      }),
      bottomNavigationBar: AnimatedNavigationBar(),
    );
  }
}

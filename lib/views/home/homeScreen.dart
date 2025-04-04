import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/account/AccountController.dart';
import 'package:treenode/controllers/api/ApiCategory.dart';
import 'package:treenode/controllers/api/ApiController.dart';
import 'package:treenode/controllers/api/ApiIssus.dart';
import 'package:treenode/controllers/api/ApiSteps.dart';
import 'package:treenode/controllers/auth/LoginController.dart';
import 'package:treenode/controllers/connection/ConnectionController.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/NavigationController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/viewModel/NodeTree.dart';
import 'package:treenode/views/Articles/ArticleScreen.dart';
import 'package:treenode/views/components/animatedIco.dart';
import 'package:treenode/views/components/customNavigationBar.dart';
import 'package:treenode/views/extras/ExtrasScreen.dart';
import 'package:treenode/views/home/components/Components.dart';
import 'package:treenode/views/search/searchScreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final NavigationController navigationController = Get.find<NavigationController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final LangController langController = Get.find<LangController>();
  final ApiController apiController = Get.find<ApiController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final LoginController loginController = Get.find<LoginController>();
  final ConnectionController connectionController = Get.find<ConnectionController>();
  final AccountController accountController = Get.find<AccountController>();

  late Future<void> _initFuture;

  Future<void> initializeControllers() async {
    await apiController.fetchAndCachePngAssets();
  }


  @override
  void initState() {
    super.initState();
    _initFuture = initializeControllers();
  }

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
    double F = 0.23 * baseHeight;
    double containerHeight = baseHeight;

    return Obx(() {
      if (apiController.isLoading.value) {
        return Center(
          child: Container(
            width: double.infinity,
            height: height * 0.2,
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text(
                      'Please wait...'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Data is loading, please wait.'.tr,
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
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: a),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Wrap(
            spacing: b,
            runSpacing: 12,
            alignment: WrapAlignment.start,
            children: List.generate(apiController.pngAssetsList.length, (index) {
              String decodeUnicode(String input) {
                Map<String, dynamic> tempMap = {"key": input};
                Map<String, dynamic> decodedMap = tempMap.map((key, value) {
                  if (value is String) {
                    return MapEntry(key, utf8.decode(value.runes.toList(), allowMalformed: true));
                  } else {
                    return MapEntry(key, value);
                  }
                });
                return decodedMap["key"];
              }

              final containerColor = index == 0
                  ? const Color.fromARGB(255, 253, 107, 107)
                  : themeController.isDarkTheme.value
                  ? const Color(0xFF545454)
                  : const Color(0xFFFFF2E2);

              return _buildIconContainer(
                imagePath: apiController.pngAssetsList[index]['png'] ?? '',
                categoryName: decodeUnicode(apiController.pngAssetsList[index]['text'] ?? ''),
                font: apiController.pngAssetsList[index]['font'] ?? 'Sarbaz',
                fontWeight: apiController.pngAssetsList[index]['fontW'] ?? '600',
                containerColor: containerColor,
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
    return Container(
      width: d,
      height: containerHeight,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 1),
            blurRadius: 6,
            spreadRadius: 1,
          ),
          if (themeController.isDarkTheme.value)
            BoxShadow(
              color: Colors.white.withOpacity(0.7),
              offset: const Offset(0, 1),
              blurRadius: 1,
              spreadRadius: 1,
            ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () async {
          await Future.delayed(const Duration(milliseconds: 300));
          globalNavigationStack.clear();
          categoryController.navigateToCategoryDetails(id, isRoute: true);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.zero,
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black.withOpacity(0.1);
              }
              return null;
            },
          ),
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
                  color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
                textDirection: Get.locale?.languageCode == 'fa'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
     accountController.getUserProfile();

    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
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
                        Header(w),
                        const SizedBox(height: 20),
                        Greeting(w),
                        const SizedBox(height: 20),
                       if (accountController.showBuyPro.value) ...[
                          BuyPro(w),
                          const SizedBox(height: 20),
                        ],
                        const SizedBox(height: 20),
                        _buildIconAnimations(context),
                      ],
                    ),
                  ),
                );
              case 1:
                return SearchScreen();
              case 2:
                return Articlescreen();
              case 3:
                return ExtrasScreen();
              default:
                return const Center(child: Text("Invalid selection"));
            }
          }),
          bottomNavigationBar: AnimatedNavigationBar(),
        );
      },
    );
  }
}

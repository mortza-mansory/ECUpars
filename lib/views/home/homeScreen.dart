import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/api/ApiController.dart';
import 'package:treenode/controllers/auth/LoginController.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/NavigationController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/Inbox/inboxScreen.dart';
import 'package:treenode/views/components/animatedIco.dart';
import 'package:treenode/views/components/customNavigationBar.dart';
import 'package:treenode/views/profile/ExtrasScreen.dart';
import 'package:treenode/views/search/searchScreen.dart';

class Homescreen extends StatelessWidget {
  Homescreen({super.key});

  final NavigationController navigationController = Get.find<NavigationController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final LangController langController = Get.find<LangController>();
  final ApiController apiController = Get.put(ApiController());
  final LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (!loginController.isLoggedIn.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (apiController.pngAssetsList.isEmpty) {
          apiController.fetchPngAssets();
        }

        return Obx(() {
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
                      _buildIconAnimations(),
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
        });
      }),
      bottomNavigationBar: AnimatedNavigationBar(),
    );
  }

  Widget _buildIconAnimations() {
    double c = Get.width;
    double d = 0.260 * c;
    double b = d / 8.5;
    double a = (c - (3 * d + 2 * b)) / 2;
    double containerHeight = d * 1.6;

    // Fetch the ApiController
    final apiController = Get.find<ApiController>();
    apiController.fetchPngAssets(); // Ensure assets are fetched before building

    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: a),
        child: Wrap(
          spacing: b,
          runSpacing: 12,
          alignment: WrapAlignment.start,
          children: List.generate(apiController.pngAssetsList.length, (index) {
            // Extract PNG asset and category name
            String imagePath = apiController.pngAssetsList[index]['png'] ?? '';
            String categoryName =
                apiController.pngAssetsList[index]['text'] ?? 'Unknown';

            // Dynamic container color
            Color containerColor = (index == 0)
                ? const Color.fromRGBO(30, 144, 255, 1)
                : (themeController.isDarkTheme.value
                ? const Color(0xFF545454)
                : const Color(0xFFFFF2E2));

            return Container(
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
                      color: Colors.white.withOpacity(1),
                      offset: Offset(0, 2),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    TadaLogo(
                      width: 60,
                      height: 60,
                      path: imagePath,
                      pauseBetweenCycle: const Duration(milliseconds: 400),
                      smallerScale: 0.9,
                      biggerScale: 1.3,
                      shakeCycles: 4,
                      shakeDuration: const Duration(milliseconds: 300),
                      shakeAngle: 0.1,
                      initialShrinkTilt: 0.05,
                      liftDuringShrink: 30,
                    ),

                    const SizedBox(height: 8),
                    Text(
                      categoryName,
                      style: TextStyle(
                        fontSize: 12,
                        color: themeController.isDarkTheme.value
                            ? Colors.white
                            : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }



  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "ECU  ".tr,
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: 'Sarbaz',
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
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
              color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "    👋 Hello ",
              style: TextStyle(
                fontSize: 10,
                color: themeController.isDarkTheme.value
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            Text(
              "    User !",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: themeController.isDarkTheme.value
                    ? Colors.white
                    : Colors.redAccent,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildHomeLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 7, 0),
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
                  fontSize: 18,
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
}

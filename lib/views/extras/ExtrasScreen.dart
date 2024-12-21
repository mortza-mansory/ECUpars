import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/auth/LoginController.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/components/animatedIco.dart';
import 'package:treenode/views/extras/components/AboutAppScreen.dart';
import 'package:treenode/views/extras/components/ContactSupportScreen.dart';
import 'package:treenode/views/extras/components/ProfileScreen.dart';
import 'package:treenode/views/extras/components/ShareAppScreen.dart';
import 'package:treenode/views/extras/components/settingsScreen.dart';

class ExtrasScreen extends StatelessWidget {
  ExtrasScreen({super.key});

  final ThemeController themeController = Get.find<ThemeController>();
  final LangController langController = Get.find<LangController>();
  final LoginController loginController = Get.find<LoginController>();



  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
              color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              langController.changeLanguage("fa");
            },
            child: Obx(() {
              return Text(
                "Extras".tr,
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

  Widget _buildExtras() {
    Color containerColor = themeController.isDarkTheme.value
      ? const Color(0xFF545454)
      : const Color(0xFFFFF2E2);
    double c = Get.width;
    double d = 0.260 * c;
    double b = d / 8.5;
    double a = (c - (3 * d + 2 * b)) / 2;
    double containerHeight = d * 1.6;

    return Obx(() {
      return  Wrap(
          spacing: b,
          runSpacing: 12,
          alignment: WrapAlignment.start,
          children:[
            GestureDetector(
              onTap: ()
              {
                Get.to(() => SettingsScreen());

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
                        color: Colors.white.withOpacity(1),
                        offset: Offset(0, 2),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,8,0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TadaLogo(
                        width: d / 2 + 10,
                        height: 60,
                        icon: Icons.settings,
                        Iconcolor: Colors.redAccent.shade100,
                        pauseBetweenCycle: const Duration(milliseconds: 400),
                        smallerScale: 0.9,
                        biggerScale: 1.12,
                        shakeCycles: 4,
                        shakeDuration: const Duration(milliseconds: 300),
                        shakeAngle: 0.1,
                        initialShrinkTilt: 0.05,
                        liftDuringShrink: 30,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Settings".tr,
                        style: TextStyle(
                          fontFamily: "Sarbaz",
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
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
            ),
            GestureDetector(
      onTap: (){
        Get.to(() => AboutAppScreen());
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
                        color: Colors.white.withOpacity(0.6),
                        offset: Offset(0, 2),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,8,0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TadaLogo(
                        width: d / 2 + 10,
                        height: 60,
                        icon: Icons.info,
                        Iconcolor:  Colors.cyanAccent.shade700,
                        pauseBetweenCycle: const Duration(milliseconds: 400),
                        smallerScale: 0.9,
                        biggerScale: 1.12,
                        shakeCycles: 4,
                        shakeDuration: const Duration(milliseconds: 300),
                        shakeAngle: 0.1,
                        initialShrinkTilt: 0.05,
                        liftDuringShrink: 30,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "About App".tr,
                        style: TextStyle(
                          fontFamily: "Sarbaz",
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
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
            ),
            Container(
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
              child: GestureDetector(
                onTap: (){
                  Get.to(ShareAppScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,8,0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TadaLogo(
                        width: d / 2 + 10,
                        height: 60,
                        icon: Icons.share,
                        Iconcolor: Colors.green,
                        pauseBetweenCycle: const Duration(milliseconds: 400),
                        smallerScale: 0.9,
                        biggerScale: 1.12,
                        shakeCycles: 4,
                        shakeDuration: const Duration(milliseconds: 300),
                        shakeAngle: 0.1,
                        initialShrinkTilt: 0.05,
                        liftDuringShrink: 30,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Share App".tr,
                        style: TextStyle(
                          fontFamily: "Sarbaz",
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
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

            ),
            GestureDetector(
              onTap: (){
                Get.to(() => Contactsupportscreen());
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
                        color: Colors.white.withOpacity(1),
                        offset: Offset(0, 2),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,8,0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TadaLogo(
                        width: d / 2 + 10,
                        height: 60,
                        icon: Icons.support_agent,
                        Iconcolor: Colors.deepOrangeAccent,
                        pauseBetweenCycle: const Duration(milliseconds: 400),
                        smallerScale: 0.9,
                        biggerScale: 1.12,
                        shakeCycles: 4,
                        shakeDuration: const Duration(milliseconds: 300),
                        shakeAngle: 0.1,
                        initialShrinkTilt: 0.05,
                        liftDuringShrink: 30,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Contact Support".tr,
                        style: TextStyle(
                          fontFamily: "Sarbaz",
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
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
            ),
            GestureDetector(
            onTap: ()
              {
                Get.to(() => ProfileScreen());
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
                        color: Colors.white.withOpacity(1),
                        offset: Offset(0, 2),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,8,0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TadaLogo(
                        width: d / 2 + 10,
                        height: 60,
                        icon: Icons.account_circle,
                        Iconcolor: Colors.redAccent,
                        pauseBetweenCycle: const Duration(milliseconds: 400),
                        smallerScale: 0.9,
                        biggerScale: 1.12,
                        shakeCycles: 4,
                        shakeDuration: const Duration(milliseconds: 300),
                        shakeAngle: 0.1,
                        initialShrinkTilt: 0.05,
                        liftDuringShrink: 30,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Account".tr,
                        style: TextStyle(
                          fontFamily: "Sarbaz",
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
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
            ),]
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
          if (!loginController.isLoggedIn)  {
          Get.toNamed('/l');
          return Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 80),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 40),
                _buildHomeLabel(),
                const SizedBox(height: 20),
                _buildExtras()
              ],
            ),
          );
        }
      }),
    );
  }
}


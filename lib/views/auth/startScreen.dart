import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/auth/AccessController.dart';
import 'package:treenode/controllers/auth/LoginController.dart';
import 'package:treenode/views/auth/loginScreen.dart';
import 'package:treenode/views/auth/signupScreen.dart';

import '../../controllers/utills/LangController.dart';
import '../../controllers/utills/ThemeController.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LangController langController = Get.find<LangController>();
    final ThemeController themeController = Get.find<ThemeController>();

    double a = MediaQuery.of(context).size.width;
    double n = 0.70 * a;
    double r = 0.02 * n;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
                  () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.ltr,
                children: [
                  IconButton(
                    onPressed: () {
                      themeController.toggleTheme();
                    },
                    icon: Icon(
                      themeController.isDarkTheme.value
                          ? Icons.nightlight_outlined
                          : Icons.light_mode,
                      color: themeController.isDarkTheme.value
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  DropdownButton<String>(
                    value: langController.selectedLanguage.value,
                    onChanged: (String? value) {
                      if (value != null) {
                        langController.changeLanguage(value);
                      }
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'en',
                        child: Text(
                          'English',
                          style: TextStyle(
                            color: themeController.isDarkTheme.value
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'fa',
                        child: Text(
                          'فارسی',
                          style: TextStyle(
                            color: themeController.isDarkTheme.value
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                    dropdownColor: themeController.isDarkTheme.value
                        ? Colors.grey[900]
                        : Colors.white,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: themeController.isDarkTheme.value
                          ? Colors.white
                          : Colors.black,
                    ),
                    underline: SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 240,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Sign Up button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(n, 60),
                    elevation: 7,
                    shadowColor: Colors.black,
                    backgroundColor: Colors.yellow.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onPressed: () async {
                    await Future.delayed(Duration(milliseconds: 300));
                   Get.to(() => SignUpScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.credit_card,
                          color: Colors.black,
                        ),
                        SizedBox(width: r),
                        Expanded(
                          child: Text(
                            "Sign up".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Sarbaz',
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                // Login button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(n, 60),
                    elevation: 7,
                    shadowColor: Colors.black,
                    backgroundColor: Colors.yellow.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onPressed: () async {
                    await Future.delayed(Duration(milliseconds: 300));
                    Get.to(() => LoginScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.login_rounded,
                          color: Colors.black,
                        ),
                        SizedBox(width: r),
                        Expanded(
                          child: Text(
                            "Login".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Sarbaz',
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

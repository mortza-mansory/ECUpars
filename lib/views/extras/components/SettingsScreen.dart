import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();
  final LangController langController = Get.find<LangController>();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Obx(() => Scaffold(
          appBar: AppBar(
            backgroundColor: themeController.isDarkTheme.value
                ? Color.fromRGBO(44, 45, 49, 1)
                : Colors.white,
            iconTheme: IconThemeData(
              color: themeController.isDarkTheme.value
                  ? Colors.white
                  : Colors.black,
            ),
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text(
              "Settings".tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeController.isDarkTheme.value
                    ? Colors.white
                    : Colors.black,
                  fontFamily: 'Sarbaz'
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
            child: Obx(() {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Application Theme".tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: themeController.isDarkTheme.value
                              ? Colors.white
                              : Colors.black,
                            fontFamily: 'Sarbaz'
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.02),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (themeController.isDarkTheme.value) {
                              themeController.toggleTheme();
                            }
                          },
                          child: Container(
                            width: 120,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: !themeController.isDarkTheme.value
                                    ? Colors.transparent
                                    : Colors.black,
                                width: 1,
                              ),
                              color: !themeController.isDarkTheme.value
                                  ? Colors.blue
                                  : Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.light_mode,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Light".tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                      fontFamily: 'Sarbaz'
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            if (!themeController.isDarkTheme.value) {
                              themeController.toggleTheme();
                            }
                          },
                          child: Container(
                            width: 120,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: !themeController.isDarkTheme.value
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: themeController.isDarkTheme.value
                                  ? Colors.blue
                                  : Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.dark_mode,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Dark".tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                      fontFamily: 'Sarbaz'
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  Row(
                    children: [
                      Text(
                        "Application Language".tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: themeController.isDarkTheme.value
                              ? Colors.white
                              : Colors.black,
                            fontFamily: 'Sarbaz'
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  Row(
                    children: [
                      Text(
                        "Language:".tr,
                        style: TextStyle(
                          color: themeController.isDarkTheme.value
                              ? Colors.white
                              : Colors.black,
                            fontFamily: 'Sarbaz'
                        ),
                      ),
                      Spacer(),
                      DropdownButton<String>(
                        dropdownColor: themeController.isDarkTheme.value
                            ? Colors.grey[900]
                            : Colors.white,
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
                                    fontFamily: 'Sarbaz'
                                ),
                              )),
                          DropdownMenuItem(
                              value: 'fa',
                              child: Text(
                                'فارسی',
                                style: TextStyle(
                                  color: themeController.isDarkTheme.value
                                      ? Colors.white
                                      : Colors.black,
                                    fontFamily: 'Sarbaz'
                                ),
                              )),
                        ],
                        underline: SizedBox.shrink(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  Row(
                    children: [
                      Text(
                        "Application Preference".tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: themeController.isDarkTheme.value
                              ? Colors.white
                              : Colors.black,
                            fontFamily: 'Sarbaz'
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "This section is on development".tr,
                        style: TextStyle(
                          color: themeController.isDarkTheme.value
                              ? Colors.white
                              : Colors.black,
                            fontFamily: 'Sarbaz'
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Version".tr,
                        style: TextStyle(
                          color: themeController.isDarkTheme.value
                              ? Colors.white
                              : Colors.black,
                            fontFamily: 'Sarbaz'
                        ),
                      ),Text(
                        "1.0.0.0",
                        style: TextStyle(
                          color: themeController.isDarkTheme.value
                              ? Colors.white
                              : Colors.black,
                            fontFamily: langController.isRtl ? 'Sarbaz' : 'Vazir'
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ));
  }
}

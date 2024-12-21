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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeController.isDarkTheme.value
            ? Color.fromRGBO(44, 45, 49, 1)
            : Color.fromRGBO(255, 250, 244, 1),
        iconTheme: IconThemeData(
          color:
              themeController.isDarkTheme.value ? Colors.white : Colors.black,
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
            color:
                themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: false,
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
                    ),
                  )
                ],
              ),
              SizedBox(
                height: h * 0.02,
              ),
              Row(
                children: [
                  Text("Language:".tr),
                  Spacer(),
                  DropdownButton<String>(
                    value: langController.selectedLanguage.value,
                    onChanged: (String? value) {
                      if (value != null) {
                        langController.changeLanguage(value);
                      }
                    },
                    items: [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'fa', child: Text('فارسی')),
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
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("This section is on development".tr),
                ],
              ),
              Spacer(),
              Text("Ver 0.0.0.1".tr),
            ],
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:treenode/controllers/auth/LoginController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/extras/components/com/glassmorphismcontainer.dart';

class ProfileScreen extends StatelessWidget {

  final ThemeController themeController = Get.find<ThemeController>();
  final LoginController loginController = Get.find<LoginController>();

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
          "Profile".tr,
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
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
        child: GlassMorphismContainer(
          width: Get.width,
          height: Get.height,
          borderRadius: 16,
          blur: 1,
          gradientColors: themeController.isDarkTheme.value
              ? [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.0002),
          ]
              : [
            Colors.black.withOpacity(0.2),
            Colors.black.withOpacity(0.0002),
          ],
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: h * 0.05),
                Column(
                  children: [
                    Text(
                      "Acount Center".tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Sarbaz',
                        fontWeight: FontWeight.w200,
                        color: themeController.isDarkTheme.value
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Manage your connected account, add or in".tr,
                            style: TextStyle(
                              color: themeController.isDarkTheme.value
                                  ? Colors.white
                                  : Colors.black,
                            )),
                        Text("This is the test text from ECUPars".tr,
                            style: TextStyle(
                              color: themeController.isDarkTheme.value
                                  ? Colors.white
                                  : Colors.black,
                            )),
                        Text("This app is improving constantly.".tr,
                            style: TextStyle(
                              color: themeController.isDarkTheme.value
                                  ? Colors.white
                                  : Colors.black,
                            ))
                      ],
                    ),
                  ],
                ),
                SizedBox(height: h * 0.06),
                Container(
                  height: h * 0.1,
                  width: w * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: themeController.isDarkTheme.value
                        ? Colors.white24
                        : Colors.black12,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_circle, size: h * 0.08),
                            SizedBox(width: w * 0.02),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Profile".tr,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Sarbaz',
                                      fontWeight: FontWeight.w100,
                                      color: themeController.isDarkTheme.value
                                          ? Colors.white
                                          : Colors.black,
                                    )),
                                Text("test user".tr),
                              ],
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: h * 0.05),
                Row(
                  children: [
                    SizedBox(width: w * 0.06),
                    Text(
                      "Your Prodouct".tr,
                      style: TextStyle(
                        color: themeController.isDarkTheme.value
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.008),
                Container(
                  height: h * 0.06,
                  width: w * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: themeController.isDarkTheme.value
                        ? Colors.white24
                        : Colors.black12,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Product info".tr,
                          style: TextStyle(
                            color: themeController.isDarkTheme.value
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: h * 0.05),
                Row(
                  children: [
                    SizedBox(width: w * 0.06),
                    Text("Invite Section".tr,
                        style: TextStyle(
                          color: themeController.isDarkTheme.value
                              ? Colors.white
                              : Colors.black,
                        )),
                  ],
                ),
                SizedBox(height: h * 0.008),
                Container(
                  height: h * 0.12,
                  width: w * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: themeController.isDarkTheme.value
                        ? Colors.white24
                        : Colors.black12,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Your invite code".tr,
                                style: TextStyle(
                                  color: themeController.isDarkTheme.value
                                      ? Colors.white
                                      : Colors.black,
                                )),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                        SizedBox(height: h * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Invitaion".tr,
                                style: TextStyle(
                                  color: themeController.isDarkTheme.value
                                      ? Colors.white
                                      : Colors.black,
                                )),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: h * 0.05),
                Row(
                  children: [
                    SizedBox(width: w * 0.06),
                    Text("Agreement".tr,
                        style: TextStyle(
                          color: themeController.isDarkTheme.value
                              ? Colors.white
                              : Colors.black,
                        )),
                  ],
                ),
                SizedBox(height: h * 0.008),
                Container(
                  height: h * 0.05,
                  width: w * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: themeController.isDarkTheme.value
                        ? Colors.white24
                        : Colors.black12,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Private Policy".tr,
                            style: TextStyle(
                              color: themeController.isDarkTheme.value
                                  ? Colors.white
                                  : Colors.black,
                            )),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: h * 0.05),
                Row(
                  children: [
                    SizedBox(width: w * 0.06),
                    Text("Log out".tr,
                        style: TextStyle(
                          color: themeController.isDarkTheme.value
                              ? Colors.white
                              : Colors.black,
                        )),
                  ],
                ),
                SizedBox(height: h * 0.008),
                GestureDetector(
                  onTap: () {
                    logout(context);  // فراخوانی تابع logout
                  },
                  child: Container(
                    height: h * 0.05,
                    width: w * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: themeController.isDarkTheme.value
                          ? Colors.white24
                          : Colors.black12,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Logout from your account".tr),
                          Icon(Icons.exit_to_app_sharp),
                        ],
                      ),
                    ),
                  ),
                ),



                SizedBox(height: h * 0.05,),
                Text("Ver 0.0.0.1".tr),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {

    bool? confirmLogout = await Get.dialog(
      AlertDialog(
        title: Text('Are you sure you want to log out?'),
        content: Text('You will be logged out of your account.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
             // loginController.clearSession();
            },
            child: Text('Log out'),
          ),
        ],
      ),
    );

    if (confirmLogout == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAndToNamed('/start');
      });
    }
  }

}


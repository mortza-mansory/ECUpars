import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/auth/LoginController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/controllers/account/AccountController.dart';
import 'package:treenode/views/extras/components/account/components/Discounts/DiscountsScreen.dart';
import 'package:treenode/views/extras/components/account/components/Invite/ReferralScreen.dart';
import 'package:treenode/views/extras/components/account/components/PrivatePolicy/PrivatePolicy.dart';
import 'package:treenode/views/extras/components/account/components/ProductInfo/Product_info.dart';

class ProfileScreen extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();
  final LoginController loginController = Get.find<LoginController>();
  final AccountController accountController = Get.find<AccountController>();

  String _decodeUtf8(String input) {
    try {
      List<int> bytes = input.codeUnits;
      return utf8.decode(bytes, allowMalformed: true);
    } catch (e) {
      return input;
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    accountController.Init();

    return Scaffold(
      backgroundColor: themeController.isDarkTheme.value
          ? Color.fromRGBO(44, 45, 49, 1)
          : Color.fromRGBO(255, 255, 255, 1.0),
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
          "Account Center".tr,
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
        if (accountController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        var userProfile = accountController.userProfile;

        return Padding(
          padding: EdgeInsets.fromLTRB(w * 0.02, 0, w * 0.02, 0),
          child: Column(
            children: [
              SizedBox(height: h * 0.03),
              Container(
                height: h * 0.1,
                width: w * 0.9,
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
                              Text(
                                _decodeUtf8(
                                    "${userProfile['first_name'] ?? ''} ${userProfile['last_name'] ?? ''}"),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Sarbaz',
                                  fontWeight: FontWeight.w100,
                                  color: themeController.isDarkTheme.value
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              Text(
                                _decodeUtf8(userProfile['username'] ?? "Username"),
                              ),
                            ],
                          ),
                          SizedBox(width: w * 0.20),
                          if(userProfile['subscription'] != "")
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(color:Colors.white,),
                                right: BorderSide(color: Colors.white,),
                                bottom: BorderSide(color: Colors.white,),
                                top: BorderSide(color: Colors.white,)
                              )
                            ),
                            child: Padding(
                              padding:  EdgeInsets.fromLTRB(w*0.02,0,w*0.02,0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(_decodeUtf8(userProfile['subscription']['plan']['name'] ,),
                                    style: TextStyle(
                                    fontFamily: "Sarbaz",
                                      color: themeController.isDarkTheme.value
                                    ? Colors.white
                                      : Colors.black,
                                  ),),
                                  Text(userProfile['subscription']['is_active'] ? 'فعال'.tr : 'غیر فعال'.tr,
                                    style: TextStyle(
                                        color: userProfile['subscription']['is_active'] ? Colors.green  : Colors.red,   fontFamily: "Sarbaz"),)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: h * 0.04),

              _buildInfoContainer("Product info".tr, h, themeController),

              SizedBox(height: h * 0.03),

              _buildInviteContainer(themeController, h),

              SizedBox(height: h * 0.05),

              _PrivatePolicyContainer("Private Policy".tr, h, themeController),

              SizedBox(height: h * 0.02),

              Container(
                margin: EdgeInsets.symmetric(horizontal: h * 0.02),
                child: ElevatedButton(
                  onPressed: () async {
                    Future.delayed(Duration(milliseconds: 300), () async {
                      await logout(context);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeController.isDarkTheme.value
                        ? Colors.white24
                        : Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(double.infinity, 50),
                    padding: EdgeInsets.symmetric(horizontal: h * 0.02),
                    elevation: 0,
                    overlayColor: themeController.isDarkTheme.value
                        ? Colors.white24
                        : Colors.black12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Logout from your account".tr,
                        style: TextStyle(
                          color: themeController.isDarkTheme.value
                              ? Colors.white
                              : Colors.black,
                          fontSize: h * 0.0168,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: themeController.isDarkTheme.value
                            ? Colors.white
                            : Colors.black,
                      ),
                    ],
                  ),
                ),
              ),

              Spacer(),
              Text(
                "Ver 0.0.0.1".tr,
                style: TextStyle(
                  color: themeController.isDarkTheme.value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoContainer(
      String title, double h, ThemeController themeController,
      {IconData? icon}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: h * 0.02),
      child: ElevatedButton(
        onPressed: () {
          Future.delayed(Duration(milliseconds: 300), () {
            Get.to(() => ProductInfo());
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: themeController.isDarkTheme.value
              ? Colors.white24
              : Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(double.infinity, 50),
          padding: EdgeInsets.symmetric(horizontal: h * 0.02),
          elevation: 0,
          overlayColor: themeController.isDarkTheme.value
              ? Colors.white24
              : Colors.black12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title.tr,
              style: TextStyle(
                color: themeController.isDarkTheme.value
                    ? Colors.white
                    : Colors.black,
                fontSize: h * 0.0168,
              ),
            ),
            Icon(
              icon ?? Icons.arrow_forward_ios,
              color: themeController.isDarkTheme.value
                  ? Colors.white
                  : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _PrivatePolicyContainer(
      String title, double h, ThemeController themeController,
      {IconData? icon}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: h * 0.02),
      child: ElevatedButton(
        onPressed: () {
          Future.delayed(Duration(milliseconds: 300), () {
            Get.to(() => PrivacyScreen());
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: themeController.isDarkTheme.value
              ? Colors.white24
              : Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(double.infinity, 50),
          padding: EdgeInsets.symmetric(horizontal: h * 0.02),
          elevation: 0,
          overlayColor: themeController.isDarkTheme.value
              ? Colors.white24
              : Colors.black12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title.tr,
              style: TextStyle(
                color: themeController.isDarkTheme.value
                    ? Colors.white
                    : Colors.black,
                fontSize: h * 0.0168,
              ),
            ),
            Icon(
              icon ?? Icons.arrow_forward_ios,
              color: themeController.isDarkTheme.value
                  ? Colors.white
                  : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteContainer(ThemeController themeController, double h) {
    return Container(
      height: h * 0.14,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: h * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeController.isDarkTheme.value
            ? Colors.white24
            : Colors.black12,
      ),
      child: Column(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Future.delayed(Duration(milliseconds: 300), () {
                  Get.to(() => ReferralScreen());
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                overlayColor: themeController.isDarkTheme.value
                    ? Colors.white24
                    : Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                minimumSize: Size(double.infinity, h * 0.07),
                padding: EdgeInsets.symmetric(horizontal: h * 0.02),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Referral Code".tr,
                    style: TextStyle(
                      color: themeController.isDarkTheme.value
                          ? Colors.white
                          : Colors.black,
                      fontSize: h * 0.0168,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: themeController.isDarkTheme.value
                        ? Colors.white
                        : Colors.black,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Future.delayed(Duration(milliseconds: 300), () {
                  Get.to(() => Discountsscreen());
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                overlayColor: themeController.isDarkTheme.value
                    ? Colors.white24
                    : Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                minimumSize: Size(double.infinity, h * 0.07),
                padding: EdgeInsets.symmetric(horizontal: h * 0.02),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Discounts Code".tr,
                    style: TextStyle(
                      color: themeController.isDarkTheme.value
                          ? Colors.white
                          : Colors.black,
                      fontSize: h * 0.0168,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: themeController.isDarkTheme.value
                        ? Colors.white
                        : Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    bool? confirmLogout = await Get.dialog(
      AlertDialog(
        title: Text('Are you sure you want to log out?'.tr),
        content: Text('You will be logged out of your account.'.tr),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: Text('Cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: Text('Log out'.tr),
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

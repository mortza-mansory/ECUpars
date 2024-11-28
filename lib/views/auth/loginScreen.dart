import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/auth/LoginController.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/controllers/utills/components/appTheme.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();
    final LangController langController = Get.find<LangController>();
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() {
      return Directionality(
        textDirection: langController.isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16,16,16,32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Row(
                  children: [
                    IconButton(onPressed: () {
                      Get.toNamed("/start");
                    }, icon: Icon(Icons.arrow_back_ios)),
                    Spacer(),
                    Text(
                      'Login'.tr,
                      style: TextStyle(
                        color: themeController.isDarkTheme.value
                            ? AppTheme.nightParsColor
                            : AppTheme.dayParsColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sarbaz',
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 70),
                if (!loginController.isOtpSent.value) ...[
                  TextField(
                    controller: usernameController,
                    onChanged: (value) => loginController.updateUsername(value),
                    decoration: InputDecoration(
                      hintText: 'username'.tr,
                      hintStyle: TextStyle(
                        color: themeController.isDarkTheme.value ? Colors.white : Colors.grey,
                      ),
                      labelStyle: TextStyle(
                        color: themeController.isDarkTheme.value
                            ? AppTheme.nightParsColor
                            : AppTheme.dayParsColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sarbaz',
                        fontSize: 25,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: themeController.isDarkTheme.value ? Colors.white : Colors.grey,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: themeController.isDarkTheme.value ? Colors.white : Colors.grey,
                          width: 2,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 50),
                  // Password Input Field
                  TextField(
                    controller: passwordController,
                    onChanged: (value) => loginController.updatePassword(value),
                    decoration: InputDecoration(
                      hintText: 'password'.tr,
                      hintStyle: TextStyle(
                        color: themeController.isDarkTheme.value ? Colors.white : Colors.grey,
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sarbaz',
                        fontSize: 25,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: themeController.isDarkTheme.value ? Colors.white : Colors.grey,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: themeController.isDarkTheme.value ? Colors.white : Colors.grey,
                          width: 2,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 50),
                  // Login Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(320, 60),
                      elevation: 7,
                      shadowColor: Colors.black,
                      backgroundColor: loginController.isFormValid()
                          ? Colors.yellow.shade600
                          : Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: loginController.isFormValid()
                        ? () async {
                      await loginController.login(
                        usernameController.text,
                        passwordController.text,
                      );
                    }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.login_rounded,
                            color: Colors.black,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Login".tr,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Sarbaz',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (loginController.isLoading.value) ...[
                  Center(child: CircularProgressIndicator()),
                ],
                if (loginController.isOtpSent.value) ...[
                  SizedBox(height: 20),
                  TextField(
                    controller: otpController,
                    onChanged: (value) => loginController.updateUsername(value),
                    decoration: InputDecoration(
                      hintText: 'enter_otp'.tr,
                      hintStyle: TextStyle(
                        color: themeController.isDarkTheme.value ? Colors.white : Colors.grey,
                      ),
                      labelStyle: TextStyle(
                        color: themeController.isDarkTheme.value
                            ? AppTheme.nightParsColor
                            : AppTheme.dayParsColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sarbaz',
                        fontSize: 25,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: themeController.isDarkTheme.value ? Colors.white : Colors.grey,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: themeController.isDarkTheme.value ? Colors.white : Colors.grey,
                          width: 2,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () async {
                      int otp = int.tryParse(otpController.text.trim()) ?? 0;
                      if (otp != 0) {
                        await loginController.verifyOtp(otp.toString());
                      } else {
                        Get.snackbar(
                          'error'.tr,
                          'invalid_otp'.tr,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: Text('verify_otp'.tr),
                  ),

                ],
                SizedBox(height: 20),
                Obx(() {
                  if (loginController.isLoggedIn.value) {
                    return Text('login_successful'.tr);
                  } else if (!loginController.isOtpValid.value && loginController.isOtpSent.value) {
                    return Text('otp_invalid'.tr);
                  }
                  return Container();
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}

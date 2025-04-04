import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/auth/LoginController.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/controllers/utills/components/appTheme.dart';

class OtpScreen extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();
    final LangController langController = Get.find<LangController>();
    final ThemeController themeController = Get.find<ThemeController>();

    double a = MediaQuery.of(context).size.width;
    double n = 0.75 * a; // Width of main button
    double r = 0.02 * n;

    // Resend button dimensions: 30% of main button
    double resendWidth = n * 0.3;
    double resendHeight = 60 * 0.3;

    return Directionality(
      textDirection: langController.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.toNamed("/start");
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    SizedBox(width: 15),
                    Text(
                      'Otp'.tr,
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
              ),
              SizedBox(height: 50),
              Container(
                width: n,
                child: TextField(
                  controller: otpController,
                  onChanged: loginController.updateOtpLength,
                  decoration: InputDecoration(
                    hintText: 'Enter OTP'.tr,
                    hintStyle: TextStyle(
                      color: themeController.isDarkTheme.value
                          ? Colors.white
                          : Colors.grey,
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sarbaz',
                      fontSize: 25,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: themeController.isDarkTheme.value
                            ? Colors.white
                            : Colors.grey,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: themeController.isDarkTheme.value
                            ? Colors.white
                            : Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: themeController.isDarkTheme.value
                        ? Colors.white
                        : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(height: 50),
              Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(n, 60),
                  elevation: 7,
                  shadowColor: Colors.black,
                  backgroundColor: loginController.isOtpValid.value
                      ? Colors.yellow.shade600
                      : Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                onPressed: loginController.isOtpValid.value &&
                    !loginController.isLoading.value
                    ? () async {
                  loginController.isLoading.value = true;
                  await loginController.verifyOtp(otpController.text);
                }
                    : null,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loginController.isLoading.value
                          ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: themeController.isDarkTheme.value
                              ? Colors.white
                              : Colors.black,
                          strokeWidth: 3,
                        ),
                      )
                          : Icon(
                        Icons.login_rounded,
                        color: Colors.black,
                      ),
                      if (!loginController.isLoading.value) SizedBox(width: r),
                      if (!loginController.isLoading.value)
                        Expanded(
                          child: Text(
                            "Enter OTP".tr,
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
              )),
              SizedBox(height: 20),
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(resendWidth, resendHeight),
                      elevation: 7,
                      shadowColor: Colors.black,
                      backgroundColor: loginController.isResendButtonDisabled.value
                          ? Colors.grey.shade400
                          : Colors.yellow.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: loginController.isResendButtonDisabled.value
                        ? null
                        : () {
                      final username = loginController.username;
                      loginController.resendOtp();
                    },
                    child: Text(
                      loginController.isResendButtonDisabled.value
                          ? loginController.getCountdownText()
                          : 'ارسال مجدد'.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Sarbaz',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
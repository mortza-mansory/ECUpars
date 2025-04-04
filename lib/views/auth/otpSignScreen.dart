import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/auth/SignUpController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/controllers/utills/components/appTheme.dart';

class OtpSignscreen extends StatelessWidget {
  final String phoneNumber;
  OtpSignscreen({super.key, required this.phoneNumber});

  final ThemeController themeController = Get.find<ThemeController>();
  final SignUpController signUpController = Get.find<SignUpController>();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Rx<String> password = ''.obs;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = 0.70 * screenWidth;
    double spacing = 0.02 * containerWidth;

    double resendWidth = containerWidth * 0.3;
    double resendHeight = 60 * 0.3;

    Widget buildHeader(ThemeController themeController, {required bool isFirstStep}) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            SizedBox(width: 15),
            Text(
              'Enter otp'.tr,
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
      );
    }

    Widget buildTextField(TextEditingController controller, String hint, ThemeController themeController, double width,
        [TextInputType keyboardType = TextInputType.text]) {
      return Container(
        width: width,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: themeController.isDarkTheme.value ? Colors.white : Colors.grey,
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
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          onChanged: (text) {
            if (controller == passwordController) {
              password.value = text;
            }
          },
        ),
      );
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildHeader(themeController, isFirstStep: false),
          SizedBox(height: screenWidth * 0.09),
          buildTextField(otpController, 'Enter OTP Code'.tr, themeController, containerWidth, TextInputType.number),
          SizedBox(height: screenWidth * 0.09),
          buildTextField(passwordController, 'Enter Password'.tr, themeController, containerWidth, TextInputType.text),
          SizedBox(height: screenWidth * 0.09),
          Obx(() {
            bool isOtpFilled = otpController.text.isNotEmpty;
            bool isPasswordFilled = password.value.isNotEmpty;
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(containerWidth - 10, 60),
                elevation: 7,
                shadowColor: Colors.black,
                backgroundColor: (isOtpFilled && isPasswordFilled) ? Colors.yellow.shade600 : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              onPressed: (isOtpFilled && isPasswordFilled && !signUpController.isLoading.value)
                  ? () async {
                signUpController.isLoading.value = true;
                String otp = otpController.text;
                String passwordValue = password.value;
                if (otp.isNotEmpty && passwordValue.isNotEmpty) {
                  await signUpController.verifyOtp(otp, passwordValue);
                } else {
                  Get.snackbar("Error".tr, "Please enter OTP and Password".tr,
                      snackPosition: SnackPosition.BOTTOM);
                }
              }
                  : null,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    signUpController.isLoading.value
                        ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                        strokeWidth: 3,
                      ),
                    )
                        : Icon(
                      Icons.check_circle,
                      color: Colors.black,
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: Text(
                        "Verify OTP".tr,
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
            );
          }),
          SizedBox(height: 20),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(resendWidth, resendHeight),
                  elevation: 7,
                  shadowColor: Colors.black,
                  backgroundColor: signUpController.isResendButtonDisabled.value
                      ? Colors.grey.shade400
                      : Colors.yellow.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: signUpController.isResendButtonDisabled.value
                    ? null
                    : () {
                  signUpController.resendOtp();
                },
                child: Text(
                  signUpController.isResendButtonDisabled.value
                      ? signUpController.getCountdownText()
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
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
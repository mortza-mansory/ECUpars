import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:treenode/controllers/auth/LoginController.dart';
import 'package:treenode/controllers/hardware/HardwareController.dart';
import 'package:treenode/services/api/HttpService.dart';
import 'package:treenode/views/auth/OtpSignscreen.dart';

class SignUpController extends GetxController {
  final HttpService httpService = HttpService();
  final HardwareController hardwareController = Get.find<HardwareController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController carBrandController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController referrerCodeController = TextEditingController();

  var _isLoggedIn = false.obs;
  var isOtpValid = false.obs;
  var isOtpSent = false.obs;
  var sessionId = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var otpReceived = ''.obs;

  var isResendButtonDisabled = true.obs;
  var countdown = 120.obs;

  final GetStorage storage = GetStorage();
  Timer? _countdownTimer;

  String decodeUtf8String(String encoded) {
    try {
      return utf8.decode(encoded.codeUnits, allowMalformed: true);
    } catch (e) {
      return encoded;
    }
  }

  Future<void> setLoggedIn(bool value) async {
    Future.delayed(Duration.zero, () {
      _isLoggedIn.value = value;
      storage.write('is_logged_in', value);
    });
  }

  Future<void> sendOtp() async {
    if (nameController.text.isEmpty ||
        surnameController.text.isEmpty ||
        carBrandController.text.isEmpty ||
        phoneController.text.isEmpty) {
      Get.snackbar("Error".tr, "All fields are required".tr, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      var response = await httpService.sendOtp(
        phoneNumber: phoneController.text,
        firstName: nameController.text,
        lastName: surnameController.text,
        carBrand: carBrandController.text,
        city: cityController.text,
        hardwareId: hardwareController.deviceId.toString(),
        referrerCode: referrerCodeController.text.isEmpty ? null : referrerCodeController.text,
      );

      if (response.containsKey('otp')) {
        String otp = response['otp'].toString();
        _showOtpSnackbar(otp);
        isOtpSent.value = true;
        Get.to(() => OtpSignscreen(phoneNumber: phoneController.text));
        startCountdown();
      } else if (response.containsKey('sms_result') && response['sms_result']['success'] == true) {
        isOtpSent.value = true;
        Get.snackbar("Success".tr, "OTP sent successfully".tr, snackPosition: SnackPosition.BOTTOM);
        Get.to(() => OtpSignscreen(phoneNumber: phoneController.text));
        startCountdown();
      } else {
        String errorMsg = response['sms_result'] != null && response['sms_result']['message'] != null
            ? decodeUtf8String(response['sms_result']['message'])
            : "Failed to send OTP".tr;
        Get.snackbar("Error".tr, errorMsg, snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 5));
      }
    } catch (e) {
      Get.snackbar("Error".tr, "An error occurred while sending OTP".tr, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String otp, String password) async {
    print('verifyOtp called with otp: $otp, password: $password');
    isLoading.value = true;
    try {
      print('Calling verifyOtpAndSignup with phone: ${phoneController.text}');
      bool result = await httpService.verifyOtpAndSignup(
        phoneNumber: phoneController.text,
        otp: otp,
        password: password,
      );

      print('verifyOtpAndSignup result: $result');
      if (result) {
        print('OTP verification successful, updating login state');
        Get.find<LoginController>().setLoggedIn(true);
        _countdownTimer?.cancel();

        print('Scheduling navigation to /home');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print('Current route: ${Get.currentRoute}');
          if (Get.currentRoute != '/home') {
            print('Navigating to /home');
            Get.offAllNamed('/home');
          } else {
            print('Already on /home, no navigation needed');
          }
        });
      } else {
        print('OTP verification failed, setting error');
        isOtpValid.value = false;
        errorMessage.value = "Invalid OTP. Please try again.".tr;
      }
    } catch (e) {
      print('Error in verifyOtp: $e');
      errorMessage.value = "An error occurred during OTP verification.".tr;
    } finally {
      print('Finished verifyOtp, setting isLoading to false');
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (isResendButtonDisabled.value) return;

    isLoading.value = true;
    try {
      var response = await httpService.resendOtp(phoneController.text);
      isOtpSent.value = true;
      countdown.value = 120;
      isResendButtonDisabled.value = true;
      startCountdown();
      Get.snackbar(
        'OTP Resent'.tr,
        'A new OTP has been sent to you'.tr,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  void startCountdown() {
    _countdownTimer?.cancel();
    isResendButtonDisabled.value = true;
    countdown.value = 120;

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        isResendButtonDisabled.value = false;
        timer.cancel();
      }
    });
  }

  String getCountdownText() {
    final minutes = (countdown.value ~/ 60).toString();
    final seconds = (countdown.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _showOtpSnackbar(String otp) {
    Get.snackbar(
      "OTP Sent".tr,
      "Please put your OTP code for continue.".tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      isDismissible: true,
      duration: Duration(seconds: 60),
    );
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    nameController.dispose();
    surnameController.dispose();
    carBrandController.dispose();
    cityController.dispose();
    phoneController.dispose();
    referrerCodeController.dispose();
    super.onClose();
  }
}
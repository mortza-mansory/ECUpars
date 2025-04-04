import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:treenode/services/api/HttpService.dart';
import 'package:treenode/views/auth/startScreen.dart';
import 'package:treenode/views/auth/otpScreen.dart';
import 'package:treenode/views/home/components/Components.dart';

class LoginController extends GetxController {
  var _isLoggedIn = false.obs;
  var isOtpValid = false.obs;
  var isOtpSent = false.obs;
  var sessionId = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var otpReceived = ''.obs;
  RxString username = ''.obs;
  RxString password = ''.obs;
  var isResendButtonDisabled = true.obs;
  var countdown = 120.obs;

  final HttpService httpService = HttpService();
  final GetStorage storage = GetStorage();

  Timer? _countdownTimer;

  @override
  void onInit() {
    super.onInit();
    IsLogined();
  }

  void IsLogined() {
    sessionId.value = storage.read('session_id') ?? '';
    _isLoggedIn.value = storage.read('is_logged_in') ?? false;
  }

  bool get isLoggedIn => _isLoggedIn.value;

  Future<void> setLoggedIn(bool value) async {
    Future.delayed(Duration.zero, () {
      _isLoggedIn.value = value;
      storage.write('is_logged_in', value);
    });
  }

  Future<void> login(String username, String password) async {
    clearSession();
    isLoading.value = true;
    this.username.value = username;
    this.password.value = password;

    if (username.trim().isEmpty || password.trim().isEmpty) {
      errorMessage.value = "لطفاً نام کاربری و رمز عبور را وارد کنید.".tr;
      Get.snackbar(
        'خطای ورودی'.tr,
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 5),
        titleText: Text(
          'خطای ورودی'.tr,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Sarbaz',
          ),
          textDirection: TextDirection.rtl,
        ),
        messageText: Text(
          errorMessage.value,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Sarbaz',
          ),
          textDirection: TextDirection.rtl,
        ),
      );
      isLoading.value = false;
    } else {
      try {
        final response = await httpService.login(username, password);

        if (response.isEmpty) {
          errorMessage.value =
              "Login failed. Server returned an empty response.".tr;
          Get.snackbar(
            'خطای ورود'.tr,
            errorMessage.value,
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 5),
          );
          return;
        }

        if (response['login_status'] == 'pending') {
          sessionId.value = response['session_id'];
          isOtpSent.value = true;
          storage.write('session_id', sessionId.value);

          Get.to(() => OtpScreen());

          startCountdown();
        } else if (response['login_status'] == 'failed') {
          isOtpSent.value = false;

          String fullErrorMsg = response['error'] ?? "Login failed".tr;
          String shortDescription = fullErrorMsg.split('.').first;
          if (shortDescription.isEmpty) {
            shortDescription = "ورود ناموفق".tr;
          }
          String supportInfo = '';
          if (response['support'] != null) {
            final support = response['support'] as Map<String, dynamic>;
            supportInfo = 'پشتیبانی:\nTelegram: ${support['telegram'] ?? ''}\nInstagram: ${support['instagram'] ?? ''}';
          }
          Get.snackbar(
            shortDescription,
            '$fullErrorMsg\n\n$supportInfo'.trim(),
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 5),
            titleText: Text(
              shortDescription,
              style: TextStyle(
                fontSize: 16,
                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                fontFamily: 'Sarbaz',
              ),
              textDirection: TextDirection.rtl,
            ),
            messageText: Text(
              '$fullErrorMsg\n\n$supportInfo'.trim(),
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Sarbaz',
                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
              ),
              textDirection: TextDirection.rtl,
            ),
          );
        } else {
          isOtpSent.value = false;
          Get.snackbar(
            'خطای ورود'.tr,
            'وضعیت ورود غیرمنتظره دریافت شد'.tr,
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 5),
          );
        }
      } catch (e) {
        errorMessage.value = "خطای شبکه. لطفاً اتصال خود را بررسی کنید.".tr;
        Get.snackbar(
          'خطای ورود',
          errorMessage.value,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 5),
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> verifyOtp(String otp) async {
    isLoading.value = true;
    try {
      bool result = await httpService.verifyOtp(int.parse(otp));
      if (result) {
        setLoggedIn(true);
        storage.write('access_token', httpService.accessToken);
        storage.write('access_token_expiry', httpService.accessTokenExpiry?.toIso8601String() ?? '');
        sessionId.value = '';
        _countdownTimer?.cancel();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.currentRoute != '/home') {
            Get.offAllNamed('/home');
          }
        });
      }
    } catch (e) {
      isOtpValid.value = false;
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      Get.snackbar(
        'خطای تأیید OTP'.tr,
        errorMessage.value.tr,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 5),
        titleText: Text(
          'خطای تأیید OTP'.tr,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Sarbaz',
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
          textDirection: TextDirection.rtl,
        ),
        messageText: Text(
          errorMessage.value.tr,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Sarbaz',
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
          textDirection: TextDirection.rtl,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
  String decode(String rawResponse) {
    List<int> responseBytes = rawResponse.codeUnits;
    String decoded = utf8.decode(responseBytes, allowMalformed: true);
    return decoded;
  }
  Future<void> resendOtp() async {
    if (isResendButtonDisabled.value) return;

    if (username.value.isEmpty || password.value.isEmpty) {
      Get.snackbar('Error'.tr, 'Username and password are required for resending OTP'.tr, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      final response = await httpService.resendOtpForLogin(username.value, password.value);
      print('Resend OTP Response: $response');

      String message = decode(response['message'] ?? '');
      if (message.contains("ارسال شد") || response.containsKey('sms_result') && response['sms_result']['success'] == true) {
        isOtpSent.value = true;
        countdown.value = 120;
        isResendButtonDisabled.value = true;
        startCountdown();
        Get.snackbar(
          'OTP Resent'.tr,
          'A new OTP has been sent to'.tr,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 3),
        );
      } else {
        String errorMsg = message.isNotEmpty ? message : "Failed to resend OTP".tr;
        Get.snackbar("Error".tr, errorMsg.tr,         snackPosition: SnackPosition.TOP,);
      }
    } catch (e) {
      print('Error resending OTP: $e');
      Get.snackbar(
        'Error'.tr,
        "Error in resending otp.".tr,
        snackPosition: SnackPosition.TOP,
      );
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

  Future<void> clearSession() async {
    await storage.erase();
    isOtpValid.value = false;
    isOtpSent.value = false;
    sessionId.value = '';
    _countdownTimer?.cancel();
  }

  void _showOtpInSnackbar() {
    if (otpReceived.isNotEmpty) {
      Get.snackbar(
        'OTP Received',
        'Your OTP is: ${otpReceived.value}',
        snackPosition: SnackPosition.TOP,
        duration: Duration(days: 365),
        isDismissible: true,
        mainButton: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Close'),
        ),
        colorText: Colors.transparent.withOpacity(0.75),
        borderRadius: 10,
        margin: EdgeInsets.all(16),
      );
    }
  }

  bool isAccessTokenExpired() {
    final expiryString = storage.read('access_token_expiry');
    if (expiryString == null) return true;
    final expiry = DateTime.parse(expiryString);
    return DateTime.now().isAfter(expiry);
  }

  String? getAccessToken() => storage.read('access_token');

  var isUsernameValid = false.obs;
  var isPasswordValid = false.obs;

  void updateUsername(String value) {
    username.value = value;
    isUsernameValid.value = value.isNotEmpty;
  }

  void updatePassword(String value) {
    password.value = value;
    isPasswordValid.value = value.isNotEmpty;
  }

  var otpTextLength = 0.obs;

  void updateOtpLength(String otp) {
    otpTextLength.value = otp.length;
    isOtpValid.value = otp.length >= 4;
  }

  bool isotpValid() {
    if (otpTextLength.value > 3) {
      isOtpValid.value = true;
      return true;
    } else {
      isOtpValid.value = false;
      return false;
    }
  }

  Color get reactiveButtonColor {
    return otpTextLength.value >= 4 ? Colors.yellow.shade600 : Colors.grey.shade400;
  }

  bool isFormValid() {
    return isUsernameValid.value && isPasswordValid.value;
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }
}
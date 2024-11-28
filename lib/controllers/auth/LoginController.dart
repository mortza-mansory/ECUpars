import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:treenode/services/api/HttpService.dart';

class LoginController extends GetxController {
  var isLoggedIn = false.obs;
  var isOtpValid = false.obs;
  var isOtpSent = false.obs;
  var sessionId = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var otpReceived = ''.obs;  // This will store OTP from the server

  final HttpService httpService = HttpService();
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    sessionId.value = storage.read('session_id') ?? '';
    isLoggedIn.value = storage.read('is_logged_in') ?? false;
  }

  Future<void> login(String username, String password) async {
    logout();
    isLoading.value = true;
    try {
      final response = await httpService.login(username, password);
      if (response['login_status'] == 'pending') {
        sessionId.value = response['session_id'];
        isOtpSent.value = true;
        storage.write('session_id', sessionId.value);

        // Fetch the OTP from the response and show it in the Snackbar
        otpReceived.value = response['otp'].toString();  // Assuming OTP is part of the response
        _showOtpInSnackbar();
      } else {
        isOtpSent.value = false;
        errorMessage.value = "Login failed. Please try again.";
      }
    } catch (e) {
      errorMessage.value = "An error occurred during login.";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String otp) async {
    isLoading.value = true;
    try {
      bool result = await httpService.verifyOtp(int.parse(otp));
      if (result) {
        isLoggedIn.value = true;
        storage.write('is_logged_in', true);
        storage.write('access_token', httpService.accessToken);
        storage.write('access_token_expiry', httpService.accessTokenExpiry?.toIso8601String() ?? '');
        Get.offNamed('/home');
        sessionId.value = '';
      } else {
        isOtpValid.value = false;
        errorMessage.value = "Invalid OTP. Please try again.";
      }
    } catch (e) {
      errorMessage.value = "An error occurred during OTP verification.";
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    storage.erase();
    isLoggedIn.value = false;
    isOtpValid.value = false;
    isOtpSent.value = false;
    sessionId.value = '';
  }

  void _showOtpInSnackbar() {
    if (otpReceived.isNotEmpty) {
      Get.snackbar(
        'OTP Received',
        'Your OTP is: ${otpReceived.value}',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(days: 365),
        isDismissible: true,
        mainButton: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Close'),
        ),
        backgroundColor: Colors.blue,
        colorText: Colors.white,
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

  void updateUsername(String username) {
    isUsernameValid.value = username.isNotEmpty;
  }

  void updatePassword(String password) {
    isPasswordValid.value = password.isNotEmpty;
  }

  bool isFormValid() {
    return isUsernameValid.value && isPasswordValid.value;
  }
}

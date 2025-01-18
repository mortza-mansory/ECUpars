import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:treenode/services/api/HttpService.dart';
import 'package:treenode/views/auth/startScreen.dart';
import 'package:treenode/views/auth/otpScreen.dart';

class LoginController extends GetxController {
  var _isLoggedIn = false.obs;
  var isOtpValid = false.obs;
  var isOtpSent = false.obs;
  var sessionId = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var otpReceived = ''.obs;

  final HttpService httpService = HttpService();
  final GetStorage storage = GetStorage();

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
    try {
      final response = await httpService.login(username, password);

      if (response.isEmpty) {
        // Handle empty response from the HTTP service
        errorMessage.value = "Login failed. Server returned an empty response.";
        return;
      }

      if (response['login_status'] == 'pending') {
        sessionId.value = response['session_id'];
        isOtpSent.value = true;
        storage.write('session_id', sessionId.value);
        otpReceived.value = response['otp'].toString();
        Get.to(() => OtpScreen());
        _showOtpInSnackbar();
      } else if (response['login_status'] == 'failed') {
        isOtpSent.value = false;
        errorMessage.value = response['error'] ?? "Invalid username or password.";
        Get.snackbar(
          'Login Failed',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
        );
      } else {
        isOtpSent.value = false;
        errorMessage.value = "Unexpected login status: ${response['login_status']}.";
      }
    } catch (e) {
      errorMessage.value = "An error occurred during login: $e";
      Get.snackbar(
        'Login Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> verifyOtp(String otp) async {
    isLoading.value = true;
    try {
      print("Starting OTP verification...");
      bool result = await httpService.verifyOtp(int.parse(otp));
      if (result) {
        print("OTP verified successfully. Navigating to home...");
        setLoggedIn(true);
        storage.write('access_token', httpService.accessToken);
        storage.write(
          'access_token_expiry',
          httpService.accessTokenExpiry?.toIso8601String() ?? '',
        );
        sessionId.value = '';

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.currentRoute != '/home') {
            Get.offAllNamed('/home');
          }
        });
      } else {
        isOtpValid.value = false;
        errorMessage.value = "Invalid OTP. Please try again.";
        print("Invalid OTP entered.");
      }
    } catch (e) {
      errorMessage.value = "An error occurred during OTP verification.";
      print("Error during OTP verification: $e");
    } finally {
      isLoading.value = false;
      print("Finished OTP verification process.");
    }
  }
  // Future<void> logout(BuildContext context) async {
  //   storage.erase();
  //   setLoggedIn(false);
  //   isOtpValid.value = false;
  //   isOtpSent.value = false;
  //   sessionId.value = '';
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Get.offAndToNamed('/start');
  //   });
  // }

  Future<void> clearSession() async {
    //BUG login after log out its here:
   // await setLoggedIn(false);
    await storage.erase();
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

  void updateUsername(String username) {
    isUsernameValid.value = username.isNotEmpty;
  }

  void updatePassword(String password) {
    isPasswordValid.value = password.isNotEmpty;
  }

  var otpTextLength = 0.obs;

  void updateOtpLength(String otp) {
    otpTextLength.value = otp.length;
    isOtpValid.value = otp.length >= 4;
  }

  bool isotpValid(){
    if(otpTextLength.value >3)
      {
        isOtpValid.value = true;
        return true;
      }else{
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


}

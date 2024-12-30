import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'dart:async';

class ConnectionController extends GetxController {
  RxBool isCheckingConnection = true.obs;
  RxBool isConnected = false.obs;
  RxString connectionStatusMessage = "Checking internet connection...".obs;
  Timer? snackbarTimer;

  @override
  void onInit() {
    super.onInit();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    isCheckingConnection.value = true;
    connectionStatusMessage.value = "Checking internet connection...".tr;

    final connection = InternetConnection.createInstance(
      customCheckOptions: [
        InternetCheckOption(uri: Uri.parse('https://icanhazip.com/')),
      ],
    );

    bool isConnectedNow = await connection.hasInternetAccess;

    if (!isConnectedNow) {
      isConnected.value = false;
      connectionStatusMessage.value = "No internet connection!".tr;

      snackbarTimer?.cancel();
      snackbarTimer = Timer.periodic(Duration(seconds: 30), (timer) {
        if (!isConnected.value) {
          Get.snackbar(
            'No Internet Connection'.tr,
            'Please check your connection and try again.'.tr,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            duration: Duration(seconds: 20),
            colorText: Colors.white,
          );
        }
      });
    } else {
      isConnected.value = true;
     // connectionStatusMessage.value = "Connected to the internet!".tr;

      snackbarTimer?.cancel();
      //
      // Get.snackbar(
      //   'Connected'.tr,
      //   'You are now connected to the internet!'.tr,
      //   snackPosition: SnackPosition.TOP,
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      //   duration: Duration(seconds: 3),
      // );

    }

    isCheckingConnection.value = false;
  }

  void retryConnection() {
    checkInternetConnection();
  }
}

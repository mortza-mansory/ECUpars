import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/services/api/HttpService.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class BuyProController extends GetxController {
  final HttpService _httpService = HttpService();

  var isLoading = false.obs;
  var plans = <Map<String, dynamic>>[].obs;
  var scannedCode = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  Map<String, dynamic> _decodeUtf8(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is String) {
        return MapEntry(key, utf8.decode(value.runes.toList(), allowMalformed: true));
      } else {
        return MapEntry(key, value);
      }
    });
  }

  void fetchPlans() async {
    isLoading.value = true;
    try {
      var fetchedPlans = await _httpService.fetchSubscriptionPlans();
      List<Map<String, dynamic>> decodedPlans =
      fetchedPlans.map((plan) => _decodeUtf8(plan)).toList();

      // Adjust prices by removing one zero (divide by 10)
      List<Map<String, dynamic>> adjustedPlans = decodedPlans.map((plan) {
        var adjustedPlan = Map<String, dynamic>.from(plan);
        if (adjustedPlan['price'] != null) {
          num price = num.parse(adjustedPlan['price'].toString());
          adjustedPlan['price'] = price / 10;
        }
        return adjustedPlan;
      }).toList();

      // Apply custom names and descriptions
      List<Map<String, dynamic>> modifiedPlans = [
        {
          ...adjustedPlans[0],
          'name': 'سطح برنزی',
          'description': 'دسترسی به کدهای خطای تمامی برندها'
        },
        {
          ...adjustedPlans[1],
          'name': 'سطح نقره ای',
          'description': 'دسترسی به دسته کارشناس شو + سطح برنزی'
        },
        {
          ...adjustedPlans[2],
          'name': 'سطح طلایی',
          'description': 'دسترسی کامل به جانمایی قطعات و نقشه ها و درخت های عیب یابی'
        }
      ];
      plans.assignAll(modifiedPlans);
    } catch (e) {
      print("Error fetching plans: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void subscribeToPlan(int planId, String userPhone, String userEmail, {String? discountCode}) async {
    isLoading.value = true;
    try {
      var paymentResponse = await _httpService.requestPayment(
        planId: planId,
        userPhone: userPhone,
        userEmail: userEmail,
        discountCode: discountCode,
      );

      if (paymentResponse.containsKey('error')) {
        Get.snackbar("Error", paymentResponse['error']);
        return;
      }

      if (paymentResponse.containsKey('payment_url')) {
        String paymentUrl = paymentResponse['payment_url'];
        if (await canLaunch(paymentUrl)) {
          await launch(paymentUrl);
        } else {
          print("Could not launch payment URL");
        }
      } else {
        print("No payment URL in response");
      }
    } catch (e) {
      print("Error subscribing to plan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void checkPaymentStatus(int paymentId) async {
    isLoading.value = true;
    try {
      var statusResponse = await _httpService.checkPaymentStatus(paymentId);
      var decodedResponse = _decodeUtf8(statusResponse);

      if (decodedResponse['status'] == 'paid') {
        Get.snackbar(
          "موفقیت",
          "پرداخت با موفقیت انجام شده است. شماره ارجاع: ${decodedResponse['ref_id']}",
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          "وضعیت پرداخت",
          "وضعیت پرداخت: ${decodedResponse['status']}",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطا",
        "خطا در بررسی وضعیت پرداخت: $e",
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateScannedCode(String rawData) {
    final regex = RegExp(r'^ecupars/(.*)');
    final match = regex.firstMatch(rawData);
    if (match != null) {
      scannedCode.value = match.group(1) ?? "";
    }
  }

  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.request();
    return status.isGranted;
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/account/AccountController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

class DayRemaining extends StatelessWidget {
  final double width;

  const DayRemaining({Key? key, this.width = double.infinity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accountController = Get.find<AccountController>();
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      int remainingDays = accountController.remainingSubscriptionDays;
      double progress = accountController.subscriptionProgress;
      print(progress);
      return Container(
        width: width,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: width * progress,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 253, 107, 107),
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Days remaining :".tr,
                  style: TextStyle(
                    color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.072,
                    fontFamily: 'Vazir',
                  ),
                ),
                SizedBox(width: width * 0.06),
                Text(
                  "$remainingDays",
                  style: TextStyle(
                    color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Sarbaz',
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
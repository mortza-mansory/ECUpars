import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/account/AccountController.dart';
import 'package:treenode/controllers/auth/LoginController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReferralScreen extends StatelessWidget {
  ReferralScreen({super.key});

  final ThemeController themeController = Get.find<ThemeController>();
  final LoginController loginController = Get.find<LoginController>();
  final AccountController accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {

    accountController.fetchReferralCode();

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeController.isDarkTheme.value
            ? const Color.fromRGBO(44, 45, 49, 1)
            : const Color.fromRGBO(255, 255, 255, 1.0),
        iconTheme: IconThemeData(
          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          "Referral".tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: "Sarbaz",
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(w * 0.03, 0, w * 0.03, 0),
        child: Column(
          children: [
            SizedBox(height: w * 0.04),
            Container(
              height: h * 0.18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.yellow.shade800.withOpacity(0.7),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(w * 0.03, h * 0.025, w * 0.03, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "با معرفی دوستان‌تان، در این مسیر ارزشمند سهیم باشید.".tr,
                          style: TextStyle(
                              fontSize: w * 0.034,
                              fontFamily: "Sarbaz",
                              color: themeController.isDarkTheme.value ? Colors.white : Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: w * 0.018),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "فرصتی برای تجربه‌ی یک همکاری پربار در کنار ما منتظر شماست.".tr,
                          style: TextStyle(
                              fontSize: w * 0.025,
                              fontWeight: FontWeight.normal,
                              fontFamily: "Vazir",
                              color: themeController.isDarkTheme.value ? Colors.white : Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: w * 0.02),
                    Row(
                      children: [
                        Text(
                          "برای دریافت اطلاعات بیشتر، کافیه با پشتیبانی در ارتباط باشید.".tr,
                          style: TextStyle(
                              fontSize: w * 0.026,
                              fontFamily: "Vazir",
                              color: themeController.isDarkTheme.value ? Colors.white : Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: w * 0.02),
            Container(
              height: h * 0.11,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.redAccent.shade400.withOpacity(0.2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Your referral code".tr,
                        style: TextStyle(
                            fontSize: w * 0.03,
                            fontFamily: "Sarbaz",
                            color: themeController.isDarkTheme.value ? Colors.white : Colors.black),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(w * 0.1, 0, w * 0.1, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await accountController.fetchReferralCode();
                          },
                          icon: Icon(
                            Icons.refresh_outlined,
                            size: w * 0.06,
                          ),
                        ),
                        Obx(() {
                          String code = accountController.referralCode.value;
                          return Text(
                            code.isNotEmpty ? code : "xxxx",
                            style: TextStyle(
                                fontSize: w * 0.06,
                                color: themeController.isDarkTheme.value ? Colors.white : Colors.black),
                          );
                        }),
                        IconButton(
                          onPressed: () {
                            String code = accountController.referralCode.value;
                            Clipboard.setData(ClipboardData(text: code));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Referral code copied!".tr)),
                            );
                          },
                          icon: Icon(
                            Icons.copy,
                            size: w * 0.06,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: w * 0.02),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(w * 0.9, h * 0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: themeController.isDarkTheme.value
                    ? Colors.grey.shade800
                    : Colors.white,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: themeController.isDarkTheme.value
                      ? Colors.grey.shade900
                      : Colors.white,
                  isScrollControlled: true,
                  builder: (_) {
                    return Container(
                      width: double.infinity,
                      height: h * 0.6,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              "Invitees".tr,
                              style: TextStyle(
                                fontSize: w * 0.05,
                                fontFamily: "Sarbaz",
                                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: Obx(() {
                                if (accountController.referredUsers.isEmpty) {
                                  return Center(
                                    child: Text(
                                      "No invitees available".tr,
                                      style: TextStyle(
                                        fontSize: w * 0.04,
                                        fontFamily: "Sarbaz",
                                        color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  );
                                } else {
                                  return SingleChildScrollView(
                                    child: Column(
                                      children: accountController.referredUsers.map((invitee) {
                                        var subscription = invitee['subscriptions']?.isNotEmpty == true
                                            ? invitee['subscriptions'][0]
                                            : null;
                                        return Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: themeController.isDarkTheme.value
                                                ? Colors.grey.shade700
                                                : Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: themeController.isDarkTheme.value
                                                  ? Colors.grey.shade500
                                                  : Colors.grey,
                                            ),
                                          ),
                                          child: Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "User ID: ${invitee['user_id'] ?? 'Unknown'}".tr,
                                                    style: TextStyle(
                                                      fontSize: w * 0.04,
                                                      fontFamily: "Sarbaz",
                                                      color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(height: h * 0.01),
                                                  Text(
                                                    "Referral Code: ${invitee['referral_code'] ?? 'No Code'}".tr,
                                                    style: TextStyle(
                                                      fontSize: w * 0.035,
                                                      fontFamily: "Sarbaz",
                                                      color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                                                    ),
                                                  ),
                                                  if (subscription != null) ...[
                                                    SizedBox(height: h * 0.01),
                                                    Text(
                                                      "Plan: ${subscription['plan_name'] ?? 'Unknown'}".tr,
                                                      style: TextStyle(
                                                        fontSize: w * 0.035,
                                                        fontFamily: "Sarbaz",
                                                        color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(height: h * 0.01),
                                                    Text(
                                                      "Purchase Date: ${subscription['purchase_date'] ?? 'N/A'}".tr,
                                                      style: TextStyle(
                                                        fontSize: w * 0.035,
                                                        fontFamily: "Sarbaz",
                                                        color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(height: h * 0.01),
                                                    Text(
                                                      "Amount Paid: ${subscription['amount_paid'] ?? 'N/A'}".tr,
                                                      style: TextStyle(
                                                        fontSize: w * 0.035,
                                                        fontFamily: "Sarbaz",
                                                        color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                }
                              }),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(w * 0.01, 0, w * 0.05, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                            ),
                          ),
                          child: Icon(
                            Icons.people_alt_outlined,
                            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                            size: w * 0.09,
                          ),
                        ),
                        SizedBox(width: w * 0.04),
                        Text(
                          "Invitees".tr,
                          style: TextStyle(
                            fontSize: w * 0.03,
                            fontFamily: "Sarbaz",
                            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                          size: w * 0.05,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: w * 0.02),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(w * 0.9, h * 0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                _copyToClipboard();
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(w * 0.01, 0, w * 0.05, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.black)),
                          child: Icon(
                            Icons.share_outlined,
                            color: Colors.black,
                            size: w * 0.09,
                          ),
                        ),
                        SizedBox(width: w * 0.04),
                        Text(
                          "Referral Link".tr,
                          style: TextStyle(
                              fontSize: w * 0.03,
                              fontFamily: "Sarbaz",
                              color: Colors.black),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: w * 0.05,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: w * 0.02),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(w * 0.9, h * 0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                String code = accountController.referralCode.value;
                String qrData = "ecupars/$code";
                showModalBottomSheet(
                  context: context,
                  builder: (_) => Container(
                    width: w,
                    height: h * 0.4,
                    padding: EdgeInsets.all(20),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, h * 0.02, 0, h * 0.02),
                      child: Column(
                        children: [
                          QrImageView(
                            data: qrData,
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                          SizedBox(height: w * 0.04),
                          Text("Scan EcuPars to get discount!".tr)
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(w * 0.01, 0, w * 0.05, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.black)),
                          child: Icon(
                            Icons.qr_code,
                            color: Colors.black,
                            size: w * 0.09,
                          ),
                        ),
                        SizedBox(width: w * 0.04),
                        Text(
                          "QR Code".tr,
                          style: TextStyle(
                              fontSize: w * 0.03,
                              fontFamily: "Sarbaz",
                              color: Colors.black),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: w * 0.05,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: w * 0.02),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: "https://ecupars.ir"));
    Get.snackbar("Link is copied!".tr, "");
  }
}
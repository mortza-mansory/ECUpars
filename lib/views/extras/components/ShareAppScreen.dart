import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class ShareAppScreen extends StatelessWidget {
  ShareAppScreen({Key? key}) : super(key: key);

  final ThemeController themeController = Get.find<ThemeController>();
  final String link = 'https://ecupars.ir';

  Future<void> _openUrl() async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      Get.snackbar("Error", "Could not launch URL");
    }
  }

  void _showQrCode(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        width: width,
        height: height * 0.4,
        padding: const EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, height * 0.02, 0, height * 0.02),
          child: Column(
            children: [
              QrImageView(
                data: link,
                version: QrVersions.auto,
                size: 200.0,
              ),
              SizedBox(height: width * 0.04),
              Text("Scan ECU Pars to get discount!".tr),
            ],
          ),
        ),
      ),
    );
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: link));
    Get.snackbar("Link is copied!".tr, "");
  }

  @override
  Widget build(BuildContext context) {
    double a = MediaQuery.of(context).size.width;
    double n = 0.4 * a;
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
          "Share App".tr,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              "Recommend ECU Pars to friends".tr,
              style: TextStyle(
                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
              ),
            ),
            Text(
              "nearby without Internet.".tr,
              style: TextStyle(
                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(n, 53),
                    backgroundColor: Colors.yellow.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onPressed: () {
                    _showQrCode(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "QR code".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Sarbaz',
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(n, 53),
                    backgroundColor: Colors.yellow.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onPressed: () {
                    _openUrl();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Open URL".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Sarbaz',
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // QR Code icon: shows modal with QR code
                GestureDetector(
                  onTap: () => _showQrCode(context),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.yellow.shade600,
                        ),
                        child: const Icon(Icons.qr_code, color: Colors.white),
                      ),
                      Text(
                        "Qr Code".tr,
                        style: TextStyle(
                          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // URL icon: copies link to clipboard
                GestureDetector(
                  onTap: _copyToClipboard,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepOrangeAccent,
                        ),
                        child: const Icon(Icons.whatshot, color: Colors.white),
                      ),
                      Text(
                        "URL".tr,
                        style: TextStyle(
                          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Facebook icon: opens the link in browser
                GestureDetector(
                  onTap: _openUrl,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                        child: const Icon(Icons.facebook, color: Colors.white),
                      ),
                      Text(
                        "Facebook".tr,
                        style: TextStyle(
                          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // More icon: opens the link in browser
                GestureDetector(
                  onTap: _openUrl,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                        child: const Icon(Icons.more_horiz_outlined, color: Colors.white),
                      ),
                      Text(
                        "More".tr,
                        style: TextStyle(
                          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

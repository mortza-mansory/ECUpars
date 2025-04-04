import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:url_launcher/url_launcher.dart';

class Contactsupportscreen extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();

  _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeController.isDarkTheme.value
            ? const Color.fromRGBO(44, 45, 49, 1)
            : Colors.white,
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
          "Contact Support".tr,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            fontFamily: 'Sarbaz',
          ),
        ),
        centerTitle: true,
      ),
      body:Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: themeController.isDarkTheme.value
                ? [
              Color(0xFF8B5A5A).withOpacity(0), // Darkened, muted red (icy in dark)
              Color(0xFFB07A7A).withOpacity(0.6), // Cooler, desaturated red
              Color(0xFF9F6B6B).withOpacity(0.1), // Frosty reddish-brown
            ]
                : [
              Color(0xFFFFF2E2).withOpacity(0.9), // Original peach, lightened
              Colors.redAccent.shade100.withOpacity(0.7), // Soft red, frosty
              Color(0xFFFFE8D6).withOpacity(0.8), // Cooler peach variant
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: themeController.isDarkTheme.value
                      ? Color(0xFFB07A7A).withOpacity(0.6)
                      : Colors.redAccent.shade200.withOpacity(0.8),
                  width: 4, // Bold icy border
                ),
                gradient: LinearGradient(
                  colors: themeController.isDarkTheme.value
                      ? [
                    Color(0xFF8B5A5A).withOpacity(0.5),
                    Color(0xFFA66D6D).withOpacity(0.3),
                  ]
                      : [
                    Color(0xFFFFF2E2).withOpacity(0.7),
                    Colors.redAccent.withOpacity(0.5),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: themeController.isDarkTheme.value
                        ? Color(0xFFB07A7A).withOpacity(0.2)
                        : Colors.redAccent.shade100.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "با مااز طریق پل های زیر در ارتباط باشید...".tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sarbaz',
                      color: themeController.isDarkTheme.value
                          ? Color(0xFFD9A7A7)
                          : Colors.redAccent.shade400,
                      shadows: [
                        Shadow(
                          color: themeController.isDarkTheme.value
                              ? Color(0xFFB07A7A).withOpacity(0.5)
                              : Colors.redAccent.shade200.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: h*0.06),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialIcon(
                            imagePath: "assets/png/insta.png",
                            color: Colors.redAccent.shade200,
                            label: "Instagram".tr,
                            url: "https://www.instagram.com/ecupars",
                          ),
                          SizedBox(width: h*0.08),
                          _buildSocialIcon(
                            imagePath: "assets/png/tel.png",
                            color: Color(0xFFFFE8D6),
                            label: "Telegram".tr,
                            url: "https://t.me/ecupars",
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: h*0.012),

                          _buildSocialIcon(
                            imagePath: 'assets/png/email.png',
                            color: Colors.redAccent.shade100,
                            label: "Email".tr,
                            url: "mailto:ecupars@gmail.com",
                          ),
                          SizedBox(width: h*0.089),
                          _buildSocialIcon(
                            imagePath: "assets/png/net.png",
                            color: Color(0xFFFAD9C9),
                            label: "Website".tr,
                            url: "https://www.ecupars.ir",
                          ),
                        ],
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      )
      ,
    );
  }

  Widget _buildSocialIcon({
    required String imagePath,
    required Color color,
    required String label,
    required String url,
  }) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.9),
              border: Border.all(
                color: themeController.isDarkTheme.value
                    ? Colors.blueGrey.withOpacity(0.00009)
                    : Colors.white.withOpacity(0.8),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: themeController.isDarkTheme.value
                      ? Colors.cyan.withOpacity(0.3)
                      :Color(0xFFFFE8D6).withOpacity(0.8),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.2),
                  color.withOpacity(0.6),
                ],
              ),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 30,
                height: 30,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Vazir',
              color: themeController.isDarkTheme.value
                  ? Colors.redAccent.shade100
                  : Color(0xFFFFE8D6).withOpacity(0.8), // Cooler peach variant

            ),
          ),
        ],
      ),
    );
  }
}
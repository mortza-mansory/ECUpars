import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

class ShareAppScreen extends StatelessWidget {
  ShareAppScreen({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    double a = MediaQuery.of(context).size.width;
    double n = 0.4 * a;
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: themeController.isDarkTheme.value
            ? Color.fromRGBO(44, 45, 49, 1)
            : Color.fromRGBO(255, 250, 244, 1),
        iconTheme: IconThemeData(
          color: themeController.isDarkTheme.value
              ? Colors.white
              : Colors.black,
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Share App".tr,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeController.isDarkTheme.value
                ? Colors.white
                : Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              "Recommend ECU Pars to friends".tr,
              style: TextStyle(
                color: themeController.isDarkTheme.value
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            Text("nearby without Internet.".tr,
              style: TextStyle(
              color: themeController.isDarkTheme.value
                  ? Colors.white
                  : Colors.black,
            ),),
            SizedBox(height: 20,),

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
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onPressed: () {
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20,8,20,8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "QR code".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Sarbaz',
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ), SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(n, 53),
                    backgroundColor: Colors.yellow.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onPressed: () {
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20,8,20,8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Open URL".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
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

            Spacer(),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: themeController.isDarkTheme.value
                        ? Colors.white
                        : Colors.white10,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "Share Via".tr,
                    style: TextStyle(
                      color: themeController.isDarkTheme.value
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: themeController.isDarkTheme.value
                        ? Colors.white
                        : Colors.white10,
                    thickness: 1,
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellow.shade600,
                      ),
                      child: Icon(Icons.qr_code, color: Colors.white),
                    ),
                    Text(
                      "Qr Code".tr,
                      style: TextStyle(
                        color: themeController.isDarkTheme.value
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 20),

                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.deepOrangeAccent,
                      ),
                      child: Icon(Icons.whatshot, color: Colors.white),
                    ),
                    Text(
                      "URL".tr,
                      style: TextStyle(
                        color: themeController.isDarkTheme.value
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 20),

                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent.shade400,
                      ),
                      child: Icon(Icons.facebook, color: Colors.white),
                    ),
                    Text(
                      "Facebook".tr,
                      style: TextStyle(
                        color: themeController.isDarkTheme.value
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 20),

                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: Icon(Icons.more_horiz_outlined, color: Colors.white),
                    ),
                    Text(
                      "More".tr,
                      style: TextStyle(
                        color: themeController.isDarkTheme.value
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/utills/LangController.dart';
import '../../controllers/utills/ThemeController.dart';

class heroScreen extends StatelessWidget {
  const heroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LangController langController = Get.find<LangController>();
    final ThemeController themeController = Get.find<ThemeController>();
    bool logo = true;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      themeController.toggleTheme();
                    },
                    icon: Icon(
                        logo ? Icons.light_mode : Icons.nightlight_outlined)),
                DropdownButton<String>(
                  value: langController.selectedLanguage.value,
                  onChanged: (String? value) {
                    if (value != null) {
                      langController.changeLanguage(value);
                    }
                  },
                  items: [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'es', child: Text('Español')),
                    DropdownMenuItem(value: 'fr', child: Text('فارسی')),
                  ],
                  underline: SizedBox.shrink(),
                ),

              ],
            ),
            SizedBox(
              height: 240,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(320, 60),
                    elevation: 7,
                    backgroundColor: Colors.yellow.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.credit_card_outlined,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 90,
                        ),
                        Text(
                          "Sign up".tr,
                          style: TextStyle(color: Colors.black, fontFamily: 'Sarbaz', fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(320, 60),
                    elevation: 7,
                    shadowColor: Colors.black,
                    backgroundColor: Colors.yellow.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onPressed: () {
                    Get.toNamed('/l');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.login_rounded,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 90,
                        ),
                        Text(
                          "Login".tr,
                          style: TextStyle(color: Colors.black, fontFamily: 'Sarbaz', fontSize: 20),
                        ),
                      ],
                    ),
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

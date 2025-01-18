import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:treenode/controllers/auth/AccessController.dart';
import 'package:treenode/controllers/middleware/AuthMiddleController.dart';
import 'package:treenode/views/loading/LoadingScreen.dart';
import 'package:treenode/controllers/utills/components/appTheme.dart';
import 'package:treenode/controllers/utills/components/translator.dart';
import 'package:treenode/views/auth/startScreen.dart';
import 'package:treenode/views/auth/loginScreen.dart';
import 'package:treenode/views/home/homeScreen.dart';
import 'bindings/bindings.dart';
import 'controllers/utills/LangController.dart';
import 'controllers/utills/ThemeController.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(ECUPARS());
}

class ECUPARS extends StatelessWidget {
  const ECUPARS({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController(), permanent: true);
    final LangController langController = Get.put(LangController(), permanent: true);
    final AccessController accessController = Get.put(AccessController(), permanent:  true);
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: MyBindings(),
        getPages: [
          GetPage(name: '/loading', page: () => LoadingScreen(),),
          GetPage(name: '/l', page: () => LoginScreen()),
          GetPage(name: '/start', page: () => StartScreen()),
          GetPage(name: '/home', page: () => Homescreen(),middlewares:[AuthMiddleware()]),
        ],
        initialRoute: '/loading',
        title: 'TreeNode',
        theme: themeController.isDarkTheme.value
            ? AppTheme.darkTheme
            : AppTheme.lightTheme,
        locale: Locale(langController.selectedLanguage.value),
        fallbackLocale: Locale('en'),
        translations: Translator(),

      );
    });
  }
}

import 'package:get/get.dart';
import 'package:treenode/controllers/api/ApiController.dart';
import 'package:treenode/controllers/auth/LoginController.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/NavigationController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

class MyBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(LangController());
    Get.put(ThemeController());
    Get.put(NavigationController());
    Get.lazyPut(() => ApiController());

  }
}

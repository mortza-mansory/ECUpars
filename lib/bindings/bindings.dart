import 'package:get/get.dart';
import 'package:treenode/controllers/api/ApiAds.dart';
import 'package:treenode/controllers/api/ApiCategory.dart';
import 'package:treenode/controllers/api/ApiController.dart';
import 'package:treenode/controllers/api/ApiIssus.dart';
import 'package:treenode/controllers/auth/LoginController.dart';
import 'package:treenode/controllers/connection/ConnectionController.dart';
import 'package:treenode/controllers/errors/ErrorController.dart';
import 'package:treenode/controllers/loading/LoadingController.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/NavigationController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

class MyBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ErrorController());
    Get.put(ConnectionController());
    Get.put(LoginController());
    Get.put(LangController());
    Get.put(ThemeController());
    Get.put(NavigationController());
    Get.put(ApiController());
    Get.put(LoadingController());
    Get.put(CategoryController());
    Get.lazyPut(() => IssuesController());
    Get.put(ApiAds());
  }
}

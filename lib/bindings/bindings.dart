import 'package:get/get.dart';
import 'package:treenode/controllers/account/AccountController.dart';
import 'package:treenode/controllers/api/ApiAds.dart';
import 'package:treenode/controllers/api/ApiCategory.dart';
import 'package:treenode/controllers/api/ApiController.dart';
import 'package:treenode/controllers/api/ApiIssus.dart';
import 'package:treenode/controllers/api/ApiSteps.dart';
import 'package:treenode/controllers/articles/ArticleController.dart';
import 'package:treenode/controllers/articles/ArticlesController.dart';
import 'package:treenode/controllers/auth/AccessController.dart';
import 'package:treenode/controllers/auth/LoginController.dart';
import 'package:treenode/controllers/auth/SignUpController.dart';
import 'package:treenode/controllers/buypro/BuyProController.dart';
import 'package:treenode/controllers/connection/ConnectionController.dart';
import 'package:treenode/controllers/hardware/HardwareController.dart';
import 'package:treenode/controllers/loading/LoadingController.dart';
import 'package:treenode/controllers/saved/SavedController.dart';
import 'package:treenode/controllers/search/SearchController.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/NavigationController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/controllers/window/WindowController.dart';

class MyBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(AccessController());
    Get.lazyPut(()=>HardwareController());
    Get.put(WindowController());
    Get.lazyPut(()=>BuyProController());
    Get.lazyPut(()=>ConnectionController());
    Get.lazyPut(()=>SignUpController());
    Get.put(AccountController());
    Get.put(SearchingController());
    Get.put(LangController());
    Get.put(ThemeController());
    Get.put(NavigationController());
    Get.lazyPut(()=>ApiController());
    Get.put((ArticlesController()));
    Get.lazyPut(()=>SavedController());
    Get.put(StepController());
    Get.put(LoadingController());
    Get.put(CategoryController());
    Get.put(IssueController());
    Get.put(ArticleController());
    Get.lazyPut(()=>ApiAds());
  }
}

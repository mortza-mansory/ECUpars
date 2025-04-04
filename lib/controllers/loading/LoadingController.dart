import 'package:get/get.dart';
import 'package:treenode/controllers/auth/AccessController.dart';
import 'package:treenode/controllers/auth/LoginController.dart';
import 'package:treenode/controllers/api/ApiController.dart';
import 'package:treenode/controllers/auth/SignUpController.dart';

class LoadingController extends GetxController {
  RxBool isLoadingData = false.obs;
  RxBool isAnimationFinished = false.obs;

  LoginController loginController = Get.find<LoginController>();
  SignUpController signipController = Get.find<SignUpController>();
  ApiController apiController = Get.find<ApiController>();
  AccessController accessController = Get.find<AccessController>();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> loadData() async {
    isLoadingData.value = true;
    await apiController.loadPngAssetsFromCache();
    isLoadingData.value = false;

    if (loginController.isLoggedIn) {
      Future.microtask(() => Get.offNamed('/home'));
    } else {
      Future.microtask(() => Get.offNamed('/start'));
    }
  }
}



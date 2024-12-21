import 'package:get/get.dart';
import 'package:treenode/controllers/auth/LoginController.dart';
import 'package:treenode/controllers/api/ApiController.dart';

class LoadingController extends GetxController {
  RxBool isLoadingData = false.obs;
  RxBool isAnimationFinished = false.obs;

  LoginController loginController = Get.find<LoginController>();
  ApiController apiController = Get.find<ApiController>();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> loadData() async {
    isLoadingData.value = true;
    await apiController.loadPngAssetsFromCache();
    isLoadingData.value = false;

    if (loginController.isLoggedIn && !loginController.isAccessTokenExpired()) {
      Future.microtask(() => Get.offNamed('/home'));
    } else {
      Future.microtask(() => Get.offNamed('/start'));
    }
  }
}



// class LoadingController extends GetxController {
//   RxBool isCheckingConnection = true.obs;
//   RxBool isConnected = false.obs;
//   RxBool isLoadingData = false.obs;
//   Rx<LottieComposition?> animationComposition = Rx<LottieComposition?>(null);
//   RxString loadingMessage = "Loading...".obs;
//
//   LoginController loginController = Get.find<LoginController>();
//   ApiController apiController = Get.find<ApiController>();
//
//   @override
//   void onInit() {
//     super.onInit();
//   }
//
//   Future<void> checkInternetConnection() async {
//     loadingMessage.value = "Checking internet connection...";
//     final connection = InternetConnection.createInstance(
//       customCheckOptions: [
//         InternetCheckOption(uri: Uri.parse('https://icanhazip.com/')),
//       ],
//     );
//
//     bool isConnectedNow = await connection.hasInternetAccess;
//
//     if (!isConnectedNow) {
//       isConnected.value = false;
//       isCheckingConnection.value = false;
//       loadingMessage.value = "No Internet Connection!";
//     } else {
//       isConnected.value = true;
//       loadingMessage.value = "Loading cache...";
//       isLoadingData.value = true;
//
//       await apiController.loadPngAssetsFromCache();
//
//       isLoadingData.value = false;
//       loadingMessage.value = "Welcome!";
//       await Future.delayed(Duration(milliseconds: 500));
//
//       if (loginController.isLoggedIn && !loginController.isAccessTokenExpired()) {
//         Future.microtask(() => Get.offNamed('/home'));
//       } else {
//         Future.microtask(() => Get.offNamed('/start'));
//       }
//     }
//   }
//
//
//   void retryConnection() {
//     loadingMessage.value = "Retrying connection...";
//     isCheckingConnection.value = true;
//     checkInternetConnection();
//   }
// }


/*
  Future<void> _loadLottieComposition() async {
    try {
     // final composition = await AssetLottie('assets/animate/RedT2.json').load();
    //  animationComposition.value = composition;
    } catch (e) {
      print("Error loading Lottie composition: $e");
      animationComposition.value = null;
    }
  }
*/
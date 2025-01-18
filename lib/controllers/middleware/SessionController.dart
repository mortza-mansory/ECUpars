import 'package:get/get.dart';
import 'package:treenode/services/api/HttpService.dart';

class SessionController extends GetxController {
  final HttpService httpService = Get.find<HttpService>();

  void handleUnauthorized() {
    // Clear tokens
   // httpService.clearSession();
    // Redirect to login
    Get.offAllNamed('/LoginScreen');
  }
}

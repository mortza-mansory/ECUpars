import 'package:get/get.dart';
import 'package:treenode/services/api/HttpService.dart';

class AccessController extends GetxController {
  final HttpService httpService = HttpService();

  var isRedirecting = false.obs;
  void startRedirect() => isRedirecting.value = true;
  void endRedirect() => isRedirecting.value = false;
  Future<bool> isAccessTokenExpired() async {
    return await httpService.isAccessTokenExpired();
  }

  bool isAccessTokenExpiredSync() {
    return httpService.isAccessTokenExpiredSync();
  }
}

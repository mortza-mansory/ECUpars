import 'package:get/get.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class WindowController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    enableScreenshots();
  }

  Future<void> disableScreenshots() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<void> enableScreenshots() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }
}

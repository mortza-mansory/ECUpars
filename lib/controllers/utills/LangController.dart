import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LangController extends GetxController {
  final GetStorage _storage = GetStorage();
  var selectedLanguage = 'en'.obs;

  bool get isRtl => selectedLanguage.value == 'fa';

  @override
  void onInit() {
    super.onInit();
    selectedLanguage.value = _storage.read('selectedLanguage') ?? 'en';
    updateLocale(selectedLanguage.value);
  }

  void changeLanguage(String langCode) {
    if (langCode != selectedLanguage.value) {
      selectedLanguage.value = langCode;
      _storage.write('selectedLanguage', langCode);
      updateLocale(langCode);
    }
  }

  void updateLocale(String langCode) {
    Get.updateLocale(Locale(langCode));
    Get.forceAppUpdate();

    }
}

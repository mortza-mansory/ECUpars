import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'components/appTheme.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  var isDarkTheme = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkTheme.value = _storage.read('isDarkTheme') ?? false;
    Get.changeTheme(isDarkTheme.value ? AppTheme.darkTheme : AppTheme.lightTheme);
  }

  void toggleTheme() {
    isDarkTheme.value = !isDarkTheme.value;
    _storage.write('isDarkTheme', isDarkTheme.value);
    Get.changeTheme(isDarkTheme.value ? AppTheme.darkTheme : AppTheme.lightTheme);
  }
}

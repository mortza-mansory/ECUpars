import 'package:get/get.dart';
import 'package:platform_device_id_v2/platform_device_id_v2.dart';

class HardwareController extends GetxController {
  RxString? _deviceId;
  @override
  void onInit() {
    fetchDeviceId();
    super.onInit();
  }
  Future<void> fetchDeviceId() async {
    if (_deviceId == null) {
      String? id = await PlatformDeviceId.getDeviceId;
      _deviceId = id?.obs;
      print(_deviceId);
      update();
    }
  }

  String? get deviceId => _deviceId?.value;
}

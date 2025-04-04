///The api doesn't have a endpoint for sending map data's
// Cus of this we still relay without the model or contorllrer for it.
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:treenode/services/api/HttpService.dart';
//
// class MapController extends GetxController {
//   final HttpService httpService = Get.find<HttpService>();
//   var mapData = <String, dynamic>{}.obs;
//   var isLoading = false.obs;
//
//   Future<void> loadMapById(int mapId) async {
//     isLoading.value = true;
//     mapData.clear();
//   }
//
//   void navigateBack() {
//     Get.back();
//   }
//
//   Map<String, dynamic> _decodeUtf8(Map<String, dynamic> map) {
//     return map.map((key, value) {
//       if (value is String) {
//         try {
//           return MapEntry(key, utf8.decode(value.codeUnits, allowMalformed: true));
//         } catch (e) {
//           return MapEntry(key, value);
//         }
//       } else if (value is Map<String, dynamic>) {
//         return MapEntry(key, _decodeUtf8(value));
//       } else {
//         return MapEntry(key, value);
//       }
//     });
//   }
// }
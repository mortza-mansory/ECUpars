import 'package:get/get.dart';
import 'package:treenode/services/api/HttpService.dart';
import 'dart:convert';

class ApiAds extends GetxController {
  final HttpService httpService = HttpService();

  var GatheredAds = <Map<String, dynamic>>[].obs;
  final String baseUrl = 'https://django-noxeas.chbk.app';

  Future<void> loadADS() async {
    try {
      final data = await httpService.fetchAds();
      if (data is List) {
        for (var ad in data) {
          if (ad['title'] != null) {
            ad['title'] = decodeUnicode(ad['title']);
          }
          if (ad['banner'] != null && ad['banner'].startsWith('/media')) {
            ad['banner'] = baseUrl + ad['banner'];
          }
        }
      }
      GatheredAds.value = data;
    } catch (e) {
    }
  }

  String decodeUnicode(String input) {
    var decoded = json.decode('"' + input + '"');
    return decoded;
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:treenode/controllers/connection/ConnectionController.dart';
import 'package:treenode/services/api/HttpService.dart';

class ApiController extends GetxController {
  var pngAssetsList = <Map<String, dynamic>>[].obs;
  final HttpService _httpService = HttpService();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isCacheLoaded = false.obs;
  final ConnectionController _connectionController = Get.find();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await loadPngAssetsFromCache();
    });
  }

  List<Map<String, dynamic>> _sortAssets(List<Map<String, dynamic>> assets) {
    assets.sort((a, b) {
      int orderA = a['order'] is int
          ? a['order'] as int
          : int.tryParse(a['order'].toString()) ?? 9999;
      int orderB = b['order'] is int
          ? b['order'] as int
          : int.tryParse(b['order'].toString()) ?? 9999;
      return orderA.compareTo(orderB);
    });
    return assets;
  }

  Future<void> loadPngAssetsFromCache() async {
    if (isLoading.value) return;
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/png_assets.json';
      final file = File(filePath);
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          List<dynamic> cachedAssets = jsonDecode(content);
          List<Map<String, dynamic>> assetsList =
          List<Map<String, dynamic>>.from(cachedAssets);
          assetsList = _sortAssets(assetsList);
          pngAssetsList.assignAll(assetsList);
          isCacheLoaded.value = true;
          return;
        }
      }
      await fetchAndCachePngAssets();
    } catch (e) {
      await fetchAndCachePngAssets();
    }
  }

  Future<void> fetchAndCachePngAssets() async {
    if (isLoading.value || isCacheLoaded.value) return;
    isLoading.value = true;
    try {
      final startTime = DateTime.now();
      final assets = await _httpService.fetchPngAssets();
      final duration = DateTime.now().difference(startTime);
      if (assets.isNotEmpty) {
        List<Map<String, dynamic>> mappedAssets =
        List<Map<String, dynamic>>.from(assets);
        mappedAssets = _sortAssets(mappedAssets);
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/png_assets.json';
        final file = File(filePath);
        await file.writeAsString(jsonEncode(mappedAssets));
        pngAssetsList.assignAll(mappedAssets);
        isCacheLoaded.value = true;
        Get.snackbar("Data is updated!".tr, "Have a great time!".tr);
      }
    } catch (e) {
      errorMessage.value = "Error fetching PNG assets: $e";
    } finally {
      isLoading.value = false;
    }
  }

  FontWeight getFontWeight(String fontWeightStr) {
    switch (fontWeightStr) {
      case '100':
        return FontWeight.w100;
      case '200':
        return FontWeight.w200;
      case '300':
        return FontWeight.w300;
      case '400':
        return FontWeight.w400;
      case '500':
        return FontWeight.w500;
      case '600':
        return FontWeight.w600;
      case '700':
        return FontWeight.w700;
      case '800':
        return FontWeight.w800;
      case '900':
        return FontWeight.w900;
      default:
        return FontWeight.normal;
    }
  }
}




/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApiController extends GetxController {
  final pngAssetsList = <Map<String, String>>[
    {'png': 'assets/hello/hello.png', 'text': 'کارشناس شو', 'font': 'Sarbaz','fontW': '700'},
    {'png': 'assets/png/mb.png', 'text': 'Mercedes-Benz', 'font': 'BarlowCondensed','fontW': '700'},
    {'png': 'assets/png/vo.png', 'text': 'VOLVO', 'font': 'BarlowCondensed','fontW': '700'},
    {'png': 'assets/png/sc.png', 'text': 'SCANIA', 'font': 'BarlowCondensed','fontW': '700'},
    {'png': 'assets/png/Cummins.png', 'text': 'Cummins', 'font': 'BarlowCondensed','fontW': '700'},
    {'png': 'assets/png/r.png', 'text': 'Renault', 'font': 'BarlowCondensed','fontW': '700'},
    {'png': 'assets/png/daf.png', 'text': 'DAF', 'font': 'BarlowCondensed','fontW': '700'},
    {'png': 'assets/png/faw.png', 'text': 'FAW', 'font': 'BarlowCondensed','fontW': '700'},
    {'png': 'assets/png/foton.png', 'text': 'FOTON', 'font': 'BarlowCondensed','fontW': '700'},
    {'png': 'assets/png/iveco.png', 'text': 'IVECO', 'font': 'BarlowCondensed','fontW': '700'},
    {'png': 'assets/png/jac.png', 'text': 'JAC', 'font': 'BarlowCondensed','fontW': '700'},
    {'png': 'assets/png/man.png', 'text': 'MAN', 'font': 'BarlowCondensed','fontW': '700'},
  ].obs;


  @override
  void onInit() {
    super.onInit();
    _preloadImages();
  }

  Future<void> _preloadImages() async {
    try {
      for (var asset in pngAssetsList) {
        await precacheImage(AssetImage(asset['png']!), Get.context!);
      }
      print("Assets preloaded successfully.");
    } catch (e) {
      print("Error preloading assets: $e");
    }
  }
  FontWeight getFontWeight(String fontWeightStr) {
    switch (fontWeightStr) {
      case '100':
        return FontWeight.w100;
      case '200':
        return FontWeight.w200;
      case '300':
        return FontWeight.w300;
      case '400':
        return FontWeight.w400;
      case '500':
        return FontWeight.w500;
      case '600':
        return FontWeight.w600;
      case '700':
        return FontWeight.w700;
      case '800':
        return FontWeight.w800;
      case '900':
        return FontWeight.w900;
      default:
        return FontWeight.normal;
    }
  }

}

*/
/*
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:treenode/services/api/HttpService.dart';

class ApiController extends GetxController {
  final HttpService httpService = HttpService();
  var pngAssetsList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (isLoggedIn) {
      fetchPngAssets();
    }
  }

  bool get isLoggedIn => GetStorage().read('is_logged_in') ?? false;

  Future<void> fetchPngAssets() async {
    final cachedAssets = GetStorage().read<List<dynamic>>('png_assets');
    final cacheTimestamp = GetStorage().read<int>('cache_timestamp');

    if (cachedAssets != null && cacheTimestamp != null) {
      final cacheAge = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(cacheTimestamp));

      if (cacheAge < Duration(hours: 72)) {
        pngAssetsList.value = List<Map<String, dynamic>>.from(cachedAssets);
        print("PNG assets loaded from cache.");
        return;
      } else {
        print("Cache expired. Fetching fresh assets...");
      }
    }

    if (!isLoggedIn) {
      print("User is not logged in. Cannot fetch PNG assets.");
      return;
    }

    final assets = await httpService.fetchPngAssets();

    if (assets.isNotEmpty) {
      pngAssetsList.value = assets;
      GetStorage().write('png_assets', assets);
      GetStorage().write('cache_timestamp', DateTime.now().millisecondsSinceEpoch);
      print("PNG assets updated and cached successfully.");
    } else {
      print("No PNG assets found or an error occurred.");
    }
  }
}
 */

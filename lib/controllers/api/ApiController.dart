import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:treenode/services/api/HttpService.dart';

class ApiController extends GetxController {
  final HttpService httpService = HttpService();
  var pngAssetsList = <Map<String, dynamic>>[].obs;

  ApiController() {
    GetStorage.init();
    if (isLoggedIn) {
      fetchPngAssets();
    }
  }

  bool get isLoggedIn => GetStorage().read('is_logged_in') ?? false;

  Future<void> fetchPngAssets() async {
    final cachedAssets = GetStorage().read<List<dynamic>>('png_assets');
    if (cachedAssets != null) {
      pngAssetsList.value = List<Map<String, dynamic>>.from(cachedAssets);
      print("PNG assets loaded from cache.");
      return;
    }

    if (!isLoggedIn) {
      print("User is not logged in. Cannot fetch PNG assets.");
      return;
    }

    final assets = await httpService.fetchPngAssets();
    if (assets.isNotEmpty) {
      pngAssetsList.value = assets;
      GetStorage().write('png_assets', assets);
      print("PNG assets updated and cached successfully.");
    } else {
      print("No PNG assets found or an error occurred.");
    }
  }
}

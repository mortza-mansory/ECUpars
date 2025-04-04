import 'dart:convert';
import 'package:get/get.dart';

import 'package:treenode/services/api/HttpService.dart';
import 'package:treenode/services/com.dart';
import 'package:treenode/views/home/homeScreen.dart';
import 'package:treenode/views/treeView/CategoryScreen.dart';
import 'package:treenode/viewModel/NodeTree.dart';

class CategoryController extends GetxController {
  var category = <String, dynamic>{}.obs;
  var relatedCategories = <dynamic>[].obs;
  var issues = <dynamic>[].obs;
  var articles = <dynamic>[].obs;
  var maps = <dynamic>[].obs;

  final HttpService httpService = Get.put(HttpService());
  final Com com = Com(httpService: HttpService());

  final Map<int, Map<String, dynamic>> categoryCache = {};
  final Map<int, List<dynamic>> relatedCategoriesCache = {};
  final Map<int, List<dynamic>> issuesCache = {};
  final Map<int, List<dynamic>> articlesCache = {};

  final Map<int, List<dynamic>> mapsCache = {};
  int? rootCategoryId;
  var isLoading = false.obs;


  Future<bool> loadCategoryDetails(int categoryId, {bool forceRefresh = false}) async {
    isLoading.value = true;
    category.clear();
    relatedCategories.clear();
    issues.clear();
    articles.clear();
    maps.clear();

    if (!forceRefresh && categoryCache.containsKey(categoryId)) {
      await Future.delayed(Duration(milliseconds: 200));
      category.assignAll(categoryCache[categoryId] ?? <String, dynamic>{});
      relatedCategories.assignAll(relatedCategoriesCache[categoryId] ?? <dynamic>[]);
      issues.assignAll(issuesCache[categoryId] ?? <dynamic>[]);
      articles.assignAll(articlesCache[categoryId] ?? <dynamic>[]);
      maps.assignAll(mapsCache[categoryId] ?? <dynamic>[]);

      isLoading.value = false;
      return true;
    }

    try {
      final Map<dynamic, dynamic> data = await httpService.fetchCategoryDetails(categoryId, true, true);

      final Map<String, dynamic> fetchedCategory =
      _decodeUtf8((data['category'] as Map<dynamic, dynamic>).cast<String, dynamic>());
      final List<dynamic> fetchedRelatedCategories = List<dynamic>.from(
        (data['related_categories'] ?? []).map((cat) {
          final decoded = (cat as Map<dynamic, dynamic>).cast<String, dynamic>();
          return _decodeUtf8(decoded);
        }),
      );
      final List<dynamic> fetchedIssues = List<dynamic>.from(
        (data['issues'] ?? []).map((issue) {
          final decoded = (issue as Map<dynamic, dynamic>).cast<String, dynamic>();
          return _decodeUtf8(decoded);
        }),
      );
      final List<dynamic> fetchedArticles = List<dynamic>.from(
        (data['articles'] ?? []).map((article) {
          final decoded = (article as Map<dynamic, dynamic>).cast<String, dynamic>();
          return _decodeUtf8(decoded);
        }),
      );
      final List<dynamic> fetchedMaps = List<dynamic>.from(
        (data['maps'] ?? []).map((map) {
          final decoded = (map as Map<dynamic, dynamic>).cast<String, dynamic>();
          return _decodeUtf8(decoded);
        }),
      );

      category.assignAll(fetchedCategory);
      relatedCategories.assignAll(fetchedRelatedCategories);
      issues.assignAll(fetchedIssues);
      articles.assignAll(fetchedArticles);
      maps.assignAll(fetchedMaps);

      categoryCache[categoryId] = fetchedCategory;
      relatedCategoriesCache[categoryId] = fetchedRelatedCategories;
      issuesCache[categoryId] = fetchedIssues;
      articlesCache[categoryId] = fetchedArticles;
      mapsCache[categoryId] = fetchedMaps;

      if (fetchedCategory['parent_category'] == null) {
        rootCategoryId = categoryId;
      }

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      if (e.toString().contains("403")) {
        String? errorMessage;
        try {
          final bodyMatch = RegExp(r'- ({.*})').firstMatch(e.toString());
          final responseBody = bodyMatch?.group(1);
          if (responseBody != null) {
            final decodedJson = jsonDecode(responseBody);
            errorMessage = utf8.decode(decodedJson["detail"].toString().codeUnits, allowMalformed: true);
          } else {
            errorMessage = "خطا در دریافت پیام سرور";
          }
        } catch (decodeError) {
          errorMessage = "خطا در پردازش پاسخ سرور";
        }

        if (errorMessage != null) {
          if (errorMessage.contains("شما با این دستگاه دسترسی ندارید")) {
            Get.snackbar(
              "دسترسی محدود".tr,
              "شما با این دستگاه دسترسی ندارید.".tr,
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 5),
            );
          } else if (errorMessage.contains("این شماره در حال حاضر روی دستگاه دیگری فعال است")) {
            Get.snackbar(
              "دسترسی محدود".tr,
              "این شماره در حال حاضر روی دستگاه دیگری فعال است. لطفاً برای راهنمایی بیشتر با پشتیبانی تماس بگیرید.\n\n📌 پشتیبانی:\n🔹 تلگرام و اینستاگرام: @ecupars",
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 5),
            );
          } else {
            Get.snackbar(
              "دسترسی محدود".tr,
              "برای دسترسی به این بخش، لطفاً سطح کاربری خود را ارتقا دهید.".tr,
              snackPosition: SnackPosition.TOP,
            );
          }
        }
      } else {
        Get.snackbar(
          "خطا".tr,
          "مشکلی در بارگیری اطلاعات رخ داده است. لطفاً دوباره تلاش کنید.".tr,
          snackPosition: SnackPosition.TOP,
        );
      }

      return false;
    }
  }

  Map<String, dynamic> _decodeUtf8(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is String) {
        return MapEntry(key, utf8.decode(value.runes.toList(), allowMalformed: true));
      } else {
        return MapEntry(key, value);
      }
    });
  }

  void navigateToCategoryDetails(int categoryId, {bool isRoute = false}) {
    if (isRoute) {
      globalNavigationStack.clear();
      rootCategoryId = categoryId;
      globalNavigationStack.add(NavigationNode(type: NodeType.category, id: categoryId));
    }
    if (globalNavigationStack.isEmpty ||
        globalNavigationStack.last.type != NodeType.category ||
        globalNavigationStack.last.id != categoryId) {
      globalNavigationStack.add(NavigationNode(type: NodeType.category, id: categoryId));
    }

    loadCategoryDetails(categoryId).then((success) {
      if (success) {
        Get.to(() => CategoryScreen(
          categoryId: categoryId,
          isRoot: rootCategoryId == categoryId,
        ));
      } else {
      }
    });
  }

  void navigateBack() {
    if (globalNavigationStack.length > 1) {
      globalNavigationStack.removeLast();
      final previousNode = globalNavigationStack.last;
      if (previousNode.type == NodeType.category) {
        loadCategoryDetails(previousNode.id).then((success) {
          if (success) {
            Get.off(() => CategoryScreen(
              categoryId: previousNode.id,
              isRoot: rootCategoryId == previousNode.id,
            ));
          } else {
          }
        });
      } else {
        Get.back();
      }
    } else if (globalNavigationStack.length == 1) {
      Get.off(()=> Homescreen());
    }
  }
}
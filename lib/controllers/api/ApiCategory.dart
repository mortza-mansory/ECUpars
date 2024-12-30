// import 'package:get/get.dart';
// import 'package:treenode/services/api/HttpService.dart';
// import 'package:treenode/services/com.dart';
// import 'package:treenode/views/treeView/CategoryScreen.dart';
//
// class CategoryController extends GetxController {
//   var category = <String, dynamic>{}.obs;
//   var relatedCategories = <dynamic>[].obs;
//   var issues = <dynamic>[].obs;
//
//   final HttpService httpService = HttpService();
//   final Com com = Com(httpService: HttpService());
//
//   final Map<int, Map<String, dynamic>> categoryCache = {};
//   final Map<int, List<dynamic>> relatedCategoriesCache = {};
//   final Map<int, List<dynamic>> issuesCache = {};
//
//   final List<int> navigationStack = [];
//
//   int? rootCategoryId;
//
//
//   Future<bool> loadCategoryDetails(int categoryId, {bool forceRefresh = false}) async {
//     if (!forceRefresh && categoryCache.containsKey(categoryId)) {
//       category.assignAll(categoryCache[categoryId] ?? <String, dynamic>{});
//       relatedCategories.assignAll(relatedCategoriesCache[categoryId] ?? <dynamic>[]);
//       issues.assignAll(issuesCache[categoryId] ?? <dynamic>[]);
//       return true;
//     }
//
//     try {
//       final Map<dynamic, dynamic> data = await httpService.fetchCategoryDetails(categoryId, true, true);
//
//       final Map<String, dynamic> fetchedCategory =
//       (data['category'] as Map<dynamic, dynamic>).cast<String, dynamic>();
//       final List<dynamic> fetchedRelatedCategories =
//       List<dynamic>.from(data['related_categories'] ?? []);
//       final List<dynamic> fetchedIssues =
//       List<dynamic>.from(data['issues'] ?? []);
//
//       category.assignAll(fetchedCategory);
//       relatedCategories.assignAll(fetchedRelatedCategories);
//       issues.assignAll(fetchedIssues);
//
//       categoryCache[categoryId] = fetchedCategory;
//       relatedCategoriesCache[categoryId] = fetchedRelatedCategories;
//       issuesCache[categoryId] = fetchedIssues;
//
//       if (fetchedCategory['parent_category'] == null) {
//         rootCategoryId = categoryId;
//
//         if (navigationStack.isEmpty || navigationStack.first != categoryId) {
//           navigationStack.clear();
//           navigationStack.add(categoryId);
//           print("Navigation Stack Initialized: $navigationStack");
//         }
//       }
//
//       return true;
//     } catch (e) {
//       print("Error loading category details: $e");
//       return false;
//     }
//   }
//
//   void navigateToCategoryDetails(int categoryId, {bool isRoute = false}) {
//     if (isRoute) {
//       rootCategoryId = categoryId;
//     } else {
//       if (navigationStack.isEmpty || navigationStack.last != categoryId) {
//         navigationStack.add(categoryId);
//       }
//     }
//
//     loadCategoryDetails(categoryId).then((success) {
//       if (success) {
//         Get.to(() => CategoryScreen(categoryId: categoryId, isRoot: rootCategoryId == categoryId));
//       } else {
//         // Get.snackbar(
//         //   "Error".tr,
//         //   "Failed to load category details.".tr,
//         //   snackPosition: SnackPosition.BOTTOM,
//         // );
//         print("Falid to load category details..this setup is still wokring on..");
//
//       }
//     });
//   }
//
//   void navigateBack() {
//     if (navigationStack.isNotEmpty) {
//       navigationStack.removeLast();
//       if (navigationStack.isNotEmpty) {
//         final previousCategoryId = navigationStack.last;
//         loadCategoryDetails(previousCategoryId).then((success) {
//           if (success) {
//             Get.off(() => CategoryScreen(categoryId: previousCategoryId, isRoot: false));
//           } else {
//             // Get.snackbar(
//             //   "Error".tr,
//             //   "Failed to load previous category.".tr,
//             //   snackPosition: SnackPosition.BOTTOM,
//             // );
//             print("faild to load previou one cus w e still working on them");
//           }
//         });
//       } else {
//         Get.back();
//       }
//     }
//   }
// }

import 'dart:convert';
import 'package:get/get.dart';
import 'package:treenode/services/api/HttpService.dart';
import 'package:treenode/services/com.dart';
import 'package:treenode/views/treeView/CategoryScreen.dart';

class CategoryController extends GetxController {
  var category = <String, dynamic>{}.obs;
  var relatedCategories = <dynamic>[].obs;
  var issues = <dynamic>[].obs;

  final HttpService httpService = HttpService();
  final Com com = Com(httpService: HttpService());

  final Map<int, Map<String, dynamic>> categoryCache = {};
  final Map<int, List<dynamic>> relatedCategoriesCache = {};
  final Map<int, List<dynamic>> issuesCache = {};

  final List<int> navigationStack = [];
  int? rootCategoryId;

  Future<bool> loadCategoryDetails(int categoryId, {bool forceRefresh = false}) async {
    if (!forceRefresh && categoryCache.containsKey(categoryId)) {
      category.assignAll(categoryCache[categoryId] ?? <String, dynamic>{});
      relatedCategories.assignAll(relatedCategoriesCache[categoryId] ?? <dynamic>[]);
      issues.assignAll(issuesCache[categoryId] ?? <dynamic>[]);
      return true;
    }

    try {
      final Map<dynamic, dynamic> data = await httpService.fetchCategoryDetails(
        categoryId,
        true,
        true,
      );

      final Map<String, dynamic> fetchedCategory =
      _decodeUtf8((data['category'] as Map<dynamic, dynamic>).cast<String, dynamic>());
      final List<dynamic> fetchedRelatedCategories = List<dynamic>.from(
        (data['related_categories'] ?? []).map((category) {
          final decodedCategory = (category as Map<dynamic, dynamic>).cast<String, dynamic>();
          return _decodeUtf8(decodedCategory);
        }),
      );
      final List<dynamic> fetchedIssues = List<dynamic>.from(
        (data['issues'] ?? []).map((issue) {
          final decodedIssue = (issue as Map<dynamic, dynamic>).cast<String, dynamic>();
          return _decodeUtf8(decodedIssue);
        }),
      );

      category.assignAll(fetchedCategory);
      relatedCategories.assignAll(fetchedRelatedCategories);
      issues.assignAll(fetchedIssues);

      categoryCache[categoryId] = fetchedCategory;
      relatedCategoriesCache[categoryId] = fetchedRelatedCategories;
      issuesCache[categoryId] = fetchedIssues;

      if (fetchedCategory['parent_category'] == null) {
        rootCategoryId = categoryId;

        if (navigationStack.isEmpty || navigationStack.first != categoryId) {
          navigationStack.clear();
          navigationStack.add(categoryId);
          print("Navigation Stack Initialized: $navigationStack");
        }
      }

      return true;
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        Get.snackbar(
          "Unauthorized".tr,
          "Your session has expired. Please log in again.".tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        print("Error loading category details: $errorMessage");
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
      rootCategoryId = categoryId;
    } else {
      if (navigationStack.isEmpty || navigationStack.last != categoryId) {
        navigationStack.add(categoryId);
      }
    }

    loadCategoryDetails(categoryId).then((success) {
      if (success) {
        Get.to(() => CategoryScreen(
          categoryId: categoryId,
          isRoot: rootCategoryId == categoryId,
        ));
      } else {
        print("Failed to load category details.");
      }
    });
  }

  void navigateBack() {
    if (navigationStack.length > 1) {
      navigationStack.removeLast();
      final previousCategoryId = navigationStack.last;
      loadCategoryDetails(previousCategoryId).then((success) {
        if (success) {
          Get.off(() => CategoryScreen(
            categoryId: previousCategoryId,
            isRoot: rootCategoryId == previousCategoryId,
          ));
        } else {
          print("Failed to load previous category.");
        }
      });
    } else if (navigationStack.length == 1) {
      Get.back();
    }
  }
}

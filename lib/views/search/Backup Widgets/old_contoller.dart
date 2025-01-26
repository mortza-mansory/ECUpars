// import 'dart:convert';
//
// import 'package:get/get.dart';
// import 'package:treenode/services/api/HttpService.dart';
//
// class SearchingController extends GetxController {
//   var selectedCategory = "".obs;
//   var selectedSubcategory = <String>[].obs;
//   var searchText = ''.obs;
//
//   var errorResults = <Map<String, dynamic>>[].obs;
//   var stepResults = <Map<String, dynamic>>[].obs;
//   var mapResults = <Map<String, dynamic>>[].obs;
//
//   var allSelectedCategories = <String>[].obs;
//   var allSelectedSubcategories = <String>[].obs;
//
//   RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
//   RxList<Map<String, dynamic>> subcategories = <Map<String, dynamic>>[].obs;
//
//   RxList<String> categorySuggestions = <String>[].obs;
//   RxMap<String, int> categoryIdMap = <String, int>{}.obs;
//
//   RxBool isFiltered = false.obs;
//   RxBool isLoadingSubcategories = false.obs;
//   RxBool isLoadingCategories = false.obs;
//
//   final HttpService _httpService = HttpService();
//
//   RxList<Map<String, dynamic>> get searchResults {
//     return [
//       ...errorResults,
//       ...stepResults,
//       ...mapResults,
//     ].obs;
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchCategories();
//   }
//
//   Future<void> fetchCategories() async {
//     try {
//       isLoadingCategories.value = true;
//       List<Map<String, dynamic>> fetchedCategories =
//       await _httpService.fetchPngAssets();
//       categories.value = fetchedCategories;
//       categorySuggestions.value =
//           fetchedCategories.map((e) => e['text'] as String).toList();
//       categoryIdMap.value = {
//         for (var category in fetchedCategories) category['text']: category['id'] as int
//       };
//     } catch (e) {
//       if (e.toString().contains('401')) {
//         Get.offAllNamed('/login');
//       } else {
//         print("Error fetching categories: $e");
//       }
//     } finally {
//       isLoadingCategories.value = false;
//     }
//   }
//
//   Future<void> fetchSubcategories(int categoryId) async {
//     isLoadingSubcategories.value = true;
//     try {
//       var categoryDetails = await _httpService.fetchCategoryDetails(
//         categoryId,
//         false,
//         true,
//       );
//       var fetchedSubcategories = categoryDetails['related_categories'] as List<dynamic>;
//       subcategories.value =
//           fetchedSubcategories.map((e) => e as Map<String, dynamic>).toList();
//     } catch (e) {
//       if (e.toString().contains('401')) {
//         Get.offAllNamed('/login');
//       } else {
//         print("Error fetching subcategories: $e");
//       }
//     } finally {
//       isLoadingSubcategories.value = false;
//     }
//   }
//
//   void addCategory(Map<String, dynamic> category) {
//     print(category);
//     if (!allSelectedCategories.contains(category['text'])) {
//       allSelectedCategories.add(category['text']);
//       int? categoryId = categoryIdMap[category['text']];
//       if (categoryId != null) {
//         fetchSubcategories(categoryId);
//       }
//     }
//   }
//
//   void removeCategory(String category) {
//     allSelectedCategories.remove(category);
//
//     int? categoryId = categoryIdMap[category];
//     if (categoryId != null) {
//       var relatedSubcategories = subcategoriesByCategory[categoryId];
//       if (relatedSubcategories != null) {
//         for (var subcategory in relatedSubcategories) {
//           allSelectedSubcategories.remove(subcategory['name']);
//         }
//       }
//     }
//
//     fetchSearchResults();
//   }
//
//   void addSubcategory(String subcategory) {
//     if (!allSelectedSubcategories.contains(subcategory)) {
//       allSelectedSubcategories.add(subcategory);
//       fetchSearchResults();
//     }
//   }
//
//   Map<int, List<Map<String, dynamic>>> get subcategoriesByCategory {
//     var grouped = <int, List<Map<String, dynamic>>>{};
//     for (var subcategory in subcategories) {
//       int parentId = subcategory['parent_category'];
//       if (!grouped.containsKey(parentId)) {
//         grouped[parentId] = [];
//       }
//       grouped[parentId]!.add(subcategory);
//     }
//     return grouped;
//   }
//
//   List<String> get selectedSubcategories => allSelectedSubcategories;
//
//   void toggleSubcategory(String subcategoryName) {
//     if (allSelectedSubcategories.contains(subcategoryName)) {
//       allSelectedSubcategories.remove(subcategoryName);
//     } else {
//       allSelectedSubcategories.add(subcategoryName);
//     }
//     fetchSearchResults();
//   }
//
//   void applyFilters() {
//     fetchSearchResults();
//   }
//
//   Future<void> fetchSearchResults() async {
//     bool hasSuccessAfterError = false;
//
//     try {
//       var results = await _httpService.fetchSearchResults(
//         query: searchText.value,
//         categories: allSelectedCategories.toList(),
//         subcategories: allSelectedSubcategories.toList(),
//       );
//
//       // If results are successful after a previous error, ignore the error.
//       if (results.isNotEmpty) {
//         hasSuccessAfterError = true;
//       }
//
//       errorResults.clear();
//       stepResults.clear();
//       mapResults.clear();
//
//       for (var result in results) {
//         switch (result['type']) {
//           case 'Error':
//             errorResults.add(result);
//             break;
//           case 'Step':
//             stepResults.add(result);
//             break;
//           case 'Map':
//             mapResults.add(result);
//             break;
//           default:
//             break;
//         }
//       }
//     } catch (e) {
//       if (e.toString().contains('502') && hasSuccessAfterError) {
//         print("502 error ignored due to subsequent success.");
//       } else {
//         print("Error during search: $e");
//       }
//     }
//   }
//
//   void updateSearchText(String value) {
//     searchText.value = value;
//     if (value.trim().isNotEmpty) {
//       fetchSearchResults();
//     }
//   }
//
//   void removeSelectedSubcategory(String subcategory) {
//     allSelectedSubcategories.remove(subcategory);
//     fetchSearchResults();
//   }
//   Map<String, dynamic> _decodeUtf8(Map<String, dynamic> map) {
//     return map.map((key, value) {
//       if (value is String) {
//         return MapEntry(
//             key, utf8.decode(value.runes.toList(), allowMalformed: true));
//       } else {
//         return MapEntry(key, value);
//       }
//     });
//   }
//
//   String decodeUnicode(String input) {
//     Map<String, dynamic> tempMap = {"key": input};
//     Map<String, dynamic> decodedMap = _decodeUtf8(tempMap);
//     return decodedMap["key"];
//   }
//
// }

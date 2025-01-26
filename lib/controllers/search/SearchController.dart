import 'dart:convert';

import 'package:get/get.dart';
import 'package:treenode/services/api/HttpService.dart';

class SearchingController extends GetxController {
  var selectedCategory = "".obs;
  var selectedSubcategory = <String>[].obs;
  var searchText = ''.obs;

  var errorResults = <Map<String, dynamic>>[].obs;
  var stepResults = <Map<String, dynamic>>[].obs;
  var mapResults = <Map<String, dynamic>>[].obs;

  var allSelectedCategories = <String>[].obs;
  var allSelectedSubcategories = <String>[].obs;

  RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> subcategories = <Map<String, dynamic>>[].obs;

  RxList<String> categorySuggestions = <String>[].obs;
  RxMap<String, int> categoryIdMap = <String, int>{}.obs;

  RxBool isFiltered = false.obs;
  RxBool isLoadingSubcategories = false.obs;
  RxBool isLoadingCategories = false.obs;
  RxBool isLoadingResults = false.obs;

  RxList<int> expandedCategories = <int>[].obs;

  RxString radioSelection = 'allYes'.obs;

  final HttpService _httpService = HttpService();

  RxList<Map<String, dynamic>> get searchResults {
    return [
      ...errorResults,
      ...stepResults,
      ...mapResults,
    ].obs;
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    if (categories.isNotEmpty) return;
    try {
      isLoadingCategories.value = true;
      List<Map<String, dynamic>> fetchedCategories =
      await _httpService.fetchPngAssets();
      categories.value = fetchedCategories;
      categorySuggestions.value =
          fetchedCategories.map((e) => e['text'] as String).toList();
      categoryIdMap.value = {
        for (var category in fetchedCategories) category['text']: category['id'] as int
      };
    } catch (e) {
      if (e.toString().contains('401')) {
        Get.offAllNamed('/login');
      } else {
        print("Error fetching categories: $e");
      }
    } finally {
      isLoadingCategories.value = false;
    }
  }


  Future<void> fetchSubcategories(int categoryId) async {
    isLoadingSubcategories.value = true;
    try {
      var categoryDetails = await _httpService.fetchCategoryDetails(
        categoryId,
        false,
        true,
      );
      var fetchedSubcategories =
      categoryDetails['related_categories'] as List<dynamic>;
      subcategories.value =
          fetchedSubcategories.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      if (e.toString().contains('401')) {
        Get.offAllNamed('/login');
      } else {
        print("Error fetching subcategories: $e");
      }
    } finally {
      isLoadingSubcategories.value = false;
    }
  }

  void toggleCategoryExpansion(int categoryId) {
    if (expandedCategories.contains(categoryId)) {
      expandedCategories.remove(categoryId);
    } else {
      expandedCategories.clear();
      expandedCategories.add(categoryId);
    }
  }


  bool isCategorySelected(String categoryName) {
    return allSelectedCategories.contains(categoryName);
  }

  void toggleCategorySelection(String categoryId, bool isSelected) {
    if (isSelected) {
      if (!allSelectedCategories.contains(categoryId)) {
        allSelectedCategories.add(categoryId);

        int id = int.parse(categoryId);
        List<Map<String, dynamic>> relatedSubcategories = subcategories.where((s) => s['parent_category'] == id).toList();

        for (var subcategory in relatedSubcategories) {
          allSelectedSubcategories.add(subcategory['id'].toString());
        }
      }
    } else {
      allSelectedCategories.remove(categoryId);

      int id = int.parse(categoryId);
      List<Map<String, dynamic>> relatedSubcategories = subcategories.where((s) => s['parent_category'] == id).toList();

      for (var subcategory in relatedSubcategories) {
        allSelectedSubcategories.remove(subcategory['id'].toString());
      }
    }
  }

  bool isSubcategorySelected(String subcategoryName) {
    return allSelectedSubcategories.contains(subcategoryName);
  }

  void toggleSubcategorySelection(String subcategoryId, bool isSelected) {
    if (isSelected) {
      if (!allSelectedSubcategories.contains(subcategoryId)) {
        allSelectedSubcategories.add(subcategoryId);
      }
    } else {
      allSelectedSubcategories.remove(subcategoryId);
    }
  }


  Map<int, List<Map<String, dynamic>>> get subcategoriesByCategory {
    var grouped = <int, List<Map<String, dynamic>>>{};
    for (var subcategory in subcategories) {
      int parentId = subcategory['parent_category'];
      if (!grouped.containsKey(parentId)) {
        grouped[parentId] = [];
      }
      grouped[parentId]!.add(subcategory);
    }
    return grouped;
  }

  void applyFilters() {
    fetchSearchResults();
  }

  Future<void> fetchSearchResults() async {
    isLoadingResults.value = true;
    try {
      var results = await _httpService.fetchSearchResults(
        query: searchText.value,
        filterOptions: ['issues', 'solutions'],
        categoryIds: allSelectedCategories.isNotEmpty
            ? allSelectedCategories.map((category) => int.parse(category)).toList()
            : [],
        subcategoryId: allSelectedSubcategories.isNotEmpty
            ? int.tryParse(allSelectedSubcategories.first)
            : null,
      );


      errorResults.clear();
      stepResults.clear();
      mapResults.clear();

      for (var result in results) {
        switch (result['type']) {
          case 'car':
            mapResults.add(result);
            break;
          case 'issue':
            errorResults.add(result);
            break;
          default:
            break;
        }
      }
    } catch (e) {
      print("Error during search: $e");
    } finally {
      isLoadingResults.value = false;
    }
  }

  void updateSearchText(String value) {
    searchText.value = value;
    if (value.trim().isNotEmpty) {
      fetchSearchResults();
    }
  }
  void selectAll(bool isSelected) {
    allSelectedCategories.clear();
    allSelectedSubcategories.clear();

    if (isSelected) {
      for (var category in categories) {
        allSelectedCategories.add(category['id'].toString());
      }

      for (var subcategory in subcategories) {
        allSelectedSubcategories.add(subcategory['id'].toString());
      }
    }
  }


  Map<String, dynamic> _decodeUtf8(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is String) {
        return MapEntry(
            key, utf8.decode(value.runes.toList(), allowMalformed: true));
      } else {
        return MapEntry(key, value);
      }
    });
  }

  String decodeUnicode(String input) {
    Map<String, dynamic> tempMap = {"key": input};
    Map<String, dynamic> decodedMap = _decodeUtf8(tempMap);
    return decodedMap["key"];
  }
}

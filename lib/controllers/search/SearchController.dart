import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:treenode/services/api/HttpService.dart';

class SearchingController extends GetxController {
  var selectedCategory = "".obs;
  var selectedSubcategory = <String>[].obs;
  var searchText = ''.obs;


  var errorResults = <Map<String, dynamic>>[].obs;
  var stepResults = <Map<String, dynamic>>[].obs;
  var mapResults = <Map<String, dynamic>>[].obs;
  var tagResults = <Map<String, dynamic>>[].obs;
  var articleResults = <Map<String, dynamic>>[].obs;
  var solutionResults = <Map<String, dynamic>>[].obs;

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
  RxBool checkAll = false.obs;


  RxList<int> expandedCategories = <int>[].obs;
  RxSet<int> fetchedSubcategoriesParentIds = <int>{}.obs;

  RxString radioSelection = 'allYes'.obs;

  final HttpService _httpService = HttpService();

  RxList<Map<String, dynamic>> get searchResults {
    return [
      ...errorResults,
      ...stepResults,
      ...mapResults,
      ...articleResults,
      ...tagResults,
      ...solutionResults,
    ].obs;
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    clearSearchResults();
  }

  void clearSearchResults() {
    searchResults.clear();
    errorResults.clear();
    mapResults.clear();
    tagResults.clear();
    articleResults.clear();
    stepResults.clear();
    solutionResults.clear();
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
        for (var category in fetchedCategories)
          category['text']: category['id'] as int
      };

      if (radioSelection.value == 'allYes') {
        selectAll(true);
      }
    } catch (e) {
      if (e.toString().contains('401')) {
        Get.offAllNamed('/login');
      } else {
      }
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> fetchSubcategories(int categoryId) async {
    if (fetchedSubcategoriesParentIds.contains(categoryId)) return;
    fetchedSubcategoriesParentIds.add(categoryId);

    isLoadingSubcategories.value = true;
    try {
      var categoryDetails = await _httpService.fetchCategoryDetails(
        categoryId,
        false,
        true,
      );
      var fetchedSubcategories = (categoryDetails['related_categories'] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      List<Map<String, dynamic>> current = subcategories;
      current.removeWhere((element) => element['parent_category'] == categoryId);
      current.addAll(fetchedSubcategories);
      subcategories.value = List.from(current);
    } catch (e) {
      fetchedSubcategoriesParentIds.remove(categoryId);
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
      }
    } else {
      allSelectedCategories.remove(categoryId);
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

  void logFullResponse(String response) {
    final int chunkSize = 800;
    for (int i = 0; i < response.length; i += chunkSize) {
      print(response);
    }
  }

  Future<void> fetchSearchResults() async {
    isLoadingResults.value = true;
    print("---------------------------------------${checkAll.value}");
    try {
      var results = await _httpService.fetchSearchResults(
        query: searchText.value,
        filterOptions: [],
        categoryIds: checkAll.value ?  allSelectedCategories.map(int.parse).toList() : null,
        subcategoryIds: checkAll.value ? allSelectedSubcategories.map(int.parse).toList() : null,
      );
      logFullResponse(results.toString());

      errorResults.clear();
      stepResults.clear();
      mapResults.clear();
      tagResults.clear();
      articleResults.clear();
      solutionResults.clear();

      for (var result in results) {
        switch (result['type']) {
          case 'car':
            mapResults.add(result);
            break;
          case 'map':
            mapResults.add(result);
            break;
          case 'tag':
            if (result['data'] != null && result['data']['tag'] != null) {
              tagResults.add(result);
            }
            break;
          case 'issue':
            errorResults.add(result);
            break;
          case 'article':
            articleResults.add(result);
            break;
          case 'solution':
            solutionResults.add(result);
            break;
          default:
            break;
        }
      }
    } catch (e) {
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
        checkAll.value = false;
        allSelectedCategories.add(category['id'].toString());
      }
      for (var subcategory in subcategories) {
        allSelectedSubcategories.add(subcategory['id'].toString());
      }
    }else{
      checkAll.value = true;
    }
   // print(checkAll.value);
  }

  void toggleSubcategoryExpansion(int subcategoryId) {
    if (expandedCategories.contains(subcategoryId)) {
      expandedCategories.remove(subcategoryId);
    } else {
      expandedCategories.add(subcategoryId);
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

  String decodeUnicode(String input) {
    Map<String, dynamic> tempMap = {"key": input};
    Map<String, dynamic> decodedMap = _decodeUtf8(tempMap);
    return decodedMap["key"];
  }
}
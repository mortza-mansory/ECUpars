import 'package:get/get.dart';
import 'package:treenode/models/FilterModel.dart';

class SearchingController extends GetxController {
  var selectedCategory = "".obs;
  var selectedSubcategory = <String>[].obs;
  var selectedIssue = "".obs;
  var searchText = ''.obs;
  var isFiltered = false.obs;
  var selectedCategories = <String>[].obs;
  var allSelectedSubcategories = <String>[].obs;

  final Map<String, List<String>> categorySubcategories = {
    'Apple': ['Red', 'Green', 'Golden'],
    'Orange': ['Navel', 'Blood Orange', 'Mandarin'],
    'Banana': ['Cavendish', 'Red', 'Plantain'],
    'Grapes': ['Red', 'Green', 'Black'],
    'Mango': ['Alphonso', 'Himsagar', 'Kesar'],
    'Pineapple': ['Sweet', 'Sour']
  };
  var filterStack = <FilterModel>[].obs;

  void updateSearchText(String value) {
    searchText.value = value;
  }

  void updateCategory(String category) {
    selectedCategory.value = category;
    selectedSubcategory.clear();
    isFiltered.value = true;
  }

  void updateSubcategories() {
    if (selectedCategory.value.isNotEmpty && selectedSubcategory.isEmpty) {
      selectedSubcategory.addAll(categorySubcategories[selectedCategory.value] ?? []);
    }
  }

  void selectSubcategory(String subcategory) {
    if (!allSelectedSubcategories.contains(subcategory)) {
      allSelectedSubcategories.add(subcategory);
    }
  }

  void removeSelectedSubcategory(String subcategory) {
    allSelectedSubcategories.remove(subcategory);
  }

  void selectCategory(String category) {
    if (!selectedCategories.contains(category)) {
      selectedCategories.add(category);
    }
  }

  void removeSelectedCategory(String category) {
    selectedCategories.remove(category);
    final subcategoriesToRemove = categorySubcategories[category];
    if (subcategoriesToRemove != null) {
      allSelectedSubcategories.removeWhere((subcategory) =>
          subcategoriesToRemove.contains(subcategory));
    }
  }

  RxList<String> get subcategories {
    return (categorySubcategories[selectedCategory.value] ?? []).obs;
  }

  void applyFilters() {
    final filterState = FilterModel(
      selectedCategories: List.from(selectedCategories),
      allSelectedSubcategories: List.from(allSelectedSubcategories),
      searchText: searchText.value,
    );
    filterStack.add(filterState);

    print("Filters applied: Categories - $selectedCategories, Subcategories - $allSelectedSubcategories");
    isFiltered.value = true;
  }

  void revertToLastFilter() {
    if (filterStack.isNotEmpty) {
      final lastFilterState = filterStack.last;
      selectedCategories.value = lastFilterState.selectedCategories;
      allSelectedSubcategories.value = lastFilterState.allSelectedSubcategories;
      searchText.value = lastFilterState.searchText;
      filterStack.removeLast();

      print("Reverted to last filter: Categories - $selectedCategories, Subcategories - $allSelectedSubcategories");
    }
  }

  RxList<String> get filteredResults {
    var result = <String>[];
    result.addAll(categorySubcategories.keys.where((item) =>
        item.toLowerCase().contains(searchText.value.toLowerCase())));
    return result.obs;
  }
}

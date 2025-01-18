class FilterModel {
  final List<String> selectedCategories;
  final List<String> allSelectedSubcategories;
  final String searchText;

  FilterModel({
    required this.selectedCategories,
    required this.allSelectedSubcategories,
    required this.searchText,
  });
}

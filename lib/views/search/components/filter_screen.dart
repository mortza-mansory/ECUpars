import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/search/SearchController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

class FilterScreen extends StatelessWidget {
  final SearchingController searchController = Get.find<SearchingController>();
  final ThemeController themeController = Get.find<ThemeController>();

  FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeController.isDarkTheme.value
            ? const Color.fromRGBO(44, 45, 49, 1)
            : const Color.fromRGBO(255, 250, 244, 1),
        title: Text(
          "Filter results".tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: h / 38,
            color: themeController.isDarkTheme.value
                ? const Color.fromRGBO(255, 250, 244, 1)
                : const Color.fromRGBO(44, 45, 49, 1),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: themeController.isDarkTheme.value ? Colors.white : Colors
                .black,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(h * 0.015, 0, h * 0.015, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(h * 0.13, h * 0.05),
                backgroundColor: themeController.isDarkTheme.value
                    ? const Color.fromRGBO(255, 250, 244, 1)
                    : const Color.fromRGBO(44, 45, 49, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: h * 0.02, vertical: h * 0.01),
              ),
              onPressed: () {
                searchController.applyFilters();
                Get.back();
              },
              child: Text(
                "Apply".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: h / 55,
                  color: themeController.isDarkTheme.value
                      ? const Color.fromRGBO(44, 45, 49, 1)
                      : const Color.fromRGBO(255, 250, 244, 1),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        return Padding(
          padding: EdgeInsets.fromLTRB(h * 0.010, h * 0.02, h * 0.010, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: h * 0.01),
                Container(
                  padding: EdgeInsets.fromLTRB(h * 0.02,0,h * 0.02,0),
                  decoration: BoxDecoration(
                    color: themeController.isDarkTheme.value
                        ? const Color.fromRGBO(44, 45, 49, 1)
                        : const Color.fromRGBO(255, 250, 244, 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GestureDetector(
                   onTap: () async {
                     await searchController.fetchCategories();
                   },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "General Searching",
                          style: TextStyle(
                            fontSize: h / 45,
                            fontWeight: FontWeight.bold,
                            color: themeController.isDarkTheme.value
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: searchController.radioSelection.value == 'allYes',
                              onChanged: (bool? value) {
                                if (value ?? false) {
                                  searchController.radioSelection.value = 'allYes';
                                  searchController.selectAll(true);
                                }
                              },
                              activeColor: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                            ),
                            Text(
                              "Yes",
                              style: TextStyle(
                                fontSize: h / 50,
                                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                              ),
                            ),
                            Checkbox(
                              value: searchController.radioSelection.value == 'allNo',
                              onChanged: (bool? value) {
                                if (value ?? false) {
                                  searchController.radioSelection.value = 'allNo';
                                  searchController.selectAll(false);
                                }
                              },
                              activeColor: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                            ),
                            Text(
                              "No",
                              style: TextStyle(
                                fontSize: h / 50,
                                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
                if (searchController.isLoadingCategories.value)
                  Center(
                    child: CircularProgressIndicator(
                      color: themeController.isDarkTheme.value
                          ? Colors.white
                          : Colors.black,
                    ),
                  )
                else
                  ...searchController.categories.map((category) {
                    int? categoryId = category['id'] as int?;
                    if (categoryId == null) return SizedBox.shrink();

                    bool isExpanded = searchController.expandedCategories.contains(categoryId);

                    if (isExpanded &&
                        !searchController.subcategoriesByCategory.containsKey(categoryId)) {
                      searchController.fetchSubcategories(categoryId);
                    }

                    List<Map<String, dynamic>> subcategories =
                        searchController.subcategoriesByCategory[categoryId] ?? [];

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: h * 0.01),
                      child: Container(
                        padding: EdgeInsets.all(h * 0.02),
                        decoration: BoxDecoration(
                          color: themeController.isDarkTheme.value
                              ? const Color.fromRGBO(44, 45, 49, 1)
                              : const Color.fromRGBO(255, 250, 244, 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: searchController.isCategorySelected(
                                        category['id'].toString(),
                                      ),
                                      onChanged: (bool? value) {
                                        searchController.toggleCategorySelection(
                                          category['id'].toString(),
                                          value ?? false,
                                        );
                                        for (var subcategory in subcategories) {
                                          searchController.toggleSubcategorySelection(
                                            subcategory['id'].toString(),
                                            value ?? false,
                                          );
                                        }
                                      },
                                      activeColor: themeController.isDarkTheme.value
                                          ? Colors.white
                                          : Colors.black,
                                    ),

                                    Text(
                                      searchController.decodeUnicode(
                                          category['text'] ?? 'Unnamed Category'),
                                      style: TextStyle(
                                        fontSize: h / 50,
                                        color: themeController.isDarkTheme.value
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    searchController.toggleCategoryExpansion(categoryId);
                                  },
                                  icon: Icon(
                                    isExpanded
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    color: themeController.isDarkTheme.value
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            if (isExpanded)
                              if (subcategories.isEmpty)
                                Center(
                                  child: Text(
                                    "No subcategories available",
                                    style: TextStyle(
                                      fontSize: h / 55,
                                      color: themeController.isDarkTheme.value
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                )
                              else
                                Padding(
                                  padding:  EdgeInsets.only(right: h*0.025,left: h*0.025),
                                  child: Column(
                                    children: subcategories.map((subcategory) {
                                      int? subcategoryId = subcategory['id'] as int?;
                                      if (subcategoryId == null) return SizedBox.shrink();

                                      return Row(
                                        children: [
                                          Checkbox(
                                            value: searchController.isSubcategorySelected(
                                                subcategory['id'].toString()),
                                            onChanged: (bool? value) {
                                              searchController.toggleSubcategorySelection(
                                                subcategory['id'].toString(),
                                                value ?? false,
                                              );
                                            },
                                            activeColor: themeController.isDarkTheme.value
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          Text(
                                            searchController.decodeUnicode(
                                                subcategory['name'] ?? 'Unnamed Subcategory'),
                                            style: TextStyle(
                                              fontSize: h / 50,
                                              color: themeController.isDarkTheme.value
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
              ],
            ),
          ),
        );
      }),


    );
  }
}


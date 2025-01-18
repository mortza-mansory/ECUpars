import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';
import 'package:treenode/controllers/search/SearchController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

class FilterScreen extends StatelessWidget {
  final SearchingController searchController = Get.find<SearchingController>();
  final ThemeController themeController = Get.find<ThemeController>();

  FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;

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
          icon: Icon(
            Icons.arrow_back,
            color: themeController.isDarkTheme.value
                ? const Color.fromRGBO(255, 250, 244, 1)
                : const Color.fromRGBO(44, 45, 49, 1),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
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
                  fontFamily: 'Sarbaz',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(h * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // General Searching Section
              Text(
                "General Searching".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: h / 40,
                  color: themeController.isDarkTheme.value
                      ? const Color.fromRGBO(255, 250, 244, 1)
                      : const Color.fromRGBO(44, 45, 49, 1),
                ),
              ),
              SizedBox(height: h * 0.02),
              Obx(() => Row(
                children: [
                  Radio<String>(
                    value: "Yes",
                    groupValue: searchController.selectedCategory.value,
                    activeColor: themeController.isDarkTheme.value
                        ? Colors.white
                        : Colors.black,
                    onChanged: (value) {
                      searchController.updateCategory(value!);
                    },
                  ),
                  Text(
                    "Yes",
                    style: TextStyle(
                      color: themeController.isDarkTheme.value
                          ? const Color.fromRGBO(255, 250, 244, 1)
                          : const Color.fromRGBO(44, 45, 49, 1),
                    ),
                  ),
                  Radio<String>(
                    value: "No",
                    groupValue: searchController.selectedCategory.value,
                    activeColor: themeController.isDarkTheme.value
                        ? Colors.white
                        : Colors.black,
                    onChanged: (value) {
                      searchController.updateCategory(value!);
                    },
                  ),
                  Text(
                    "No",
                    style: TextStyle(
                      color: themeController.isDarkTheme.value
                          ? const Color.fromRGBO(255, 250, 244, 1)
                          : const Color.fromRGBO(44, 45, 49, 1),
                    ),
                  ),
                ],
              )),
              SizedBox(height: h * 0.02),
              Text(
                "Search Categories".tr,
                style: TextStyle(
                  fontSize: h / 40,
                  color: themeController.isDarkTheme.value
                      ? const Color.fromRGBO(255, 250, 244, 1)
                      : const Color.fromRGBO(44, 45, 49, 1),
                ),
              ),
              SizedBox(height: h * 0.02),
              Obx(() {
                return SearchField<String>(
                  suggestions: searchController.filteredResults
                      .map((e) => SearchFieldListItem<String>(e))
                      .toList(),
                  searchInputDecoration: SearchInputDecoration(
                    hintText: 'Search categories...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSuggestionTap: (item) {
                    searchController.selectCategory(item.searchKey);
                    searchController.updateCategory(item.searchKey);
                  },
                );
              }),
              SizedBox(height: h * 0.02),
              Obx(() {
                if (searchController.selectedCategory.value.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    searchController.updateSubcategories();
                  });
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Subcategory".tr,
                        style: TextStyle(
                          fontSize: h / 40,
                          color: themeController.isDarkTheme.value
                              ? const Color.fromRGBO(255, 250, 244, 1)
                              : const Color.fromRGBO(44, 45, 49, 1),
                        ),
                      ),
                      SizedBox(height: h * 0.02),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: searchController.subcategories.map((subcategory) {
                          return GestureDetector(
                            onTap: () {
                              searchController.selectSubcategory(subcategory);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: h * 0.01),
                              padding: EdgeInsets.symmetric(vertical: h * 0.015, horizontal: h * 0.02),
                              decoration: BoxDecoration(
                                color: searchController.allSelectedSubcategories.contains(subcategory)
                                    ? Colors.blue
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: searchController.allSelectedSubcategories.contains(subcategory)
                                      ? Colors.blue
                                      : Colors.grey[400]!,
                                ),
                              ),
                              child: Text(
                                subcategory,
                                style: TextStyle(
                                  fontSize: h / 45,
                                  color: searchController.allSelectedSubcategories.contains(subcategory)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                } else {
                  return SizedBox();
                }
              }),

              SizedBox(height: h * 0.02),
              Text(
                "Selected Filters".tr,
                style: TextStyle(
                  fontSize: h / 40,
                  color: themeController.isDarkTheme.value
                      ? const Color.fromRGBO(255, 250, 244, 1)
                      : const Color.fromRGBO(44, 45, 49, 1),
                ),
              ),
              SizedBox(height: h * 0.02),
              Obx(() {
                return Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: searchController.selectedCategories.map((category) {
                    return Chip(
                      label: Text(category),
                      backgroundColor: Colors.blue[100],
                      deleteIcon: Icon(Icons.close),
                      onDeleted: () {
                        searchController.removeSelectedCategory(category);
                      },
                    );
                  }).toList(),
                );
              }),

              Divider(color: Colors.black),

              Obx(() {
                return Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: searchController.allSelectedSubcategories.map((subcategory) {
                    return Chip(
                      label: Text(subcategory),
                      backgroundColor: Colors.blue[100],
                      deleteIcon: Icon(Icons.close),
                      onDeleted: () {
                        searchController.removeSelectedSubcategory(subcategory);
                      },
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/search/SearchController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

class FilterScreen extends StatelessWidget {
  final SearchingController searchController = Get.find<SearchingController>();
  final ThemeController themeController = Get.find<ThemeController>();

  FilterScreen({Key? key}) : super(key: key);

  Widget _buildSubcategoryTree(int parentId, double h) {
    if (!searchController.fetchedSubcategoriesParentIds.contains(parentId)) {
      searchController.fetchSubcategories(parentId);
      return Padding(
        padding: EdgeInsets.only(left: h * 0.05),
        child: SizedBox(
          height: h * 0.05,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                themeController.isDarkTheme.value ? Colors.white : Colors.black,
              ),
              strokeWidth: 2.0,
            ),
          ),
        ),
      );
    }

    List<Map<String, dynamic>> children =
        searchController.subcategoriesByCategory[parentId] ?? [];
    if (children.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(left: h * 0.05),
        child: Text(
          "No subcategories available".tr,
          style: TextStyle(
            fontSize: h / 55,
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: h * 0.05),
      child: Column(
        children: children.map((subcat) {
          int? subcatId = subcat['id'] as int?;
          if (subcatId == null) return const SizedBox.shrink();
          bool isSubExpanded = searchController.expandedCategories.contains(subcatId);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: searchController.isSubcategorySelected(subcat['id'].toString()),
                    onChanged: (bool? value) {
                      searchController.toggleSubcategorySelection(
                          subcat['id'].toString(), value ?? false);
                    },
                    activeColor: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                    checkColor: themeController.isDarkTheme.value ? Colors.black : Colors.white,
                  ),
                  Expanded(
                    child: Text(
                      searchController.decodeUnicode(subcat['name'] ?? 'Unnamed Subcategory'.tr),
                      style: TextStyle(
                        fontSize: h / 50,
                        color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isSubExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      searchController.toggleSubcategoryExpansion(subcatId);
                    },
                  ),
                ],
              ),
              if (isSubExpanded) _buildSubcategoryTree(subcatId, h),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeController.isDarkTheme.value
            ? const Color.fromRGBO(44, 45, 49, 1)
            : const Color.fromRGBO(255, 255, 255, 1.0),
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
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: h * 0.015),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(h * 0.13, h * 0.05),
                backgroundColor: themeController.isDarkTheme.value
                    ? const Color.fromRGBO(255, 255, 255, 1.0)
                    : const Color.fromRGBO(44, 45, 49, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: EdgeInsets.symmetric(horizontal: h * 0.02, vertical: h * 0.01),
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
                      : const Color.fromRGBO(255, 255, 255, 1.0),
                ),
              ),
            ),
          ),
        ],
      ),
      body: GetX<SearchingController>(builder: (controller) {
        if (controller.categories.isEmpty) {
          controller.fetchCategories();
        }
        return Padding(
          padding: EdgeInsets.fromLTRB(h * 0.010, h * 0.02, h * 0.010, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: h * 0.01),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: h * 0.02),
                  decoration: BoxDecoration(
                    color: themeController.isDarkTheme.value
                        ? const Color.fromRGBO(44, 45, 49, 1)
                        : const Color.fromRGBO(255, 255, 255, 1.0),
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
                          "General Searching".tr,
                          style: TextStyle(
                            fontSize: h / 45,
                            fontWeight: FontWeight.bold,
                            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: controller.radioSelection.value == 'allYes',
                              onChanged: (bool? value) {
                                if (controller.radioSelection.value == 'allYes') {
                                  controller.radioSelection.value = 'allNo';
                                  controller.selectAll(false);
                                } else {
                                  controller.radioSelection.value = 'allYes';
                                  controller.selectAll(true);
                                }
                              },
                              activeColor: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                              checkColor: themeController.isDarkTheme.value ? Colors.black : Colors.white,
                            ),
                            Text(
                              "Yes".tr,
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
                if (controller.isLoadingCategories.value)
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        themeController.isDarkTheme.value ? Colors.white : Colors.black,
                      ),
                    ),
                  )
                else
                  ...controller.categories.map((category) {
                    int? categoryId = category['id'] as int?;
                    if (categoryId == null) return const SizedBox.shrink();
                    bool isExpanded = controller.expandedCategories.contains(categoryId);
                    if (isExpanded && !controller.fetchedSubcategoriesParentIds.contains(categoryId)) {
                      controller.fetchSubcategories(categoryId);
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: h * 0.01),
                      child: Container(
                        padding: EdgeInsets.all(h * 0.02),
                        decoration: BoxDecoration(
                          color: themeController.isDarkTheme.value
                              ? const Color.fromRGBO(44, 45, 49, 1)
                              : const Color.fromRGBO(255, 255, 255, 1.0),
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
                                      value: controller.isCategorySelected(category['id'].toString()),
                                      onChanged: (bool? value) {
                                        controller.toggleCategorySelection(category['id'].toString(), value ?? false);
                                      },
                                      activeColor: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                                      checkColor: themeController.isDarkTheme.value ? Colors.black : Colors.white,
                                    ),
                                    Text(
                                      controller.decodeUnicode(category['text'] ?? 'Unnamed Category'.tr),
                                      style: TextStyle(
                                        fontSize: h / 50,
                                        color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller.toggleCategoryExpansion(categoryId);
                                  },
                                  icon: Icon(
                                    isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                    color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            if (isExpanded) _buildSubcategoryTree(categoryId, h),
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
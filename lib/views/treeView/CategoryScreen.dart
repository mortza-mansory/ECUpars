import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/api/ApiCategory.dart';
import 'package:treenode/controllers/api/ApiIssus.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/home/homeScreen.dart';
import 'package:treenode/views/treeView/components/CategoryContainer.dart';
import 'package:treenode/views/treeView/components/IssusContainer.dart';
import 'package:treenode/views/treeView/components/ArticleContainer.dart';
import 'package:treenode/views/treeView/components/MapContainer.dart';

class CategoryScreen extends StatefulWidget {
  final int categoryId;
  final bool isRoot;

  CategoryScreen({required this.categoryId, this.isRoot = false});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredCategories = [];
  List<dynamic> _filteredIssues = [];
  List<dynamic> _filteredArticles = [];
  List<dynamic> _filteredMaps = [];
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    final categoryController = Get.find<CategoryController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    categoryController.loadCategoryDetails(widget.categoryId, forceRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<CategoryController>();
    final themeController = Get.find<ThemeController>();
    final langController = Get.find<LangController>();

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        categoryController.navigateBack();
        return false;
      },
      child: Directionality(
        textDirection: langController.isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Obx(
              () => Scaffold(
            appBar: AppBar(
              backgroundColor: themeController.isDarkTheme.value
                  ? const Color.fromRGBO(44, 45, 49, 1)
                  : const Color.fromRGBO(255, 255, 255, 1.0),
              iconTheme: IconThemeData(
                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
              ),
              elevation: 0,
              leading: IconButton(
                onPressed: () => categoryController.navigateBack(),
                icon: const Icon(Icons.arrow_back),
              ),
              title: Obx(
                    () => Text(
                  categoryController.category['name'] ??
                      (widget.isRoot ? 'Main Categories'.tr : 'Sub Category'.tr),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                  ),
                ),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () => showConfirmationDialog(context, themeController),
                  icon: Icon(
                    Icons.home,
                    color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearchVisible = !_isSearchVisible;
                    });
                  },
                  icon: Icon(
                    _isSearchVisible ? Icons.close : Icons.search,
                    color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            body: Obx(
                  () {
                if (categoryController.isLoading.value) {
                  return _buildLoadingScreen(themeController);
                }
                final relatedCategories = categoryController.relatedCategories;
                final issues = categoryController.issues;
                final articles = categoryController.articles;
                final maps = categoryController.maps;

                _filteredCategories = relatedCategories.where((category) {
                  return category['name']
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase());
                }).toList();

                _filteredIssues = issues.where((issue) {
                  return issue['title']
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase());
                }).toList();

                _filteredArticles = articles.where((article) {
                  return article['title']
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase());
                }).toList();

                _filteredMaps = maps.where((map) {
                  return map['title']
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase());
                }).toList();
                print(maps);

                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isSearchVisible)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search'.tr,
                                hintStyle: TextStyle(
                                  color: themeController.isDarkTheme.value
                                      ? Colors.white70
                                      : Colors.grey,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: themeController.isDarkTheme.value
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: themeController.isDarkTheme.value
                                        ? Colors.white70
                                        : Colors.grey,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: themeController.isDarkTheme.value
                                        ? Colors.white
                                        : Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: themeController.isDarkTheme.value
                                        ? Colors.white70
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                color: themeController.isDarkTheme.value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onChanged: (query) {
                                setState(() {});
                              },
                              autofocus: true,
                            ),
                          ),
                        if (_filteredCategories.isNotEmpty) ...[
                          _buildSectionHeader("Related Categories".tr, themeController),
                          ..._filteredCategories.map((category) {
                            return CategoryContainer(
                              w,
                              h,
                              langController,
                              themeController,
                              title: category['name'] ?? "Unnamed".tr,
                              date: category['created_at'] ?? "Unknown".tr,
                              categoryId: category['id'],
                            );
                          }).toList(),
                        ],
                        if (_filteredIssues.isNotEmpty) ...[
                          _buildSectionHeader("Issues".tr, themeController),
                          ..._filteredIssues.map((issue) {
                            return IssusContainer(
                              w,
                              h,
                              langController,
                              themeController,
                              title: issue['title'] ?? "Unnamed".tr,
                              date: issue['created_at'] ?? "Unknown".tr,
                              categoryId: issue['id'],
                            );
                          }).toList(),
                        ],
                        if (_filteredArticles.isNotEmpty) ...[
                          _buildSectionHeader("Articles".tr, themeController),
                          ..._filteredArticles.map((article) {
                            return ArticleContainer(
                              w,
                              h,
                              langController,
                              themeController,
                              article: article,
                            );
                          }).toList(),
                        ],
                        if (_filteredMaps.isNotEmpty) ...[
                    _buildSectionHeader("Maps".tr, themeController),
                          ..._filteredMaps.map((map) {
                            return MapContainer(
                              map['title'],
                              w,
                              h,
                              langController,
                              themeController,
                              mapData: map,
                            );
                          }).toList(),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeController themeController) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Sarbaz',
          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildLoadingScreen(ThemeController themeController) {
    return Center(
      child: CircularProgressIndicator(
        color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
      ),
    );
  }

  void showConfirmationDialog(BuildContext context, ThemeController themeController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Are you sure?'.tr,
            style: TextStyle(
              color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            ),
          ),
          icon: Icon(Icons.outbond_outlined, size: 40),
          content: Text(
            'Do you really want to go back to the home screen?'.tr,
            style: TextStyle(
              color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: themeController.isDarkTheme.value
              ? const Color.fromRGBO(44, 45, 49, 1)
              : Colors.white,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel'.tr,
                style: TextStyle(
                  color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.offAll(() => Homescreen());
              },
              child: Text(
                'Yes'.tr,
                style: TextStyle(
                  color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
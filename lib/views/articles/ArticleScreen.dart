import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/articles/ArticlesController.dart';
import 'package:treenode/controllers/auth/LoginController.dart';
import 'package:treenode/controllers/utills/NavigationController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/articles/components/articleContainer.dart';

class Articlescreen extends StatelessWidget {
  final ArticlesController _articlesController = Get.find<ArticlesController>();
  final ThemeController _themeController = Get.find<ThemeController>();
  final LoginController _loginController = Get.find<LoginController>();
  final NavigationController navigationController = Get.find<NavigationController>();

  DateTime? _lastPressed;

  @override
  Widget build(BuildContext context) {
    _articlesController.onInit();
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressed == null ||
            DateTime.now().difference(_lastPressed!) > Duration(milliseconds: 200)) {
          _lastPressed = DateTime.now();
          navigationController.selectedIndex.value = 0;
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Obx(() {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 80),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Articles".tr,
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: "Sarbaz",
                                fontWeight: FontWeight.bold,
                                color: _themeController.isDarkTheme.value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            Row(
                              children: [
                                Obx(() => IconButton(
                                  icon: Icon(
                                    _articlesController.isSearchVisible.value
                                        ? Icons.close
                                        : Icons.search,
                                    color: _themeController.isDarkTheme.value
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onPressed: _articlesController.toggleSearchVisibility,
                                )),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(
                                    Icons.refresh,
                                    color: _themeController.isDarkTheme.value
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onPressed: _articlesController.fetchArticlesFromApi,
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(
                                    _themeController.isDarkTheme.value
                                        ? Icons.nightlight_round
                                        : Icons.wb_sunny,
                                    color: _themeController.isDarkTheme.value
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onPressed: _themeController.toggleTheme,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Obx(() => _articlesController.isSearchVisible.value
                          ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: TextField(
                          controller: _articlesController.searchController,
                          decoration: InputDecoration(
                            hintText: 'Search'.tr,
                            prefixIcon: Icon(
                              Icons.search,
                              color: _themeController.isDarkTheme.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            border: const UnderlineInputBorder(),
                          ),
                          style: TextStyle(
                            color: _themeController.isDarkTheme.value
                                ? Colors.white
                                : Colors.black,
                          ),
                          onChanged: _articlesController.filterArticles,
                          autofocus: true,
                        ),
                      )
                          : const SizedBox.shrink()),

                      Obx(() {
                        if (_articlesController.filteredArticles.isEmpty &&
                            !_articlesController.isLoading.value) {
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'No articles found'.tr,
                              style: TextStyle(
                                color: _themeController.isDarkTheme.value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: _articlesController.filteredArticles.reversed
                              .map((article) => ArticleContainer(article: article))
                              .toList(),

                        );
                      }),

                    ],
                  ),
                ),
              ),
              if (_articlesController.isLoading.value)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        }),
      ),
    );
  }
}
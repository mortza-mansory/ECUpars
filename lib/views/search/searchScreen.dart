import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/api/ApiAds.dart';
import 'package:treenode/controllers/search/SearchController.dart';
import 'package:treenode/controllers/utills/NavigationController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/search/components/AdsCasul.dart';
import 'package:treenode/views/search/components/filter_screen.dart';
import 'package:treenode/views/search/components/resultContainer.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiAds adsController = Get.put(ApiAds());
  final ThemeController themeController = Get.find<ThemeController>();
  final SearchingController searchController = Get.find<SearchingController>();
  final NavigationController navigationController = Get.find<NavigationController>();

  int _visibleAllResults = 5;
  int _visibleErrorResults = 5;
  int _visibleMapResults = 5;
  int _visibleArticleResults = 5;
  int _visibleSolutionResults = 5;
  DateTime? _lastBackPressTime;
  static const int _doubleTapDuration = 2000;

  @override
  void initState() {
    super.initState();
    searchController.clearSearchResults();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String decodeUnicode(String input) {
    Map<String, dynamic> tempMap = {"key": input};
    Map<String, dynamic> decodedMap = tempMap.map((key, value) {
      if (value is String) {
        return MapEntry(key, utf8.decode(value.runes.toList(), allowMalformed: true));
      } else {
        return MapEntry(key, value);
      }
    });
    return decodedMap["key"];
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();

    if (_lastBackPressTime != null &&
        now.difference(_lastBackPressTime!).inMilliseconds < _doubleTapDuration) {
      navigationController.selectedIndex.value = 0;
      return false;
    } else {
      _lastBackPressTime = now;
      _controller.clear();
      searchController.updateSearchText('');
      searchController.clearSearchResults();
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    adsController.loadADS();
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: themeController.isDarkTheme.value
              ? const Color.fromRGBO(44, 45, 49, 1)
              : const Color.fromRGBO(255, 255, 255, 1.0),
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: themeController.isDarkTheme.value
                          ? Colors.grey[700]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            onSubmitted: (String query) {
                              searchController.updateSearchText(query);
                              searchController.fetchSearchResults();
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                              ),
                              hintText: 'Search...'.tr,
                              hintStyle: TextStyle(
                                color: themeController.isDarkTheme.value ? Colors.white : Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Obx(() => Icon(
                            searchController.isFiltered.value
                                ? Icons.filter_alt
                                : Icons.filter_alt_outlined,
                            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                          )),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FilterScreen()),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: DefaultTabController(
          length: 5,
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    if (screenWidth <= 400) {
                      final ScrollController scrollController = ScrollController(
                        initialScrollOffset: double.maxFinite, // Start at the "end" (right side)
                      );
                      // Ensure the controller is disposed of properly
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (scrollController.hasClients) {
                          scrollController.jumpTo(scrollController.position.maxScrollExtent);
                        }
                      });
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..scale(-1.0, 1.0), // Mirrors horizontally
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true, // Reverses the scroll order
                          controller: scrollController, // Attach the controller
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..scale(-1.0, 1.0), // Mirrors back the text
                            child: TabBar(
                              isScrollable: true,
                              indicatorColor: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                              labelColor: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                              unselectedLabelColor: themeController.isDarkTheme.value ? Colors.grey : Colors.black54,
                              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                              tabs: [
                                Tab(text: "All".tr),
                                Tab(text: "Errors".tr),
                                Tab(text: "Solutions".tr),
                                Tab(text: "Maps".tr),
                                Tab(text: "Articles".tr),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return TabBar(
                        indicatorColor: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                        labelColor: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                        unselectedLabelColor: themeController.isDarkTheme.value ? Colors.grey : Colors.black54,
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                        tabs: [
                          Tab(text: "All".tr),
                          Tab(text: "Errors".tr),
                          Tab(text: "Solutions".tr),
                          Tab(text: "Maps".tr),
                          Tab(text: "Articles".tr),
                        ],
                      );
                    }
                  },
                ),
              ),
              AdsCarousel(),
              Expanded(
                child: Transform(
                  transform: Matrix4.rotationY(pi),
                  alignment: Alignment.center,
                  child: TabBarView(
                    children: [
                  Transform(
                  transform: Matrix4.rotationY(pi),
                  alignment: Alignment.center,
                  child:Obx(() {
                    if (searchController.isLoadingResults.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ...searchController.searchResults.take(_visibleAllResults).map((result) {
                            Map<String, dynamic> data;
                            String type = result['type'] ?? '';
                            String titleKey;
                            if (result['data'].containsKey('article')) {
                              data = result['data']['article'];
                              type = "article";
                              titleKey = 'title';
                            } else if (result['type'] == 'tag' &&
                                result['data'].containsKey('tag') &&
                                result['data']['tag'].containsKey('map')) {
                              data = result['data']['tag'];
                              type = "map";
                              titleKey = 'title';
                            } else if (result['data'].containsKey('map') ||
                                result['data'].containsKey('car')) {
                              data = result['data']['map'] ?? result['data']['car'];
                              type = "map";
                              titleKey = result['data'].containsKey('map') ? 'title' : 'name';
                            } else if (result['data'].containsKey('issue')) {
                              data = result['data']['issue'];
                              type = "issue";
                              titleKey = 'title';
                            } else if (result['type'] == 'solution' && result['data'].containsKey('solution')) {
                              data = result['data']['solution'] ?? {};
                              type = "solution";
                              titleKey = 'title';
                            } else {
                              data = {};
                              type = "Unknown";
                              titleKey = 'title';
                            }

                            final path = (type == "issue" || type == "solution" || type == "map")
                                ? result['data']['full_category_name'] ?? 'Unknown'
                                : (type == "article"
                                ? data['category']['name'] ?? 'Unknown'
                                : 'Unknown');
                            final description = type == "article"
                                ? data['content'] ?? 'No description'
                                : (data['description'] ?? 'No description');
                            final logoUrl = type == "map" ? data['image'] ?? '' : '';

                            return ResultContainer(
                              title: data[titleKey],
                              path: path,
                              description: description,
                              logoUrl: logoUrl,
                              type: type,
                              id: data['id'] ?? 0,
                              fulldata: type == "map" ? data : null,
                            );
                          }).toList(),

                          ...searchController.solutionResults.take(_visibleSolutionResults).map((result) {
                            final data = result['data']['solution'] ?? {};
                            final type = "solution";
                            final path = result['data']['step_id']?.toString() ?? 'Unknown'; // Fixed here
                            final description = data['description'] ?? 'No description';
                            final logoUrl = '';

                            return ResultContainer(
                              title: data['title'] ?? 'No title',
                              path: path,
                              description: description,
                              logoUrl: logoUrl,
                              type: type,
                              id: data['id'] ?? 0,
                            );
                          }).toList(),

                          if (searchController.searchResults.length > _visibleAllResults ||
                              searchController.solutionResults.length > _visibleSolutionResults)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _visibleAllResults += 5;
                                  _visibleSolutionResults += 5;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Load More".tr,
                                  style: TextStyle(
                                    color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
                  Transform(
                        transform: Matrix4.rotationY(pi),
                        alignment: Alignment.center,
                        child: Obx(() {
                          if (searchController.isLoadingResults.value) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                              ),
                            );
                          }
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                ...searchController.errorResults.take(_visibleErrorResults).map((result) {
                                  final data = result['data']['issue'] ?? {};
                                  final type = "issue";
                                  final path = result['data']['full_category_name'] ?? 'Unknown';
                                  final description = data['description'] ?? 'No description';
                                  final logoUrl = '';
                                  print("=======================================");
                                  print(data);
                                  print(result);
                                  return ResultContainer(
                                    title: data['title'] ?? 'No title',
                                    path: path,
                                    description: description,
                                    logoUrl: logoUrl,
                                    type: type,
                                    id: data['id'] ?? 0,
                                  );
                                }).toList(),
                                if (searchController.errorResults.length > _visibleErrorResults)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _visibleErrorResults += 5;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        "Load More".tr,
                                        style: TextStyle(
                                          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ),
                      Transform(
                        transform: Matrix4.rotationY(pi),
                        alignment: Alignment.center,
                        child: Obx(() {
                          if (searchController.isLoadingResults.value) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                              ),
                            );
                          }
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                ...searchController.solutionResults.take(_visibleSolutionResults).map((result) {
                                  final data = result['data']['solution'] ?? {};
                                  final type = "solution";
                                  final path = result['data']['full_category_name'] ?? '';
                                  final stepId = result['data']['step_id'];
                                  final int id = (stepId is int)
                                      ? stepId
                                      : (stepId is String)
                                      ? int.tryParse(stepId) ?? 0
                                      : 0;
                                  final description = data['description'] ?? 'No description';
                                  final logoUrl = '';
                                  print(data);
                                  print(result);
                                  return ResultContainer(
                                    title: data['title'] ?? 'No title',
                                    path: path,
                                    description: description,
                                    logoUrl: logoUrl,
                                    type: type,
                                    id: id,
                                  );
                                }).toList(),
                                if (searchController.solutionResults.length > _visibleSolutionResults)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _visibleSolutionResults += 5;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        "Load More".tr,
                                        style: TextStyle(
                                          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ),
                      Transform(
                        transform: Matrix4.rotationY(pi),
                        alignment: Alignment.center,
                        child: Obx(() {
                          if (searchController.isLoadingResults.value) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                              ),
                            );
                          }
                          final allResults = [
                            ...searchController.tagResults,
                            ...searchController.mapResults,
                          ];
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                ...allResults.take(_visibleMapResults).map((result) {
                                  Map<String, dynamic> data;
                                  String titleKey;
                                  String path = result['data']['full_category_name'] ?? '';

                                  if (result['type'] == 'tag' &&
                                      result['data'].containsKey('tag')) {
                                    data = result['data']['map'];
                                    titleKey = 'title';
                                  } else {
                                    data = result['data']['map'] ?? result['data']['car'] ?? {};
                                    titleKey = result['data'].containsKey('map') ? 'title' : 'name';
                                  }

                                  final type = "map";
                                  final description = data['description'] ?? 'No description';
                                  final logoUrl = data['image'] ?? '';

                                  return ResultContainer(
                                    title: data[titleKey] ?? 'No title',
                                    path: path,
                                    description: description,
                                    logoUrl: logoUrl,
                                    type: type,
                                    id: data['id'] ?? 0,
                                    fulldata: data,
                                  );
                                }).toList(),
                                if (allResults.length > _visibleMapResults)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _visibleMapResults += 5;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        "Load More".tr,
                                        style: TextStyle(
                                          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ),
                      Transform(
                        transform: Matrix4.rotationY(pi),
                        alignment: Alignment.center,
                        child: Obx(() {
                          if (searchController.isLoadingResults.value) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                              ),
                            );
                          }

                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                ...searchController.articleResults.take(_visibleArticleResults).map((result) {
                                  final data = result['data']['article'] ?? {};
                                  final _data = result ?? {};
                                  final type = "article";
                                  final path = result['data']['full_category_name'] ?? '';
                                  final description = data['content'] ?? '';
                                  final logoUrl = '';
                                  print("=============================================================\n");
                                  print(result);
                                  return ResultContainer(
                                    title: data['title'] ?? 'No title'.tr,
                                    path: path,
                                    description: description,
                                    logoUrl: logoUrl,
                                    type: type,
                                    id: data['id'] ?? 0,
                                    fulldata: data,
                                  );
                                }).toList(),
                                if (searchController.articleResults.length > _visibleArticleResults)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _visibleArticleResults += 5;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        "Load More".tr,
                                        style: TextStyle(
                                          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
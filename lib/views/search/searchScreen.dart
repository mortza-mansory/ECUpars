import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/api/ApiAds.dart';
import 'package:treenode/controllers/search/SearchController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    adsController.loadADS();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeController.isDarkTheme.value
            ? Color.fromRGBO(44, 45, 49, 1)
            : Color.fromRGBO(255, 250, 244, 1),
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
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
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onTap: () {},
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: themeController.isDarkTheme.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            hintText: 'Search...',
                            hintStyle: TextStyle(
                              color: themeController.isDarkTheme.value
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: themeController.isDarkTheme.value
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Obx(() => Icon(
                              searchController.isFiltered.value
                                  ? Icons.filter_alt
                                  : Icons.filter_alt_outlined,
                              color: themeController.isDarkTheme.value
                                  ? Colors.white
                                  : Colors.black,
                            )),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FilterScreen()),
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
        length: 4,
        child: Column(
          children: [
            TabBar(
              indicatorColor: themeController.isDarkTheme.value
                  ? Colors.white
                  : Colors.black,
              labelColor: themeController.isDarkTheme.value
                  ? Colors.white
                  : Colors.black,
              unselectedLabelColor: themeController.isDarkTheme.value
                  ? Colors.grey
                  : Colors.black54,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal,
              ),
              tabs: [
                Tab(text: "All"),
                Tab(text: "Errors"),
                Tab(text: "Maps"),
                Tab(text: "Steps"),
              ],
            ),
            Obx(() {
              if (adsController.GatheredAds.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }

              final ad = adsController.GatheredAds[0];
              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 3.5,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(ad['banner']),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 3.5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              decodeUnicode(
                                ad['title'] ?? '',
                              ),
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              decodeUnicode(
                                ad['created_at'] ?? '',
                              ),
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 38,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Column(children: [
                      AllResultContainer(
                        title: "a dummy",
                        description: "a dummy two..",
                        logoUrl:
                            'https://themindfool.com/wp-content/uploads/2020/02/personal-development-1.jpg',
                      ),
                      AllResultContainer(
                        title: "a dummy",
                        description: "a dummy two..a dummy two..a dummy a dummy to..a dummy a dummy to..a dummy a dummy to..a dummy a dummy to..a dummy a dummy to..a dummy a dummy to..a dummy a dummy to..a dummy a dummy to..a dummy a dummy to..a dummy a dummy to..a dummy a dummy two..a dummy two.",
                        logoUrl:
                        'https://themindfool.com/wp-content/uploads/2020/02/personal-development-1.jpg',
                      ),
                      AllResultContainer(
                        title: "a dummy",
                        description: "a dummy two..",
                        logoUrl:
                        'https://themindfool.com/wp-content/uploads/2020/02/personal-development-1.jpg',
                      ),
                      AllResultContainer(
                        title: "a dummy",
                        description: "two..a dummy two..a dummy a dummy to..a dummy a dummy to..a dummytwo..a dummy two..a dummy a dummy to..a dummy a dummy to..a dummy",
                        logoUrl:
                        'https://themindfool.com/wp-content/uploads/2020/02/personal-development-1.jpg',
                      )
                    ]
                    ),
                  ),
                  Center(
                      child: Text(
                    "Errors Content",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: themeController.isDarkTheme.value
                          ? Colors.white
                          : Colors.black,
                    ),
                  )),
                  Center(
                      child: Text(
                    "Maps Content",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: themeController.isDarkTheme.value
                          ? Colors.white
                          : Colors.black,
                    ),
                  )),
                  Center(
                      child: Text(
                    "Solutions Content",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: themeController.isDarkTheme.value
                          ? Colors.white
                          : Colors.black,
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

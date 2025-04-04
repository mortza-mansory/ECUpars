import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:treenode/controllers/utills/NavigationController.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AnimatedNavigationBar extends StatelessWidget {
  final NavigationController navigationController = Get.find();

  final List<Map<String, dynamic>> navigationItems = [
    {'icon': Icons.home, 'text': "Home".tr},
    {'icon': Icons.search, 'text': "Search".tr},
    {'icon': Icons.article_outlined, 'text': "articles".tr},
    {'icon': Icons.explore, 'text': "Extras".tr},
  ];

  @override
  Widget build(BuildContext context) {
    double AdaptiveSpace(double width) {
      if (width <= 360) {
        return 30;
      } else if (width >= 375) {
        return 30;
      } else if (width >= 400 && width <= 768) {
        return 30;
      } else {
        return 0;
      }
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = 0.26 * screenWidth + AdaptiveSpace(screenWidth);
    double fontSize = screenWidth * 0.04;

    return Obx(() {
      return Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
        ),
        child: Directionality(
          textDirection: TextDirection.ltr, // Force LTR regardless of language
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(navigationItems.length, (index) {
              final isSelected = navigationController.selectedIndex.value == index;
              return GestureDetector(
                onTap: () => navigationController.changeIndex(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 0),
                  width: isSelected ? containerWidth : 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color.fromARGB(255, 253, 107, 107)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        navigationItems[index]['icon'],
                        color: isSelected ? Colors.white : Colors.grey,
                        size: isSelected ? 28 : 24,
                      ),
                      if (isSelected)
                        Expanded(
                          child: FutureBuilder(
                            future: Future.delayed(const Duration(milliseconds: 500)),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return Center(
                                  child: AutoSizeText(
                                    navigationItems[index]['text'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: fontSize,
                                      fontFamily: "Sarbaz",
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textDirection: Get.locale?.languageCode == 'fa'
                                        ? TextDirection.rtl
                                        : TextDirection.ltr, // Text direction for text only
                                  )
                                      .animate()
                                      .fadeIn(duration: 300.ms),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      );
    });
  }
}



/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/utills/ApiTree.dart';
import 'package:animate_do/animate_do.dart';

class AnimatedNavigationBar extends StatelessWidget {
  final NavigationController navigationController = Get.find();

  final List<Map<String, dynamic>> navigationItems = [
    {'icon': Icons.home, 'text': "Home".tr},
    {'icon': Icons.search, 'text': "Search".tr},
    {'icon': Icons.notifications, 'text': "articles".tr},
    {'icon': Icons.explore, 'text': "Extras".tr},
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navigationItems.length, (index) {
            final isSelected = navigationController.selectedIndex.value == index;

            return GestureDetector(
              onTap: () => navigationController.changeIndex(index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 0),
                width: isSelected ? 150 : 60,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? const Color.fromARGB(255, 253, 107, 107) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      navigationItems[index]['icon'],
                      color: isSelected ? Colors.white : Colors.grey,
                      size: 28,

                    ),
                    if (isSelected)
                      FutureBuilder(
                        future: Future.delayed(Duration(milliseconds: 500)),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return FadeIn(
                              duration: Duration(milliseconds: 300),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  navigationItems[index]['text'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
*/
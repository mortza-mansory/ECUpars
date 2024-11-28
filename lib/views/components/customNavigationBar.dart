import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/utills/NavigationController.dart';
import 'package:animate_do/animate_do.dart';

class AnimatedNavigationBar extends StatelessWidget {
  final NavigationController navigationController = Get.find();

  final List<Map<String, dynamic>> navigationItems = [
    {'icon': Icons.home, 'text': "Home".tr},
    {'icon': Icons.search, 'text': "Search".tr},
    {'icon': Icons.notifications, 'text': "Inbox".tr},
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
                  color: isSelected ? Color.fromRGBO(30, 144, 255, 1) : Colors.transparent,
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

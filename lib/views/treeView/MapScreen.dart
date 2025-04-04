import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/saved/SavedController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/viewModel/NodeTree.dart';
import 'package:treenode/views/home/homeScreen.dart';
import 'package:treenode/views/treeView/components/BoxCardsMap.dart';

class MapScreen extends StatelessWidget {
  final Map<String, dynamic> mapData;

  const MapScreen({required this.mapData, super.key});

  Map<String, dynamic> _decodeUtf8(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is String) {
        try {
          return MapEntry(key, utf8.decode(latin1.encode(value), allowMalformed: true));
        } catch (e) {
          return MapEntry(key, value);
        }
      } else {
        return MapEntry(key, value);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final savedController = Get.find<SavedController>();

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    final decodedMapData = _decodeUtf8(mapData);
    final mapId = decodedMapData['id'] ?? 0;

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Obx(() {
        final isSaved = savedController.isMapSaved(mapId);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: themeController.isDarkTheme.value
                ? const Color.fromRGBO(44, 45, 49, 1)
                : const Color.fromRGBO(255, 255, 255, 1.0),
            iconTheme: IconThemeData(
              color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            ),
            elevation: 0,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
            ),
            actions: [
              IconButton(
                onPressed: () => showConfirmationDialog(context, themeController),
                icon: Icon(
                  Icons.home,
                  color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                ),
              ),
              IconButton(
                onPressed: () => themeController.toggleTheme(),
                icon: Icon(
                  themeController.isDarkTheme.value ? Icons.dark_mode : Icons.light_mode,
                ),
              ),
              IconButton(
                onPressed: () {
                  savedController.toggleSaveMap(mapId, decodedMapData);
                },
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BoxCardsMap(
                    step: decodedMapData,
                    h: h,
                  ),
                  SizedBox(height: h * 0.03),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void showConfirmationDialog(
      BuildContext context, ThemeController themeController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Are you sure?'.tr,
            style: TextStyle(
              color: themeController.isDarkTheme.value
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          icon: Icon(Icons.outbond_outlined, size: 40),
          content: Text(
            'Do you really want to go back to the home screen?'.tr,
            style: TextStyle(
              color: themeController.isDarkTheme.value
                  ? Colors.white
                  : Colors.black,
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
                  color: themeController.isDarkTheme.value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                globalNavigationStack.clear();
                Get.offAll(() => Homescreen());
              },
              child: Text(
                'Yes'.tr,
                style: TextStyle(
                  color: themeController.isDarkTheme.value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

class ResultContainer extends StatelessWidget {
  final String title;
  final String path;
  final String description;
  final String logoUrl;
  final String type;
  final int id;

  const ResultContainer({
    super.key,
    required this.title,
    required this.path,
    required this.description,
    required this.logoUrl,
    required this.type,
    required this.id,
  });

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
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final ThemeController themeController = Get.find<ThemeController>();

    final decodedTitle = decodeUnicode(title);
    final decodedDescription = decodeUnicode(description);
    final decodedPath = decodeUnicode(path);
    return GestureDetector(
      onTap: () {
        if (type == 'Error') {
          Get.toNamed('/errorDetail', arguments: {'id': id});
        } else if (type == 'Step') {
          Get.toNamed('/stepDetail', arguments: {'id': id});
        } else if (type == 'Map') {
          Get.toNamed('/mapDetail', arguments: {'id': id});
        }
      },
      child: Container(
        width: w * 0.98,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding:  EdgeInsets.all(h*0.02),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: themeController.isDarkTheme.value
              ? Colors.grey[700]
              : Colors.grey[200],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  logoUrl,
                  width: h * 0.07,
                  height: h * 0.07,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: h * 0.02),
                ),
                SizedBox(width: h * 0.02),
                SizedBox(width: h * 0.02),
                Expanded(
                  child: AutoSizeText(
                    decodedTitle,
                    style:  TextStyle(
                      fontSize: h*0.02,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.02),
            Text(
              decodedPath,
              style: TextStyle(fontSize: h * 0.015),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: h * 0.02),
            Text(
              decodedDescription,
              style: TextStyle(fontSize: h * 0.015),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}

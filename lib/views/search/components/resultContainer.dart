import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/api/ApiIssus.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/viewModel/NodeTree.dart';
import 'package:treenode/views/treeView/IssusScreen.dart';
import 'package:treenode/views/treeView/MapScreen.dart';
import 'package:treenode/views/treeView/StepScreen.dart';

import '../../articles/articleSubScreen.dart';

class ResultContainer extends StatelessWidget {
  final Map<String, dynamic>? fulldata;
  final String title;
  final String path;
  final String description;
  final String logoUrl;
  final String type;
  final int id;

  const ResultContainer({
    super.key,
    this.fulldata,
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

  String removeHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    final issueController = Get.find<IssueController>();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final ThemeController themeController = Get.find<ThemeController>();

    final decodedTitle = decodeUnicode(title);
    final decodedDescription = decodeUnicode(description);
    final decodedPath = decodeUnicode(path);

    final pathSegments = decodedPath.split('>').map((s) => s.trim()).toList();

    return GestureDetector(
      onTap: () {
        // Since full data is already the map data from SearchScreen,
        // we can use it directly
        // On the article results its also the same
        // Actually the api sending me full data to show and i should make changes like this....
        // Sorry new developer ...
        globalNavigationStack.clear();
        print(globalNavigationStack.length);
        if (type == 'issue') {
          globalNavigationStack.clear();
          Get.to(() => Issusscreen(issueId: id));
        } else if (type == 'solution') {
          Get.to(() => StepScreen(stepId: id));
        } else if (type == 'map' || type == 'tag') {
          Map<String, dynamic> mapDataToPass = Map<String, dynamic>.from(fulldata!);
          Get.to(() => MapScreen(mapData: mapDataToPass));
        } else if (type == 'article') {
          Get.to(() => ArticleSubScreen(article: fulldata!));
        }
      },
      child: Container(
        width: w * 0.98,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(h * 0.02),
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
                Expanded(
                  child: AutoSizeText(
                    decodedTitle,
                    style: TextStyle(
                      fontSize: h * 0.02,
                      fontWeight: FontWeight.bold,
                      color: themeController.isDarkTheme.value
                          ? Colors.white
                          : Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: pathSegments.map((segment) {
                return Text(
                  segment + (pathSegments.last != segment ? ' >' : ''),
                  style: TextStyle(
                    fontSize: h * 0.015,
                    color: themeController.isDarkTheme.value
                        ? Colors.white
                        : Colors.black,
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                );
              }).toList(),
            ),
            SizedBox(height: h * 0.02),
            Text(
              removeHtmlTags(decodedDescription),
              style: TextStyle(
                fontSize: h * 0.015,
                color: themeController.isDarkTheme.value
                    ? Colors.white
                    : Colors.black,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
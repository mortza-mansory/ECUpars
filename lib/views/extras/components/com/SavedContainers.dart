import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/api/ApiIssus.dart';
import 'package:treenode/controllers/api/ApiSteps.dart';
import 'package:treenode/controllers/articles/ArticleController.dart';
import 'package:treenode/controllers/saved/SavedController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/articles/ArticleSingleScreen.dart';
import 'package:treenode/views/treeView/IssusScreen.dart';
import 'package:treenode/views/treeView/StepScreen.dart';
import 'package:treenode/views/treeView/MapScreen.dart';

class SavedContainers extends StatelessWidget {
  final String title;
  final String description;
  final String type;
  final int id;

  const SavedContainers({
    super.key,
    required this.title,
    required this.description,
    required this.type,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final savedController = Get.find<SavedController>();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final ThemeController themeController = Get.find<ThemeController>();
    final ArticleController articlenavigator = Get.find<ArticleController>();
    final IssueController issueController = Get.find<IssueController>();
    final StepController stepController = Get.find<StepController>();

    final displayTitle = title;
    final displayDescription = description;

    return GestureDetector(
      onTap: () {
        if (type == 'issue') {
          issueController.navigateToIssue(id);
        } else if (type == 'step') {
          stepController.navigateToStep(id, isRoute: true);
        } else if (type == 'map') {
          final savedMapData = savedController.savedMaps[id]?['map'];
          if (savedMapData != null) {
            final decodedMapData = savedController.decodeItemData('map', savedMapData);
            Get.to(() => MapScreen(mapData: decodedMapData));
          }
        } else if (type == 'article') {
          final savedArticleData = savedController.savedArticles[id]?['article'];
          if (savedArticleData != null) {
            articlenavigator.navigateToArticle(savedArticleData['id'] ?? id,);
          }
        }
      },
      child: Container(
        width: w * 0.98,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(h * 0.02),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: themeController.isDarkTheme.value ? Colors.grey[700] : Colors.grey[200],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: h * 0.02),
                Expanded(
                  child: AutoSizeText(
                    displayTitle,
                    style: TextStyle(
                      fontSize: h * 0.02,
                      fontWeight: FontWeight.bold,
                      color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.02),
            if (type != "map")
              Text(
                displayDescription,
                style: TextStyle(
                  fontSize: h * 0.015,
                  color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
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
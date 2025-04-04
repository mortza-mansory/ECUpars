import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/api/ApiIssus.dart';
import 'package:treenode/controllers/api/ApiSteps.dart';
import 'package:treenode/controllers/articles/ArticleController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/articles/ArticleSingleScreen.dart';
import 'dart:ui';

import 'package:treenode/views/treeView/components/blur/b.dart';

Widget BoxCardsQuastions(Map<String, dynamic> question, List<dynamic> options, ThemeController themeController, double w, double h) {

  final issueController = Get.find<IssueController>();
  final stepController = Get.find<StepController>();
  final articleController = Get.find<ArticleController>();
  String questionText = question['text'] ?? 'No Question Text'.tr;
  print(options);
  return Container(
    width: w,
    padding: EdgeInsets.symmetric(vertical: w * 0.02),
    decoration: BoxDecoration(
      color: themeController.isDarkTheme.value
          ? const Color(0xFF48484A)
          : const Color(0xFFDA6666),
      border: Border.all(
        color: themeController.isDarkTheme.value
            ? const Color(0xFFD4D8D3)
            : Colors.white,
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: w * 0.02),
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: h * 0.06,
            ),
            child: Container(
              width: w * 0.72,
              padding: EdgeInsets.all(w * 0.02),
              decoration: BoxDecoration(
                color: themeController.isDarkTheme.value
                    ? const Color(0xFFFFFFFF).withOpacity(0.3)
                    : const Color(0xFF545454).withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                questionText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: w * 0.035,
                  color: Colors.white,
                  fontFamily: 'Sarbaz',
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
        ),
        SizedBox(height: h * 0.03),
        if (question['text'] == "") SizedBox(height: h * 0.01),
        ...options.map((option) {
          return Padding(
            padding: EdgeInsets.only(top: h * 0.01),
            child: Center(
              child: BlurredButton(
                  onPressed: () {
                    if (option['issue'] != null) {
                      final int issueId = (option['issue'] as num).toInt();
                      issueController.navigateToIssue(issueId);
                    } else if (option['next_step'] != null) {
                      final int nextStepId = (option['next_step'] as num).toInt();
                      stepController.navigateToStep(nextStepId);
                    } else if (option['article'] != null) {
                      final int articleId = (option['article'] as num).toInt();
                      articleController.navigateToArticle(articleId);
                    } else {
                    }
                  },
                text: option['text'],
                backgroundColor: themeController.isDarkTheme.value
                    ? const Color(0xFFFF6869)
                    : const Color(0xFFFBEED8),
                textColor:
                themeController.isDarkTheme.value ? Colors.white : Colors.black,
                width: w * 0.72,
                height: h * 0.06,
                fontSize: w * 0.03,
              ),
            ),
          );
        }).toList(),
        SizedBox(height: h * 0.01),
      ],
    ),
  );
}
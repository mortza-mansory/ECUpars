import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/api/ApiIssus.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/treeView/components/BoxCards.dart';
import 'package:treenode/views/treeView/components/BoxCardsQuastions.dart';

class ArticleSubScreen extends StatelessWidget {
  final Map<String, dynamic> article;

  const ArticleSubScreen({Key? key, required this.article}) : super(key: key);

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
    if (input.contains(r'\u')) {
      return input.replaceAllMapped(
        RegExp(r'\\u([0-9a-fA-F]{4})'),
            (match) => String.fromCharCode(int.parse(match.group(1)!, radix: 16)),
      );
    }
    return input;
  }

  String decodePersianText(String input) {
    bool containsPersian = RegExp(r'[\u0600-\u06FF]').hasMatch(input);
    bool looksLikeLatin1Encoded = RegExp(r'[ÃÙÚ][\x80-\xBF]+').hasMatch(input);

    if (containsPersian && !looksLikeLatin1Encoded) {
      return input;
    }
    try {
      List<int> latin1Bytes = input.codeUnits;
      String utf8String = utf8.decode(latin1Bytes, allowMalformed: true);
      return utf8String;
    } catch (e) {
      print('Error decoding Persian text: $e');
      return input;
    }
  }

  @override
  Widget build(BuildContext context) {
    final issueController = Get.find<IssueController>();
    final themeController = Get.find<ThemeController>();

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Obx(() {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: themeController.isDarkTheme.value
                ? const Color.fromRGBO(44, 45, 49, 1)
                : Colors.white,
            iconTheme: IconThemeData(
              color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            ),
            elevation: 0,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.fromLTRB(w * 0.03, 0, w * 0.1, 0),
                child: IconButton(
                  onPressed: () => themeController.toggleTheme(),
                  icon: Icon(
                    themeController.isDarkTheme.value ? Icons.dark_mode : Icons.light_mode,
                    color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          body: Obx(() {
            print(article['content']);
            if (issueController.isLoading.value) {
              return _buildLoadingScreen(themeController);
            }
            final issue = issueController.issue;
            final question = issueController.question;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BoxCards(
                      title: decodePersianText(article['title'] ?? ''),
                      description: decodePersianText(article['content'] ?? ''),
                      h: h,
                    ),
                    if (article != null &&
                        article['options'] != null &&
                        article['options'].isNotEmpty)
                      BoxCardsQuastions(
                        article,
                        article['options'],
                        themeController,
                        w,
                        h,
                      ),
                  ],
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Widget _buildLoadingScreen(ThemeController themeController) {
    return Center(
      child: CircularProgressIndicator(
        color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/api/ApiIssus.dart';
import 'package:treenode/controllers/articles/ArticleController.dart';
import 'package:treenode/controllers/articles/ArticlesController.dart';
import 'package:treenode/controllers/saved/SavedController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/viewModel/NodeTree.dart';
import 'package:treenode/views/home/homeScreen.dart';
import 'package:treenode/views/treeView/components/BoxCards.dart';
import 'package:treenode/views/treeView/components/BoxCardsArticle.dart';
import 'dart:convert';

import 'package:treenode/views/treeView/components/BoxCardsQuastions.dart';

class ArticleSingleScreen extends StatelessWidget {
  final int articleId;
  final RxBool single = false.obs;
  final ArticlesController articleController = Get.find<ArticlesController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final SavedController savedController = Get.find<SavedController>();

  final Rx<Map<String, dynamic>?> articleData = Rx<Map<String, dynamic>?>(null);
  final Rx<Map<String, dynamic>?> allData = Rx<Map<String, dynamic>?>(null);
  final RxBool isLoading = true.obs;


  ArticleSingleScreen({
    Key? key,
    required this.articleId,
    bool initialSingle = false,
  }) : super(key: key) {
    single.value = initialSingle;
    _loadArticle();
  }
  Future<void> _loadArticle() async {
    try {
      isLoading.value = true;
      final data = await articleController.loadArticleById(articleId);
      articleData.value = Map<String, dynamic>.from(data['article'] ?? {});
      allData.value = Map<String, dynamic>.from(data);
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  String decodeUtf8String(String encoded) {
    try {
      final unescaped = encoded.replaceAllMapped(
          RegExp(r'\\u([0-9a-fA-F]{4})'),
              (match) => String.fromCharCode(int.parse(match[1]!, radix: 16)));
      return utf8.decode(unescaped.codeUnits, allowMalformed: true);
    } catch (e) {
      return encoded;
    }
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Are you sure?'.tr,
            style: TextStyle(
              color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            ),
          ),
          icon: Icon(Icons.outbond_outlined, size: 40),
          content: Text(
            'Do you really want to go back to the home screen?'.tr,
            style: TextStyle(
              color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: themeController.isDarkTheme.value
              ? const Color.fromRGBO(44, 45, 49, 1)
              : Colors.white,
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel'.tr,
                style: TextStyle(
                  color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
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
                  color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: themeController.isDarkTheme.value
          ? const Color.fromRGBO(44, 45, 49, 1)
          : const Color.fromRGBO(255, 255, 255, 1.0),
      iconTheme: IconThemeData(
        color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
      ),
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          single.value = false;
          Get.find<ArticleController>().navigateBack();
        },
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        IconButton(
          onPressed: () => showConfirmationDialog(context),
          icon: Icon(
            Icons.home,
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
        ),
        IconButton(
          onPressed: () => themeController.toggleTheme(),
          icon: Icon(
            themeController.isDarkTheme.value ? Icons.dark_mode : Icons.light_mode,
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
        ),
        Obx(() {
          final isSaved = savedController.isArticleSaved(articleId);
          return IconButton(
            onPressed: () async {
              final articleData = await articleController.loadArticleById(articleId);
              savedController.toggleSaveArticle(articleId, articleData['article']);
            },
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Obx(() {
      if (isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
        );
      }

      if (allData.value == null) {
        return Center(
          child: Text(
            'no article data available'.tr,
            style: TextStyle(
              color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            ),
            textDirection: TextDirection.rtl,
          ),
        );
      }

      final data = allData.value!;
      final article = Map<String, dynamic>.from(data['article'] ?? {});
      final title = decodeUtf8String(article['title'] ?? '');
      final rawContent = article['content'] ?? '';
      final content = decodeUtf8String(rawContent);

      final questionRaw = data['question'];
      final question = questionRaw is Map ? Map<String, dynamic>.from(questionRaw) : <String, dynamic>{};
      if (question.isNotEmpty) {
        question['text'] = decodeUtf8String(question['text']?.toString() ?? '');
      }

      final optionsRaw = data['options'] ?? [];
      final options = (optionsRaw as List).map((option) {
        final optionMap = Map<String, dynamic>.from(option is Map ? option : {});
        optionMap['text'] = decodeUtf8String(optionMap['text']?.toString() ?? '');
        return optionMap;
      }).toList();

      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              single.value
                  ? BoxCardArticle(title: title, description: content, h: h)
                  : BoxCards(title: title, description: content, h: h),
              SizedBox(height: w*0.02,),
              if (question.isNotEmpty && options.isNotEmpty)
                BoxCardsQuastions(
                  question,
                  options,
                  themeController,
                  w,
                  h,
                ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        single.value = false;
        Get.find<ArticleController>().navigateBack();
        return true;
      },
      child: Obx(() => Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(context),
        backgroundColor: themeController.isDarkTheme.value
            ? const Color.fromRGBO(44, 45, 49, 1)
            : const Color.fromRGBO(255, 255, 255, 1.0),
      )),
    );
  }
}
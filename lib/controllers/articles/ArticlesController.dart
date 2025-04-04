import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/services/api/HttpService.dart';

class ArticlesController extends GetxController {
  final RxList<Map<String, dynamic>> articles = <Map<String, dynamic>>[].obs;
  final RxMap<String, dynamic> article = RxMap<String, dynamic>({});
  final RxList<Map<String, dynamic>> filteredArticles = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearchVisible = false.obs;
  final TextEditingController searchController = TextEditingController();
  var isLoadingArticle = false.obs;
  var error = ''.obs;

  HttpService httpService = HttpService();

  @override
  void onInit() {
    super.onInit();
    fetchArticlesFromApi();
  }

  String _decodeUtf8(String input) {
    try {
      final latin1Bytes = latin1.encode(input);
      return utf8.decode(latin1Bytes, allowMalformed: true);
    } catch (e) {
      return input;
    }
  }

  Future<Map<String, dynamic>> loadArticleById(int articleId) async {
    try {
      isLoadingArticle.value = true;
      var art = await httpService.fetchArticleById(articleId);
      article.value = art;
      return art;
    } catch (e) {
      error.value = e.toString();
      throw e;
    } finally {
      isLoadingArticle.value = false;
    }
  }
  void fetchArticlesFromApi() async {
    try {
      isLoading(true);
      articles.clear();
      filteredArticles.clear();

      List<Map<String, dynamic>> fetchedArticles = await httpService.fetchArticles();

      final processedArticles = fetchedArticles.map((article) {
        return {
          ...article,
          'title': _decodeUtf8(article['title']?.toString() ?? ''),
          'content': _decodeUtf8(article['content']?.toString() ?? ''),
        };
      }).toList();

      articles.assignAll(processedArticles);
      filteredArticles.assignAll(processedArticles);
    } catch (e) {
      // Get.snackbar('Error', 'Failed to fetch articles: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  void toggleSearchVisibility() {
    isSearchVisible.toggle();
    if (!isSearchVisible.value) {
      searchController.clear();
      filteredArticles.assignAll(articles);
    }
  }

  void filterArticles(String query) {
    final searchQuery = query.trim().toLowerCase();
    filteredArticles.assignAll(
      searchQuery.isEmpty
          ? articles
          : articles.where((article) {
        final title = article['title']?.toString().toLowerCase() ?? '';
        final content = article['content']?.toString().toLowerCase() ?? '';
        return title.contains(searchQuery) || content.contains(searchQuery);
      }).toList(),
    );
  }
}
import 'dart:convert';
import 'package:get/get.dart';
import 'package:treenode/services/api/HttpService.dart';
import 'package:treenode/viewModel/NodeTree.dart';
import 'package:treenode/views/articles/ArticleSingleScreen.dart';
import 'package:treenode/views/extras/components/SavedScreen.dart';
import 'package:treenode/views/treeView/CategoryScreen.dart';
import 'package:treenode/views/treeView/Issusscreen.dart';
import 'package:treenode/views/treeView/StepScreen.dart';

class ArticleController extends GetxController {
  var article = <String, dynamic>{}.obs;
  var isLoading = false.obs;
  final HttpService httpService = HttpService();

  String _decodeUtf8(String text) {
    if (text.isEmpty) return text;
    try {
      List<int> bytes = latin1.encode(text);
      return utf8.decode(bytes, allowMalformed: true);
    } catch (e) {
      return text;
    }
  }

  Future<bool> loadArticleDetails(int articleId) async {
    isLoading.value = true;
    try {
      final data = await httpService.fetchArticleById(articleId);
      final articleData = data['article'] ?? {};
      articleData['title'] = _decodeUtf8(articleData['title'] ?? '');
      articleData['content'] = _decodeUtf8(articleData['content'] ?? '');
      article.assignAll(articleData);
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> navigateToArticle(int articleId, {bool isRoute = false}) async {
    if (isRoute) {
      globalNavigationStack.clear();
      globalNavigationStack.add(NavigationNode(type: NodeType.saved, id: 0));
    }
    bool success = await loadArticleDetails(articleId);
    if (success) {
      globalNavigationStack.add(NavigationNode(type: NodeType.article, id: articleId));
      Get.offAll(() => ArticleSingleScreen(articleId: articleId));
    }
  }

  void navigateToNode(NavigationNode node) {
    if (node.type == NodeType.category) {
      Get.offAll(() => CategoryScreen(categoryId: node.id, isRoot: false));
    } else if (node.type == NodeType.issue) {
      Get.offAll(() => Issusscreen(issueId: node.id));
    } else if (node.type == NodeType.step) {
      Get.offAll(() => StepScreen(stepId: node.id));
    } else if (node.type == NodeType.article) {
      Get.offAll(() => ArticleSingleScreen(articleId: node.id));
    } else if (node.type == NodeType.saved) {
      Get.offAll(() => SavedScreen());
    }
  }

  void navigateBack() {
    print("Navigation Stack: $globalNavigationStack");

    if (globalNavigationStack.length > 1) {
      globalNavigationStack.removeLast();
      NavigationNode previous = globalNavigationStack.last;
      navigateToNode(previous);
    } else {
      globalNavigationStack.clear();
      Get.back();
    }
  }
}
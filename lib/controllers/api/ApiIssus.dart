import 'dart:convert';
import 'package:get/get.dart';
import 'package:treenode/controllers/saved/SavedController.dart';
import 'package:treenode/services/api/HttpService.dart';
import 'package:treenode/viewModel/NodeTree.dart';
import 'package:treenode/views/articles/ArticleSingleScreen.dart';
import 'package:treenode/views/extras/components/SavedScreen.dart';
import 'package:treenode/views/treeView/Issusscreen.dart';
import 'package:treenode/views/treeView/StepScreen.dart';
import 'package:treenode/views/treeView/CategoryScreen.dart';

class IssueController extends GetxController {
  var issue = <String, dynamic>{}.obs;
  var question = <String, dynamic>{}.obs;
  var isLoading = false.obs;
  final HttpService httpService = HttpService();
  final SavedController savedController = Get.find<SavedController>();

  String _decodeUtf8(String text) {
    if (text.isEmpty) return text;
    try {
      List<int> bytes = latin1.encode(text);
      return utf8.decode(bytes, allowMalformed: true);
    } catch (e) {
      return text;
    }
  }

  Future<bool> loadIssueDetails(int issueId) async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> data = await httpService.fetchIssueDetails(issueId);
      final issueDetails = data['issue'] ?? {};
      final questionDetails = data['question'] ?? {};
      final optionsList = data['options'] ?? [];

      if (issueDetails['description'] != null) {
        issueDetails['description'] = _decodeUtf8(issueDetails['description']);
      }
      if (issueDetails['title'] != null) {
        issueDetails['title'] = _decodeUtf8(issueDetails['title']);
      }
      if (questionDetails['text'] != null) {
        questionDetails['text'] = _decodeUtf8(questionDetails['text']);
      }
      if (optionsList is List) {
        questionDetails['options'] = optionsList.map((option) {
          return {
            ...option,
            'text': _decodeUtf8(option['text'] ?? ''),
          };
        }).toList();
      }
      issue.assignAll(issueDetails);
      question.assignAll(Map<String, dynamic>.from(questionDetails));
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> navigateToIssue(int issueId, {bool isRoute = false}) async {
    if (isRoute) {
      globalNavigationStack.clear();
      globalNavigationStack.add(NavigationNode(type: NodeType.saved, id: 0));
    }
    bool success = await loadIssueDetails(issueId);
    if (success) {
      globalNavigationStack.add(NavigationNode(type: NodeType.issue, id: issueId));
      Get.offAll(() => Issusscreen(issueId: issueId));
    }
  }


  void navigateBack() {

    if (globalNavigationStack.length > 1) {
      globalNavigationStack.removeLast();
      NavigationNode previous = globalNavigationStack.last;

      if (previous.type == NodeType.issue) {
        Get.offAll(() => Issusscreen(issueId: previous.id));
      } else if (previous.type == NodeType.step) {
        Get.offAll(() => StepScreen(stepId: previous.id));
      } else if (previous.type == NodeType.category) {
        Get.offAll(() => CategoryScreen(categoryId: previous.id, isRoot: false));
      } else if (previous.type == NodeType.article) {
        Get.offAll(() => ArticleSingleScreen(articleId: previous.id));
      } else if (previous.type == NodeType.saved) {
        Get.offAll(() => SavedScreen());
      }
    } else {
      globalNavigationStack.clear();
      Get.back();
    }
  }
}
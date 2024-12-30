import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/services/api/HttpService.dart';
import 'package:treenode/views/treeView/IssusScreen.dart';

class IssueController extends GetxController {
  var issue = <String, dynamic>{}.obs;
  var question = <String, dynamic>{}.obs;
  var isLoading = false.obs;

  var stepDetails = <String, dynamic>{}.obs;
  var isStepLoading = false.obs;

  final HttpService httpService = HttpService();

  final List<int> navigationStack = [];

  String _decodeUtf8(String text) {
    return utf8.decode(text.runes.toList(), allowMalformed: true);
  }

  final Map<int, Map<String, dynamic>> issueCache = {};

  Future<void> loadIssueDetails(int issueId) async {
    isLoading.value = true;
    try {
      if (issueCache.containsKey(issueId)) {
        issue.assignAll(issueCache[issueId]!);
        question.assignAll(Map<String, dynamic>.from(issueCache[issueId]!['question'] ?? {}));
        print("Using cached Issue Details: $issue");
        return;
      }

      final Map<String, dynamic> data = await httpService.fetchIssueDetails(issueId);
      print("Fetched Issue Details: $data");

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
      issueCache[issueId] = issueDetails;

      print("Assigned Issue Details: ${issue['description']}");
      print("Assigned Question Details: $question");

    } catch (e) {
      print("Error loading issue details: $e");
      Get.snackbar(
        "Error".tr,
        "$e",
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true,
        duration: Duration(seconds: 20),
        backgroundColor: Colors.redAccent.withOpacity(0.4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStepDetails(int stepId) async {
    isStepLoading.value = true;
    try {
      final Map<String, dynamic> data = await httpService.fetchStepDetail(stepId);
      print("Fetched Step Details: $data");

      final stepData = data['step'] ?? {};
      final questionData = data['question'] ?? {};
      final question = stepData['question'] ?? {};

      if (stepData['issue'] != null) {
        stepData['issue'] = _decodeUtf8(stepData['issue']);
      }
      if (stepData['solution'] != null) {
        stepData['solution'] = _decodeUtf8(stepData['solution']);
      }
      if (stepData['letter'] != null) {
        stepData['letter'] = _decodeUtf8(stepData['letter']);
      }

      if (question is Map<String, dynamic>) {
        if (question['text'] != null) {
          question['text'] = _decodeUtf8(question['text']);
        }
      }

      final optionsList = data['options'] ?? [];
      if (optionsList is List) {
        question['options'] = optionsList.map((option) {
          return {
            ...option,
            'text': _decodeUtf8(option['text'] ?? ''),
          };
        }).toList();
      }

      stepDetails.assignAll(stepData);
      this.question.assignAll(Map<String, dynamic>.from(question));

      print("Assigned Step Details: ${stepDetails['issue']}");
      print("Assigned Question Details: $question");

    } catch (e) {
      print("Error loading step details: $e");
      Get.snackbar(
        "Error".tr,
        "$e",
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true,
        duration: Duration(seconds: 20),
        backgroundColor: Colors.redAccent.withOpacity(0.4),
      );
    } finally {
      isStepLoading.value = false;
    }
  }

  void navigateBack() {
    if (navigationStack.isNotEmpty) {
      navigationStack.removeLast();
      if (navigationStack.isNotEmpty) {
        final previousIssueId = navigationStack.last;
        loadIssueDetails(previousIssueId).then((_) {
          Get.off(() => Issusscreen(issueId: previousIssueId));
        });
      } else {
        Get.back();
      }
    }
  }

  void navigateToIssue(int issueId) {
    if (navigationStack.isEmpty || navigationStack.last != issueId) {
      navigationStack.add(issueId);
    }

    loadIssueDetails(issueId).then((_) {
      Get.to(() => Issusscreen(issueId: issueId));
    });
  }
}

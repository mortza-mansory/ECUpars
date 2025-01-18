import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/services/api/HttpService.dart';
import 'package:treenode/views/treeView/IssusScreen.dart';
import 'dart:convert';

class IssueController extends GetxController {

  var issue = <String, dynamic>{}.obs;
  var question = <String, dynamic>{}.obs;
  var isLoading = false.obs;

  var stepDetails = <String, dynamic>{}.obs;
  var stepQuestion = <String, dynamic>{}.obs;
  var isStepLoading = false.obs;

  final HttpService httpService = HttpService();

  final List<int> navigationStack = [];

  String _decodeUtf8(String text) {
    if (text.isEmpty) return text;
    try {
      List<int> bytes = latin1.encode(text);
      var out = utf8.decode(bytes, allowMalformed: true);
      print(out);
      return out;
    } catch (e) {
      print("Error decoding: $e");
      return text;
    }
  }

  Future<void> loadIssueDetails(int issueId) async {
    isLoading.value = true;
    try {
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
      final stepQuestionData = data['question'] ?? {};
      final stepOptionsList = data['options'] ?? [];

      stepData['title'] = _decodeUtf8(stepData['title'] ?? '');
      stepData['description'] = _decodeUtf8(stepData['description'] ?? '');

      if (stepData['issue'] != null) {
        stepData['issue'] = _decodeUtf8(stepData['issue']);
      }
      if (stepData['solution'] != null) {
        stepData['solution'] = _decodeUtf8(stepData['solution']);
      }
      if (stepData['letter'] != null) {
        stepData['letter'] = _decodeUtf8(stepData['letter']);
      }
      if (stepQuestionData is Map<String, dynamic>) {
        if (stepQuestionData['text'] != null) {
          stepQuestionData['text'] = _decodeUtf8(stepQuestionData['text']);
        }
      }

      if (stepOptionsList is List) {
        stepQuestionData['options'] = stepOptionsList.map((option) {
          return {
            ...option,
            'text': _decodeUtf8(option['text'] ?? ''),
          };
        }).toList();
      }

      stepDetails.assignAll(stepData);
      stepQuestion.assignAll(Map<String, dynamic>.from(stepQuestionData));

      print("Assigned Step Details: ${stepDetails['issue']}");
      print("Assigned Step Question Details: $stepQuestion");

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
          Get.to(() => Issusscreen(issueId: previousIssueId));
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

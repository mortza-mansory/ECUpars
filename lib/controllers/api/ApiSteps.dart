import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/services/api/HttpService.dart';
import 'package:treenode/viewModel/NodeTree.dart';
import 'package:treenode/views/articles/ArticleSingleScreen.dart';
import 'package:treenode/views/extras/components/SavedScreen.dart';
import 'package:treenode/views/treeView/StepScreen.dart';
import 'package:treenode/views/treeView/Issusscreen.dart';
import 'package:treenode/views/treeView/CategoryScreen.dart';

class StepController extends GetxController {
  var stepDetails = <String, dynamic>{}.obs;
  var stepQuestion = <String, dynamic>{}.obs;
  var isStepLoading = false.obs;

  final HttpService httpService = HttpService();

  String _decodeUtf8(String text) {
    if (text.isEmpty) return text;
    try {
      final bytes = latin1.encode(text);
      return utf8.decode(bytes, allowMalformed: true);
    } catch (e) {
      return text;
    }
  }

  Future<bool> loadStepDetails(int stepId) async {
    isStepLoading.value = true;
    try {
      final data = await httpService.fetchStepDetail(stepId);
      final stepData = data['step'] ?? {};
      final stepQuestionData = data['question'] ?? {};
      final stepOptionsList = data['options'] ?? [];

      stepData['title'] = _decodeUtf8(stepData['title'] ?? '');
      stepData['description'] = _decodeUtf8(stepData['description'] ?? '');

      if (stepQuestionData is Map<String, dynamic>) {
        stepQuestionData['text'] = _decodeUtf8(stepQuestionData['text'] ?? '');
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
      return true;
    } catch (e) {
      String errorMessage = mapErrorToTranslation(e.toString());
    //  Get.snackbar("Error".tr, errorMessage, backgroundColor: Colors.red);
      return false;
    } finally {
      isStepLoading.value = false;
    }
  }

  String mapErrorToTranslation(String error) {
    if (error.contains("مرحله عیب‌یابی یافت نشد")) {
      return "step_not_found".tr;
    }
    if (error.contains("برای دسترسی باید وارد شوید")) {
      return "login_required".tr;
    }
    if (error.contains("طرح اشتراکی فعال ندارید")) {
      return "no_active_subscription".tr;
    }
    if (error.contains("اشتراک شما غیرفعال است")) {
      return "subscription_inactive".tr;
    }
    if (error.contains("دسترسی به این دسته محدود شده است")) {
      return "category_access_restricted".tr;
    }
    if (error.contains("دسترسی به نقشه‌ها مجاز نیست")) {
      return "map_access_denied".tr;
    }
    if (error.contains("دسترسی به خطاهای این دسته مجاز نیست")) {
      return "issues_access_denied".tr;
    }
    return "unknown_error".tr;
  }


  Future<void> navigateToStep(int stepId, {bool isRoute = false}) async {
    if (isRoute) {
      globalNavigationStack.clear();
      globalNavigationStack.add(NavigationNode(type: NodeType.saved, id: 0));
    }
    bool success = await loadStepDetails(stepId);
    if (success) {
      globalNavigationStack.add(NavigationNode(type: NodeType.step, id: stepId));
      Get.offAll(() => StepScreen(stepId: stepId));
    }
  }

  void navigateBack() {
    print("Navigation Stack: $globalNavigationStack");

    if (globalNavigationStack.length > 1) {
      globalNavigationStack.removeLast();
      NavigationNode previous = globalNavigationStack.last;

      if (previous.type == NodeType.step) {
        Get.offAll(() => StepScreen(stepId: previous.id));
      } else if (previous.type == NodeType.issue) {
        Get.offAll(() => Issusscreen(issueId: previous.id));
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
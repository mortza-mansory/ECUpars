import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:treenode/controllers/api/ApiIssus.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:html/parser.dart' as parser;
import 'package:treenode/views/treeView/extention/TextExtention.dart';
import 'extention/imgext.dart';

class StepScreen extends StatelessWidget {
  final int stepId;

  StepScreen({required this.stepId});

  @override
  Widget build(BuildContext context) {
    final issueController = Get.find<IssueController>();
    final themeController = Get.find<ThemeController>();

    double h = MediaQuery
        .of(context)
        .size
        .height;
    double w = MediaQuery
        .of(context)
        .size
        .width;

    issueController.fetchStepDetails(stepId);

    return WillPopScope(
      onWillPop: () async {
        issueController.navigateBack();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: themeController.isDarkTheme.value
              ? const Color.fromRGBO(44, 45, 49, 1)
              : const Color.fromRGBO(255, 250, 244, 1),
          iconTheme: IconThemeData(
            color: themeController.isDarkTheme.value ? Colors.white : Colors
                .black,
          ),
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Obx(
                () =>
                Text(
                  issueController.stepDetails['issue'] ?? 'Step Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkTheme.value
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
          ),
          centerTitle: false,
        ),
        body: Obx(
              () {
            if (issueController.isStepLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: themeController.isDarkTheme.value
                      ? Colors.white
                      : Colors.black,
                ),
              );
            }

            final step = issueController.stepDetails;
            final question = issueController.stepQuestion;
            final options = question['options'] ?? [];

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("Step Issue".tr, themeController, w),
                    Text(step['title'] ?? '', style: TextStyle(fontSize: 16)),
                    SizedBox(height: h * 0.02),
                    _buildSectionHeader("Solution".tr, themeController, w),
                    Html(
                      data: step['description'],
                      extensions: [
                        ImageExtention(),
                        TextExtension()
                      ],
                    ),
                    SizedBox(height: h * 0.02),
                    _buildSectionHeader("Map".tr, themeController, w),
                    Html(
                      data: step['map'] != null && step['map']['url'] != null
                          ? "<img src='${step['map']['url']}' />"
                          : "",
                      extensions: [
                        ImageExtention(),
                        TextExtension()
                      ],
                    ),
                    SizedBox(height: h * 0.02),
                    _buildSectionHeader("Question".tr, themeController, w),
                    if (step.isNotEmpty)
                      _buildQuestionSection(question, options, themeController, w),
                    Html(
                      data: (step['images'] != null && step['images'] is List)
                          ? step['images']
                          .map<String>((image) => "<img src='${image['src']}' />")
                          .join()
                          : '',
                      extensions: [
                        ImageExtention(),
                        TextExtension()
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeController themeController,
      double w) {
    return Padding(
      padding: EdgeInsets.only(top: w * 0.06, bottom: w * 0.03),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: themeController.isDarkTheme.value ? Colors.white : Colors
              .black,
        ),
      ),
    );
  }

  Widget _buildQuestionSection(Map<String, dynamic> question,
      List<dynamic> options, ThemeController themeController, double w) {
    final issueController = Get.find<IssueController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(question['text'] == "")
        // so we dont have anything to show..
          SizedBox(height: w * 0.02),
        ...options.map((option) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(option['text'], style: TextStyle(fontSize: 14)),
              ElevatedButton(
                onPressed: () {
                  print("option: ${option['id']}");

                  if (option['issue_id'] != null) {
                    issueController.navigateToIssue(option['issue_id']);
                  } else if (option['next_step_id'] != null) {
                    issueController.fetchStepDetails(option['next_step_id'])
                        .then((_) {
                      Get.to(() => StepScreen(stepId: option['next_step_id']));
                    });
                  }
                },
                child: Text("Go"),
              ),
            ],
          );
        }).toList()
      ],
    );
  }
}
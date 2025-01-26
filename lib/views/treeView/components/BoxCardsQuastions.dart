import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/api/ApiIssus.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/treeView/StepScreen.dart';

Widget BoxCardsQuastions(Map<String, dynamic> question,
    List<dynamic> options, ThemeController themeController, double w) {
  final issueController = Get.find<IssueController>();

  String questionText = question['text'] ?? 'No Question Text';

  return Container(
    width: w,
    padding: EdgeInsets.symmetric(vertical: w * 0.02),
    decoration: BoxDecoration(
      color: const Color.fromARGB(150, 253, 107, 107),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color.fromARGB(255, 253, 107, 107),
        width: 3.0,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: w * 0.02),
        Center(
          child: Container(
            width: w * 0.8,
            padding: EdgeInsets.all(w * 0.02),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 253, 107, 107),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              questionText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: w * 0.035,
                color: Colors.white,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
        SizedBox(height: w * 0.06),

        if (question['text'] == "") SizedBox(height: w * 0.01),
        ...options.map((option) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  print("option: ${option['id']}");

                  if (option['issue_id'] != null) {
                    issueController.navigateToIssue(option['issue_id']);
                  } else if (option['next_step_id'] != null) {
                    issueController
                        .fetchStepDetails(option['next_step_id'])
                        .then((_) {
                      Get.to(() => StepScreen(stepId: option['next_step_id']));
                    });
                  }
                },
                child: Center(
                  child: Container(
                    width: w * 0.8,
                    height: w * 0.08,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 253, 107, 107),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          option['text'],
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: w*0.03,
                            color: themeController.isDarkTheme.value
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: w * 0.02),
            ],
          );
        }).toList(),

        SizedBox(height: w * 0.06),
      ],
    ),
  );
}

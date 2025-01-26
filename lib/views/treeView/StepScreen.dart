import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:treenode/controllers/api/ApiIssus.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/treeView/components/BoxCardsMap.dart';
import 'package:treenode/views/treeView/components/BoxCardsQuastions.dart';
import 'package:treenode/views/treeView/components/BoxCardsSteps.dart';
import 'package:treenode/views/treeView/extention/TextExtention.dart';
import 'extention/imgext.dart';

class StepScreen extends StatelessWidget {
  final int stepId;

  StepScreen({required this.stepId});

  @override
  Widget build(BuildContext context) {
    final issueController = Get.find<IssueController>();
    final themeController = Get.find<ThemeController>();

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    issueController.fetchStepDetails(stepId);

    return WillPopScope(
      onWillPop: () async {
        issueController.navigateBack();
        return true;
      },
      child: Scaffold(
        backgroundColor: themeController.isDarkTheme.value
            ? const Color.fromRGBO(44, 45, 49, 1)
            : const Color.fromRGBO(255, 250, 244, 1),
        appBar: AppBar(
          backgroundColor: themeController.isDarkTheme.value
              ? const Color.fromRGBO(44, 45, 49, 1)
              : const Color.fromRGBO(255, 250, 244, 1),
          iconTheme: IconThemeData(
            color:
                themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Obx(
            () => Text(
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
                      ? Colors.white.withOpacity(0.8)
                      : Colors.black.withOpacity(0.8),
                ),
              );
            }
            final step = issueController.stepDetails;
            final question = issueController.stepQuestion;
            final options = question['options'] ?? [];

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                BoxCards(
                title: step['title'] ?? '',
                  description: step['description'] ?? '',
                  h: h,
                ),

                    SizedBox(height: h * 0.02),
                    BoxCardsMap(
                      step: step,
                      h: h,
                    ),
                    SizedBox(height: h * 0.02),
                    if (step.isNotEmpty)
                      BoxCardsQuastions(
                        question,
                        options,
                        themeController,
                        w,
                      ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      child: Html(
                        data: (step['images'] != null && step['images'] is List)
                            ? step['images']
                            .map<String>(
                                (image) => "<img src='${image['src']}' />")
                            .join()
                            : '',
                        extensions: [ImageExtention(), TextExtension()],
                      ),
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
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:treenode/controllers/api/ApiIssus.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

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
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: themeController.isDarkTheme.value
              ? const Color.fromRGBO(44, 45, 49, 1)
              : const Color.fromRGBO(255, 250, 244, 1),
          iconTheme: IconThemeData(
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
          elevation: 0,
          leading: IconButton(
            onPressed: () => issueController.navigateBack(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Obx(
                () => Text(
              issueController.stepDetails['issue'] ?? 'Step Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
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
                  color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                ),
              );
            }

            final step = issueController.stepDetails;
            final question = issueController.question;
            final options = question['options'] ?? [];

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("Step Issue", themeController, w),
                    Text(step['title'] ?? '', style: TextStyle(fontSize: 16)),
                    SizedBox(height: h * 0.02),
                    _buildSectionHeader("Solution", themeController, w),
                    Html(
                      data: step['description'] ??
                          '<p>No description available.</p>',
                      extensions: [
                        ImageExtension(
                          //اینم نشد...
                          // builder: (ExtensionContext context) {
                          //   String src = context.attributes['src'] ?? '';
                          //   String baseUrl = "https://django-noxeas.chbk.app";
                          //   String modifiedSrc = "$baseUrl$src";
                          //   print("Constructed image URL: $modifiedSrc");
                          //   return Image.network(modifiedSrc, fit: BoxFit.cover);
                          // },
                        ),
                      ],
                      style: {
                        "body": Style(
                          fontSize: FontSize.medium,
                          fontFamily: "Sarbaz",
                          color: themeController.isDarkTheme.value ? Colors
                              .white : Colors.black,
                        ),
                      },
                    ),
                    SizedBox(height: h * 0.02),
                    _buildSectionHeader("Question", themeController, w),
                    if (step.isNotEmpty) _buildQuestionSection(question, options, themeController, w),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeController themeController, double w) {
    return Padding(
      padding: EdgeInsets.only(top: w * 0.06, bottom: w * 0.03),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildQuestionSection(Map<String, dynamic> question, List<dynamic> options, ThemeController themeController, double w) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['text'] ?? "no quastions.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: w * 0.02),
        ...options.map((option) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(option['text'], style: TextStyle(fontSize: 14)),
              ElevatedButton(
                onPressed: () {
                  print("option: ${option['id']}");

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

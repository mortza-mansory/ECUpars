import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:treenode/controllers/api/ApiIssus.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/services/api/config/endpoint.dart';
import 'package:treenode/views/home/homeScreen.dart';
import 'package:treenode/views/treeView/StepScreen.dart';
import 'package:treenode/views/treeView/extention/imgext.dart';

class Issusscreen extends StatelessWidget {
  final int issueId;

  Issusscreen({required this.issueId});

  @override
  Widget build(BuildContext context) {
    final issueController = Get.find<IssueController>();
    final themeController = Get.find<ThemeController>();
    final langController = Get.find<LangController>();

    double h = MediaQuery
        .of(context)
        .size
        .height;
    double w = MediaQuery
        .of(context)
        .size
        .width;

    issueController.loadIssueDetails(issueId);

    return WillPopScope(
      onWillPop: () async {
        // showConfirmationDialog(context);
        //for false
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
                  issueController.issue['title'] ?? 'Issue Details',
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
            if (issueController.isLoading.value) {
              return _buildLoadingScreen(themeController);
            }
            final issue = issueController.issue;
            final question = issueController.question;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("Issue Title", themeController, w),
                    Text(issue['title'] ?? '', style: TextStyle(fontSize: 16)),
                    SizedBox(height: h * 0.003),
                    _buildSectionHeader("Description", themeController, w),
                    Html(
                      data: issue['description'] ??
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
                    SizedBox(height: h * 0.003),
                    _buildSectionHeader("Additional Info", themeController, h),
                    Text('Created by: ${issue['created_by']}',
                        style: TextStyle(fontSize: 16)),
                    Text('Created at: ${issue['created_at']}',
                        style: TextStyle(fontSize: 16)),

                    SizedBox(height: h * 0.02),
                    _buildSectionHeader("Related Question", themeController, w),

                    if (question.isNotEmpty) QuestionSection(
                        question, question['options'] ?? [], w) else
                      Text("No relaated quastions.")
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
      double h) {
    return Padding(
      padding: EdgeInsets.only(top: h * 0.006, bottom: h * 0.003),
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

  Widget _buildLoadingScreen(ThemeController themeController) {
    return Center(
      child: CircularProgressIndicator(
        color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
      ),
    );
  }

  Widget QuestionSection(Map<String, dynamic> question, List<dynamic> options,
      double w) {
    // Debugging the options
    print("Options in QuestionSection: $options");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['text'] ?? "No question available.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: w * 0.02),
        if (options.isEmpty)
          Text("No options available.")
        else
          ...options.map((option) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(option['text'] ?? "No text",
                    style: TextStyle(fontSize: 14)),
                ElevatedButton(
                  onPressed: () {
                    if (option['next_step_id'] == null) {
                      if (option['issue_id'] != null) {
                        Get.to(() => Issusscreen(issueId: option['issue_id']));
                      } else {
                        Get.snackbar(
                          "Error",
                          "We don't have any route called this.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    } else {
                      Get.to(() => StepScreen(stepId: option['next_step_id']));
                    }
                  },
                  child: Text("Go"),
                )


              ],
            );
          }).toList(),
      ],
    );
  }


  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'.tr),
          content: Text('Do you really want to go back to the home screen?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Get.offAll(() => Homescreen());
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/api/ApiCategory.dart';
import 'package:treenode/controllers/api/ApiIssus.dart';
import 'package:treenode/controllers/saved/SavedController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/viewModel/NodeTree.dart';
import 'package:treenode/views/home/homeScreen.dart';
import 'package:treenode/views/treeView/components/BoxCardsMap.dart';
import 'package:treenode/views/treeView/components/BoxCardsQuastions.dart';
import 'package:treenode/views/treeView/components/BoxCards.dart';

class Issusscreen extends StatelessWidget {
  final int issueId;

  const Issusscreen({required this.issueId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final issueController = Get.find<IssueController>();
    final themeController = Get.find<ThemeController>();
    final savedController = Get.find<SavedController>();

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        issueController.navigateBack();
        return true;
      },
      child: Obx(() => Scaffold(
        appBar: AppBar(
          backgroundColor: themeController.isDarkTheme.value
              ? const Color.fromRGBO(44, 45, 49, 1)
              : const Color.fromRGBO(255, 255, 255, 1.0),
          iconTheme: IconThemeData(
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
          elevation: 0,
          leading: IconButton(
            onPressed: () => issueController.navigateBack(),
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              onPressed: () => showConfirmationDialog(context, themeController),
              icon: Icon(
                Icons.home,
                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
              ),
            ),
            IconButton(
              onPressed: () => themeController.toggleTheme(),
              icon: const Icon(Icons.light_mode),
            ),
            Obx(() {
              final isSaved = savedController.isIssueSaved(issueId);
              return IconButton(
                onPressed: () {
                  savedController.toggleSaveIssue(
                    issueId,
                    issueController.issue.value,
                    issueController.question.value,
                  );
                },
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                ),
              );
            }),
          ],
        ),
        body: FutureBuilder<bool>(
          future: issueController.loadIssueDetails(issueId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingScreen(themeController);
            } else if (snapshot.hasError || !snapshot.data!) {
              return Center(
                child: Text(
                  'Error loading issue details'.tr,
                  style: TextStyle(
                    color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                  ),
                ),
              );
            } else {
              final issue = issueController.issue;
              final question = issueController.question;
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BoxCards(
                        title: issue['title'] ?? '',
                        description: issue['description'] ?? '',
                        h: h,
                      ),
                      SizedBox(height: h * 0.02),
                      if (question != null &&
                          question['text'] != null &&
                          question['text'].isNotEmpty)
                        SizedBox(height: h * 0.02),
                      if (issue['map'] != null &&
                          issue['map'] is Map &&
                          issue['map']['title'] != null &&
                          issue['map']['url'] != null)
                        BoxCardsMap(step: issue, h: h),
                      if (question != null &&
                          question['options'] != null &&
                          question['options'].isNotEmpty)
                        BoxCardsQuastions(
                          question,
                          question['options'],
                          themeController,
                          w,
                          h,
                        ),
                      SizedBox(height: h * 0.03),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      )),
    );
  }

  Widget _buildLoadingScreen(ThemeController themeController) {
    return Center(
      child: CircularProgressIndicator(
        color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
      ),
    );
  }

  void showConfirmationDialog(BuildContext context, ThemeController themeController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Are you sure?'.tr,
            style: TextStyle(
              color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            ),
          ),
          icon: const Icon(Icons.outbond_outlined, size: 40),
          content: Text(
            'Do you really want to go back to the home screen?'.tr,
            style: TextStyle(
              color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: themeController.isDarkTheme.value
              ? const Color.fromRGBO(44, 45, 49, 1)
              : Colors.white,
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel'.tr,
                style: TextStyle(
                  color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                globalNavigationStack.clear();
                Get.offAll(() => Homescreen());
              },
              child: Text(
                'Yes'.tr,
                style: TextStyle(
                  color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
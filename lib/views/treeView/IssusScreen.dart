import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:treenode/controllers/api/ApiIssus.dart';
import 'package:treenode/controllers/utills/LangController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/services/api/config/endpoint.dart';
import 'package:treenode/views/home/homeScreen.dart';
import 'package:treenode/views/treeView/StepScreen.dart';
import 'package:treenode/views/treeView/components/BoxCardsQuastions.dart';
import 'package:treenode/views/treeView/components/BoxCardsSteps.dart';
import 'package:treenode/views/treeView/extention/TextExtention.dart';
import 'package:treenode/views/treeView/extention/imgext.dart';

class Issusscreen extends StatelessWidget {
  final int issueId;

  Issusscreen({required this.issueId});

  @override
  Widget build(BuildContext context) {
    final issueController = Get.find<IssueController>();
    final themeController = Get.find<ThemeController>();
    final langController = Get.find<LangController>();

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

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
        body: Obx(() {
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
                  BoxCards(
                    title: issue['title'] ?? '',
                    description: issue['description'] ?? '',
                    h: h,
                  ),
                  SizedBox(height: h * 0.02),
               //   _buildSectionHeader("Related Question", themeController, w),
                  SizedBox(height: h * 0.02),
                  if (question.isNotEmpty)
                    BoxCardsQuastions(question, question['options'] ?? [],themeController,w)
                  else
                    Text("No related questions."),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // Widget _buildSectionHeader(
  //     String title, ThemeController themeController, double h) {
  //   return Padding(
  //     padding: EdgeInsets.only(top: h * 0.006, bottom: h * 0.003),
  //     child: Text(
  //       title,
  //       style: TextStyle(
  //         fontSize: 18,
  //         fontWeight: FontWeight.bold,
  //         color:
  //             themeController.isDarkTheme.value ? Colors.white : Colors.black,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildLoadingScreen(ThemeController themeController) {
    return Center(
      child: CircularProgressIndicator(
        color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
      ),
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

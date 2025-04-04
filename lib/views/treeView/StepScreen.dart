import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:treenode/controllers/api/ApiSteps.dart';
import 'package:treenode/controllers/saved/SavedController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/viewModel/NodeTree.dart';
import 'package:treenode/views/home/homeScreen.dart';
import 'package:treenode/views/treeView/components/BoxCardsMap.dart';
import 'package:treenode/views/treeView/components/BoxCardsQuastions.dart';
import 'package:treenode/views/treeView/components/BoxCards.dart';
import 'package:treenode/views/treeView/extention/PExtention.dart';
import 'package:treenode/views/treeView/extention/TextExtention.dart';

class StepScreen extends StatelessWidget {
  final int stepId;

  const StepScreen({required this.stepId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stepController = Get.find<StepController>();
    final themeController = Get.find<ThemeController>();
    final savedController = Get.find<SavedController>();

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        stepController.navigateBack();
        return true;
      },
      child: Obx(() => Scaffold(
            backgroundColor: themeController.isDarkTheme.value
                ? const Color.fromRGBO(44, 45, 49, 1)
                : const Color.fromRGBO(255, 255, 255, 1.0),
            appBar: AppBar(
              backgroundColor: themeController.isDarkTheme.value
                  ? const Color.fromRGBO(44, 45, 49, 1)
                  : const Color.fromRGBO(255, 255, 255, 1.0),
              iconTheme: IconThemeData(
                color: themeController.isDarkTheme.value
                    ? Colors.white
                    : Colors.black,
              ),
              elevation: 0,
              leading: IconButton(
                onPressed: () => stepController.navigateBack(),
                icon: const Icon(Icons.arrow_back),
              ),
              actions: [
                IconButton(
                  onPressed: () =>
                      showConfirmationDialog(context, themeController),
                  icon: Icon(
                    Icons.home,
                    color: themeController.isDarkTheme.value
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    themeController.toggleTheme();
                  },
                  icon: const Icon(Icons.light_mode),
                ),
                Obx(() {
                  bool isSaved = savedController.isStepSaved(stepId);
                  return IconButton(
                    onPressed: () {
                      savedController.toggleSaveStep(
                        stepId,
                        stepController.stepDetails,
                        stepController.stepQuestion,
                      );
                      print(savedController.savedSteps);
                    },
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: themeController.isDarkTheme.value
                          ? Colors.white
                          : Colors.black,
                    ),
                  );
                }),
              ],
            ),
            body: FutureBuilder<bool>(
              future: stepController.loadStepDetails(stepId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: themeController.isDarkTheme.value
                          ? Colors.white.withOpacity(0.8)
                          : Colors.black.withOpacity(0.8),
                    ),
                  );
                } else if (snapshot.hasError || !snapshot.data!) {
                  return Center(
                    child: Text(
                      stepController
                          .mapErrorToTranslation(snapshot.error.toString()),
                      style: TextStyle(
                        color: themeController.isDarkTheme.value
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  );
                } else {
                  final step = stepController.stepDetails;
                  final question = stepController.stepQuestion;
                  final options = question['options'] ?? [];

                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((step['title'] != null &&
                                  step['title'].isNotEmpty) ||
                              (step['description'] != null &&
                                  step['description'].isNotEmpty))
                            BoxCards(
                              title: step['title'] ?? '',
                              description: step['description'] ?? '',
                              h: h,
                            ),
                          if ((step['title'] != null &&
                                  step['title'].isNotEmpty) ||
                              (step['description'] != null &&
                                  step['description'].isNotEmpty))
                            SizedBox(height: h * 0.02),
                          if (step['map'] != null &&
                              step['map'] is Map &&
                              step['map']['title'] != null &&
                              step['map']['url'] != null)
                            BoxCardsMap(
                              step: step,
                              h: h,
                            ),
                          if (step['map'] != null &&
                              step['map'] is Map &&
                              step['map']['title'] != null &&
                              step['map']['url'] != null)
                            SizedBox(height: h * 0.02),
                          if (question != null &&
                              options != null &&
                              options.isNotEmpty)
                            BoxCardsQuastions(
                              question,
                              options,
                              themeController,
                              w,
                              h,
                            ),
                          if (step['images'] != null &&
                              step['images'] is List &&
                              step['images'].isNotEmpty)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              child: Html(
                                data: step['images']
                                    .map<String>((image) =>
                                        "<img src='${image['src']}' />")
                                    .join(),
                                extensions: [
                                  ImageExtension(),
                                  TextExtension(),
                                  Pextention()
                                ],
                              ),
                            ),
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

  void showConfirmationDialog(
      BuildContext context, ThemeController themeController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Are you sure?'.tr,
            style: TextStyle(
              color: themeController.isDarkTheme.value
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          icon: const Icon(Icons.outbond_outlined, size: 40),
          content: Text(
            'Do you really want to go back to the home screen?'.tr,
            style: TextStyle(
              color: themeController.isDarkTheme.value
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          backgroundColor: themeController.isDarkTheme.value
              ? const Color.fromRGBO(44, 45, 49, 1)
              : Colors.white,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel'.tr,
                style: TextStyle(
                  color: themeController.isDarkTheme.value
                      ? Colors.white
                      : Colors.black,
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
                  color: themeController.isDarkTheme.value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/saved/SavedController.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/extras/ExtrasScreen.dart';
import 'package:treenode/views/extras/components/com/SavedContainers.dart';
import 'package:treenode/views/home/homeScreen.dart';

class SavedScreen extends StatelessWidget {
  SavedScreen({super.key});

  final ThemeController themeController = Get.find();
  final SavedController savedController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeController.isDarkTheme.value
            ? const Color.fromRGBO(44, 45, 49, 1)
            : const Color.fromRGBO(255, 255, 255, 1.0),
        iconTheme: IconThemeData(
          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
        ),
        elevation: 0,
        //PATH NIGHT
        leading: IconButton(
          onPressed: () {
            Get.to((()=> Homescreen()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          "Saved".tr,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            fontFamily: 'Sarbaz',
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final allSavedItems = [
          ...savedController.savedIssueIds.map((id) => {
            'type': 'issue',
            'id': id,
            'data': savedController.savedIssues[id]?['issue'],
            'savedAt': savedController.savedIssues[id]?['savedAt'],
          }),
          ...savedController.savedMapIds.map((id) => {
            'type': 'map',
            'id': id,
            'data': savedController.savedMaps[id]?['map'],
            'savedAt': savedController.savedMaps[id]?['savedAt'],
          }),
          ...savedController.savedArticleIds.map((id) => {
            'type': 'article',
            'id': id,
            'data': savedController.savedArticles[id]?['article'],
            'savedAt': savedController.savedArticles[id]?['savedAt'],
          }),
          ...savedController.savedStepIds.map((id) => {
            'type': 'step',
            'id': id,
            'data': savedController.savedSteps[id]?['step'],
            'savedAt': savedController.savedSteps[id]?['savedAt'],
          }),
        ];

        allSavedItems.sort((a, b) {
          final aSavedAt = a['savedAt'] != null ? DateTime.parse(a['savedAt']) : DateTime(0);
          final bSavedAt = b['savedAt'] != null ? DateTime.parse(b['savedAt']) : DateTime(0);
          return bSavedAt.compareTo(aSavedAt);
        });

        print("All saved items (raw): $allSavedItems"); // Debug log before decoding

        if (allSavedItems.isEmpty) {
          return Center(
            child: Text(
              'No saved items yet'.tr,
              style: TextStyle(
                fontSize: 18,
                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: allSavedItems.length,
          itemBuilder: (context, index) {
            if (index >= allSavedItems.length) {
              return const SizedBox();
            }

            final item = allSavedItems[index];
            final type = item['type'] as String;
            final id = item['id'] as int;
            final rawData = item['data'] as Map<String, dynamic>?;

            if (rawData == null) {
              return const SizedBox();
            }

            // Decode the data before passing it to SavedContainers
            final decodedData = savedController.decodeItemData(type, rawData);
            print("Decoded data for $type-$id: $decodedData"); // Debug log after decoding

            return Dismissible(
              key: Key('$type-$id'),
              direction: DismissDirection.horizontal,
              onDismissed: (direction) {
                final currentId = id;
                final progressNotifier = ValueNotifier<double>(1.0);
                final duration = const Duration(seconds: 4);
                final timer = Stopwatch()..start();

                if (type == 'issue') {
                  savedController.savedIssueIds.remove(currentId);
                } else if (type == 'map') {
                  savedController.savedMapIds.remove(currentId);
                } else if (type == 'article') {
                  savedController.savedArticleIds.remove(currentId);
                } else if (type == 'step') {
                  savedController.savedStepIds.remove(currentId);
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Expanded(child: Text("Removing...".tr)),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: ValueListenableBuilder<double>(
                            valueListenable: progressNotifier,
                            builder: (context, value, child) {
                              return CircularProgressIndicator(
                                value: value,
                                backgroundColor: Colors.grey.shade300,
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    duration: duration,
                    action: SnackBarAction(
                      label: "Cancel".tr,
                      textColor: Colors.white,
                      onPressed: () {
                        timer.stop();
                        if (type == 'issue') {
                          savedController.savedIssueIds.add(currentId);
                        } else if (type == 'map') {
                          savedController.savedMapIds.add(currentId);
                        } else if (type == 'article') {
                          savedController.savedArticleIds.add(currentId);
                        } else if (type == 'step') {
                          savedController.savedStepIds.add(currentId);
                        }
                      },
                    ),
                  ),
                );

                Future.delayed(duration, () {
                  if (timer.isRunning) {
                    if (type == 'issue' && !savedController.savedIssueIds.contains(currentId)) {
                      savedController.removeIssue(currentId);
                    } else if (type == 'map' && !savedController.savedMapIds.contains(currentId)) {
                      savedController.removeMap(currentId);
                    } else if (type == 'article' &&
                        !savedController.savedArticleIds.contains(currentId)) {
                      savedController.removeArticle(currentId);
                    } else if (type == 'step' && !savedController.savedStepIds.contains(currentId)) {
                      savedController.removeStep(currentId);
                    }
                  }
                });

                Future.doWhile(() async {
                  await Future.delayed(const Duration(milliseconds: 100));
                  double elapsed = timer.elapsedMilliseconds / duration.inMilliseconds;
                  progressNotifier.value = 1.0 - elapsed;
                  return elapsed < 1.0 && timer.isRunning;
                });
              },
              background: Container(
                color: const Color.fromARGB(255, 253, 107, 107),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: const Color.fromARGB(255, 253, 107, 107),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: SavedContainers(
                title: decodedData['title'] ?? 'No Title'.tr,
                description: decodedData['description'] ??
                    decodedData['content'] ??
                    decodedData['image'] ??
                    '',
                type: type,
                id: id,
              ),
            );
          },
        );
      }),
    );
  }
}
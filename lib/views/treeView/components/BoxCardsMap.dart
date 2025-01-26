import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/treeView/extention/TextExtention.dart';
import 'package:treenode/views/treeView/extention/imgext.dart';

class BoxCardsMap extends StatelessWidget {
  final Map<String, dynamic> step;
  final double h;

  const BoxCardsMap({
    Key? key,
    required this.step,
    required this.h,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeController.isDarkTheme.value
            ? const Color(0xFF545454).withOpacity(0.7)
            : const Color(0xFFF8E7CD).withOpacity(0.7),
        border: Border.all(
          color: themeController.isDarkTheme.value
              ? const Color(0xFF545454)
              : const Color(0xFFFFE6B2),
          width: 2.0, // Bold border
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: h * 0.02),
          Container(
            width: h * 0.45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 253, 107, 107).withOpacity(0.8),
            ),
            child: Padding(
              padding: EdgeInsets.all(h * 0.005),
              child: Center(
                child: Text(
                  step['map'] != null && step['map']['title'] != null
                      ? step['map']['title']
                      : 'No Title',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Sarbaz',
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ),
          SizedBox(height: h * 0.02),
          Html(
            data: step['map'] != null && step['map']['url'] != null
                ? "<img src='${step['map']['url']}' />"
                : '', // Handle null URL gracefully
            extensions: [ImageExtention(), TextExtension()],
          ),
        ],
      ),
    );
  }
}

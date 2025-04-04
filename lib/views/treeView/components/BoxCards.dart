import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/treeView/extention/PExtention.dart';
import 'package:treenode/views/treeView/extention/TextExtention.dart';
import 'package:treenode/views/treeView/extention/imgext.dart';

class BoxCards extends StatelessWidget {
  final String title;
  final String description;
  final double h;

  const BoxCards({
    Key? key,
    required this.title,
    required this.description,
    required this.h,
  }) : super(key: key);

  bool isHtml(String description) {
    final regex = RegExp(r'<[^>]*>');
    return regex.hasMatch(description);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    print(description);

    return Container(
      width: double.infinity,
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: themeController.isDarkTheme.value
                  ? const Color(0xFF545454).withOpacity(0.7)
                  : const Color(0xFFF8E7CD).withOpacity(0.7),
              border: Border.all(
                color: themeController.isDarkTheme.value
                    ? const Color(0xFF545454)
                    : const Color(0xFFFFF2E2),
                width: 2.0,
              ),
            ),
            child: Container(
              width: h * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 253, 107, 107).withOpacity(0.8),
              ),
              child: Padding(
                padding: EdgeInsets.all(h * 0.005),
                child: Center(
                  child: Text(
                    title,
                    style:  TextStyle(
                      fontSize: h*0.025,
                      fontFamily: 'Sarbaz',
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: h * 0.02),
          isHtml(description)
              ?  Html(
            data: description,
            extensions: [TextExtension(), Pextention()],
            style: {
              "body": Style(
                direction: TextDirection.rtl,
              ),
              "*": Style(
                display: Display.block,
                textAlign: TextAlign.right,
                direction: TextDirection.rtl,
                fontFamily: 'Vazir',
                fontSize: FontSize(h * 0.02),
                color: themeController.isDarkTheme.value
                    ? Colors.white
                    : Colors.black,
              ),
              "strong,b": Style(
                fontWeight: FontWeight.bold,
                display: Display.inline,
              ),

              "iframe": Style(
                display: Display.block,
              ),
            },
            shrinkWrap: true,
          )
              : Text(
            description,
            style: TextStyle(
              fontSize: h * 0.02,
              fontFamily: 'Vazir',
              color: themeController.isDarkTheme.value
                  ? Colors.white
                  : Colors.black,
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
          SizedBox(height: h * 0.03),
        ],
      ),
    );
  }
}

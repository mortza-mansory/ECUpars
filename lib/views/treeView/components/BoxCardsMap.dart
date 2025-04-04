import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/services/api/config/endpoint.dart';
import 'package:treenode/views/treeView/extention/TextExtention.dart';
import 'package:treenode/views/treeView/extention/ZoomableMapImage.dart';
import 'package:treenode/views/treeView/extention/imgext.dart';

class BoxCardsMap extends StatelessWidget {
  final Map<String, dynamic> step;
  final double h;

  const BoxCardsMap({
    Key? key,
    required this.step,
    required this.h,
  }) : super(key: key);

  String decodeUtf8String(String encoded) {
    if (!encoded.contains(r'\u')) {
      return encoded;
    }
    try {
      final unescaped = encoded.replaceAllMapped(
          RegExp(r'\\u([0-9a-fA-F]{4})'),
              (match) => String.fromCharCode(int.parse(match[1]!, radix: 16)));
      return unescaped;
    } catch (e) {
      return encoded;
    }
  }

  String decodeLatin1String(String encoded) {
    try {
      return utf8.decode(latin1.encode(encoded));
    } catch (e) {
      return encoded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    final hasFlatData = step['title'] != null && step['image'] != null;
    final hasNestedData = step['map'] != null && step['map'] is Map;

    String title;
    String? imageUrl;

    if (hasFlatData) {
      title = step['title']?.isNotEmpty == true
          ? decodeUtf8String(step['title'])
          : (step['name']?.isNotEmpty == true
          ? decodeLatin1String(step['name'])
          : 'No Title');
      imageUrl = '${Endpoint.httpAddress}${step['image']}';
    } else if (hasNestedData && step['map'] != null) {
      title = step['map']['title']?.isNotEmpty == true
          ? decodeUtf8String(step['map']['title'])
          : (step['name']?.isNotEmpty == true
          ? decodeLatin1String(step['name'])
          : 'No Title');
      imageUrl = step['map']['url'];
    } else {
      title = step['name']?.isNotEmpty == true
          ? decodeLatin1String(step['name'])
          : 'No Title';
      imageUrl = null;
    }

    title = decodeUtf8String(title);
    print(title);
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
          width: 2.0,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: h * 0.02),
          Container(
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
                  style: const TextStyle(
                    fontSize: 16,
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
          SizedBox(height: h * 0.02),
          if (hasNestedData && step['map']['url'] != null)
            Html(
              data: "<img src='${step['map']['url']}' />",
              extensions: [ImageExtention(), TextExtension()],
            )
          else if (hasFlatData && imageUrl != null)
      ZoomableImageMap(imageUrl: imageUrl)
          else
             Text(
              'No Image Available'.tr,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

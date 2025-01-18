import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

class AllResultContainer extends StatelessWidget {
  final String title;
  final String description;
  final String logoUrl;

  const AllResultContainer({
    super.key,
    required this.title,
    required this.description,
    required this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final ThemeController themeController = Get.find<ThemeController>();

    return Container(
      width: w*0.98,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: themeController.isDarkTheme.value
            ? Colors.grey[700]
            : Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(
                logoUrl,
                width: h*0.07,
                height: h*0.07,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image, size: h*0.02),
              ),
               SizedBox(width: h*0.02),
              Expanded(
                child: AutoSizeText(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
           SizedBox(height: h*0.02),
          Text(
            description,
            style:  TextStyle(fontSize: h*0.015),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

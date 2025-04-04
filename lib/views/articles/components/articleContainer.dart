import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:treenode/views/articles/articleSubScreen.dart';

class ArticleContainer extends StatelessWidget {
  final Map<String, dynamic> article;

  const ArticleContainer({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    final String imageUrl = article['category']?['logo']?.toString() ?? '';
    final String title = article['title']?.toString() ?? '';
    final String content = article['content']?.toString() ?? '';

    String _removeHtmlTags(String htmlText) {
      return htmlText.replaceAll(RegExp(r'<[^>]*>'), '');
    }
    return GestureDetector(
      onTap: () {
        Get.to(() => ArticleSubScreen(article: article));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeController.isDarkTheme.value
              ? Colors.grey[800]
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300],
                    ),
                    child: imageUrl.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.article_outlined,
                                color: Colors.grey[600]),
                      ),
                    )
                        : Icon(Icons.article_outlined, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: themeController.isDarkTheme.value
                            ? Colors.white
                            : Colors.black,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _removeHtmlTags(content),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
                fontFamily: 'Vazir',
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

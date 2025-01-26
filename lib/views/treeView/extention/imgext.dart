import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:photo_view/photo_view.dart';

class ImageExtention extends HtmlExtension {
  @override
  Set<String> get supportedTags => {'img'};

  @override
  InlineSpan build(ExtensionContext context) {
    final attr = context.attributes;
    String src = attr['src'] ?? '';

    if (src.isEmpty) {
      return const TextSpan();
    }

    if (!src.startsWith('http')) {
      src = 'https://django-noxeas.chbk.app$src';
    }

    return WidgetSpan(
      child: Builder(
        builder: (BuildContext buildContext) {
          return GestureDetector(
            onTap: () {
              _showFocusMode(buildContext, src);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0), // Circular edges
              child: Image.network(
                src,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFocusMode(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.8),
          insetPadding: EdgeInsets.all(0),
          child: Stack(
            children: [
              PhotoView(
                imageProvider: NetworkImage(imageUrl),
                backgroundDecoration: BoxDecoration(color: Colors.black.withOpacity(0.8)),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 6.0,
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

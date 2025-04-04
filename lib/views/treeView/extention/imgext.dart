import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:photo_view/photo_view.dart';
import 'package:html/dom.dart' as dom;

class ImageExtention extends HtmlExtension {
  @override
  Set<String> get supportedTags => {'img', 'figure'};

  @override
  InlineSpan build(ExtensionContext context) {
    if (context.element?.localName == 'img' &&
        context.element?.parent?.localName == 'figure') {
      return const TextSpan();
    }

    String? src;
    double? customWidthPercentage;

    if (context.element?.localName == 'img') {
      src = context.element?.attributes['src'];
    } else if (context.element?.localName == 'figure') {
      final styleAttr = context.element?.attributes['style'];
      if (styleAttr != null) {
        final widthMatch = RegExp(r'width:\s*([\d.]+)%').firstMatch(styleAttr);
        if (widthMatch != null && widthMatch.groupCount >= 1) {
          customWidthPercentage = double.tryParse(widthMatch.group(1)!);
        }
      }
      final dom.Element? imgElement = context.element?.querySelector('img');
      src = imgElement?.attributes['src'];
    }

    if (src == null || src.isEmpty) {
      return const TextSpan(text: '[No image source]');
    }

    if (!src.startsWith('http')) {
      src = 'https://django-noxeas.chbk.app$src';
    }


    return WidgetSpan(
      child: Builder(
        builder: (BuildContext buildContext) {
          final imageWidth = customWidthPercentage != null
              ? MediaQuery.of(buildContext).size.width *
              customWidthPercentage /
              100
              : null;

          return GestureDetector(
            onTap: () {
              _showFocusMode(buildContext, src!);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: imageWidth != null
                  ? SizedBox(
                width: imageWidth,
                child: Image.network(
                  src!,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Text('Failed to load image: $src');
                  },
                ),
              )
                  : Image.network(
                src!,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Text('Failed to load image: $src');
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
          insetPadding: const EdgeInsets.all(0),
          child: Stack(
            children: [
              PhotoView(
                imageProvider: NetworkImage(imageUrl),
                backgroundDecoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                ),
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
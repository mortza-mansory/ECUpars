import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/dom.dart' as dom;

class TextExtension extends HtmlExtension {
  @override
  Set<String> get supportedTags => {
    'div',
    'h1',
    'h2',
    'h3',
    'h4',
    'h5',
    'h6',
    'br',
    'iframe',
    'ol',
    'ul',
    'li',
    'figure',
    'media',
    'img',
  };

  @override
  InlineSpan build(ExtensionContext context) {
    final themeController = Get.find<ThemeController>();
    final tag = context.element?.localName ?? '';

    String? youtubeUrl;
    if (context.element?.attributes.containsKey('data-oembed-url') == true) {
      youtubeUrl = context.element?.attributes['data-oembed-url'];
    } else if (tag == 'iframe' && context.element?.attributes.containsKey('src') == true) {
      youtubeUrl = context.element?.attributes['src'];
    }
    if (youtubeUrl == null && (tag == 'figure' || tag == 'media')) {
      final youtubeChild = context.element?.querySelector("[data-oembed-url*='youtube.com']");
      if (youtubeChild != null) {
        youtubeUrl = youtubeChild.attributes['data-oembed-url'];
      }
    }
    if (youtubeUrl != null && youtubeUrl.contains('youtube.com')) {
      return WidgetSpan(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (context.element?.text.trim().isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  context.element!.text.trim(),
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                  ),
                ),
              ),
            SizedBox(
              height: 200,
              child: WebViewContainer(
                key: UniqueKey(),
                youtubeUrl: youtubeUrl,
              ),
            ),
          ],
        ),
      );
    }

    // Handle images
    String? src;
    double? customWidthPercentage;
    if (tag == 'img') {
      if (context.element?.parent?.localName == 'figure') {
        return const TextSpan();
      }
      src = context.element?.attributes['src'];
    } else if (tag == 'figure') {
      final styleAttr = context.element?.attributes['style'];
      if (styleAttr != null) {
        final widthMatch = RegExp(r'width:\s*([\d.]+)%').firstMatch(styleAttr);
        if (widthMatch != null && widthMatch.groupCount >= 1) {
          customWidthPercentage = double.tryParse(widthMatch.group(1)!);
        }
      }
      final dom.Element? imgElement = context.element?.querySelector('img');
      src = imgElement?.attributes['src'];
    } else if (tag == 'ol') {
      final figureElement = context.element?.querySelector('figure');
      if (figureElement != null) {
      }
    }

    if (src != null && src.isNotEmpty) {
      if (!src.startsWith('http')) {
        src = 'https://django-noxeas.chbk.app$src';
      }
      final imageSpan = WidgetSpan(
        child: Builder(
          builder: (BuildContext buildContext) {
            final imageWidth = customWidthPercentage != null
                ? MediaQuery.of(buildContext).size.width * customWidthPercentage / 100
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
                    return Text('Failed to[%s load image: $src');
                  },
                ),
              ),
            );
          },
        ),
      );

      if (tag == 'figure') {
        return TextSpan(
          children: [
            const TextSpan(text: '\n'),
            imageSpan,
            const TextSpan(text: '\n'),
          ],
        );
      }
      return imageSpan;
    }

    if (tag == 'ol' || tag == 'ul') {
      return WidgetSpan(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _buildList(context, themeController, isOrdered: tag == 'ol'),
          ),
        ),
      );
    }
    if (tag == 'li') {
      final parent = context.element?.parent;
      final isOrdered = parent?.localName == 'ol';
      final index = _getListItemIndex(context.element);

      return WidgetSpan(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                Text(
                  isOrdered ? "$index." : "• ",
                  style: TextStyle(
                    color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    text: TextSpan(
                      children: _buildSpans(context, themeController),
                      style: TextStyle(
                        fontSize: context.style?.fontSize?.value,
                        color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Default text styling
    return WidgetSpan(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: RichText(
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          text: TextSpan(
            children: _buildSpans(context, themeController),
            style: TextStyle(
              fontSize: context.style?.fontSize?.value,
              fontWeight: context.style?.fontWeight,
              color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  int _getListItemIndex(dom.Element? element) {
    if (element == null) return 0;
    final parent = element.parent;
    if (parent == null) return 0;

    return parent.children
        .where((child) => child.localName == 'li')
        .toList()
        .indexOf(element) +
        1;
  }

  List<InlineSpan> _buildSpans(ExtensionContext context, ThemeController themeController) {
    return context.element?.nodes.map((node) {
      if (node is dom.Text) {
        return TextSpan(
          text: node.text,
          style: TextStyle(
            fontWeight: context.style?.fontWeight,
            fontStyle: context.style?.fontStyle,
            decoration: context.style?.textDecoration,
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
        );
      }
      if (node is dom.Element) {
        if (node.localName == 'strong' || node.localName == 'b') {
          return TextSpan(
            text: node.text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: context.style?.fontStyle,
              decoration: context.style?.textDecoration,
              color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            ),
          );
        }
        if (node.localName == 'div' || node.localName == 'iframe' || node.localName == 'figure' || node.localName == 'media') {
          return WidgetSpan(
            child: Html(
              data: node.outerHtml,
              extensions: [this],
              style: {
                "li": Style(display: Display.listItem),
                "p": Style(),
              },
            ),
          );
        }
        return TextSpan(
          text: node.text,
          style: TextStyle(
            fontWeight: context.style?.fontWeight,
            fontStyle: context.style?.fontStyle,
            decoration: context.style?.textDecoration,
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          ),
        );
      }
      return const TextSpan(text: '');
    }).toList() ?? [];
  }

  Widget _buildList(ExtensionContext context, ThemeController themeController, {required bool isOrdered}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      textDirection: TextDirection.rtl,
      children: context.element?.children.map((child) {
        return Html(
          data: child.outerHtml,
          extensions: [this],
          style: {
            "li": Style(display: Display.listItem),
            "p": Style(),
          },
        );
      }).toList() ?? [],
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

class WebViewContainer extends StatefulWidget {
  final String youtubeUrl;
  const WebViewContainer({Key? key, required this.youtubeUrl}) : super(key: key);

  @override
  _WebViewContainerState createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  late WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) => setState(() => isLoading = true),
          onPageFinished: (String url) => setState(() => isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.youtubeUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:treenode/controllers/utills/ThemeController.dart';

class Pextention extends HtmlExtension {
  @override
  Set<String> get supportedTags => {'p'};

  @override
  InlineSpan build(ExtensionContext context) {
    final themeController = Get.find<ThemeController>();
    String? text = context.element?.text?.trim();

    if (text == null || text.isEmpty) {
      return const TextSpan(text: "");
    }

    final RegExp regex = RegExp(r'https?:\/\/www\.aparat\.com\/v\/(\w+)');
    final Iterable<RegExpMatch> matches = regex.allMatches(text);

    if (matches.isEmpty) {
      return TextSpan(
        text: text,
        style: TextStyle(
          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          fontFamily: 'Vazir',
        ),
      );
    }

    List<InlineSpan> spans = [];
    int lastIndex = 0;

    for (RegExpMatch match in matches) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: TextStyle(
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            fontFamily: 'Vazir',
          ),
        ));
      }

      String videoId = match.group(1)!;
      String embedUrl =
          "https://www.aparat.com/video/video/embed/videohash/$videoId/vt/frame";

      spans.add(WidgetSpan(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setBackgroundColor(themeController.isDarkTheme.value
                    ? Colors.black
                    : Colors.white)
                ..loadRequest(Uri.parse(embedUrl)),
            ),
          ),
        ),
      ));

      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: TextStyle(
          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          fontFamily: 'Vazir',
        ),
      ));
    }

    return TextSpan(children: spans);
  }
}

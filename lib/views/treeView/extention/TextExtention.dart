import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

class TextExtension extends HtmlExtension {
  @override
  Set<String> get supportedTags => {'p', 'span', 'div', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'};

  @override
  InlineSpan build(ExtensionContext context) {
    final text = context.element?.text ?? '';
    final isRtl = _hasAnyRtl(text);

    final enforcedText = Bidi.enforceRtlInText(text);

    return TextSpan(
      text: enforcedText,
      style: TextStyle(
        color: context.style?.color,
        fontWeight: context.style?.fontWeight,
        fontStyle: context.style?.fontStyle,
        decoration: context.style?.textDecoration,
        decorationColor: context.style?.textDecorationColor,
        decorationStyle: context.style?.textDecorationStyle,
        decorationThickness: context.style?.textDecorationThickness,
        letterSpacing: context.style?.letterSpacing,
        wordSpacing: context.style?.wordSpacing,
        locale: isRtl ? Locale('fa') : null,
      ),
    );
  }

  bool _hasAnyRtl(String text) {

    return text.contains(RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]'));
  }
}

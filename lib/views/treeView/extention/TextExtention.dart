import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class TextExtension extends HtmlExtension {
  @override
  Set<String> get supportedTags => {'p', 'span', 'div', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'};

  @override
  InlineSpan build(ExtensionContext context) {

    final text = context.element?.text ?? '';

    return WidgetSpan(
      child: Align(
        alignment:Alignment.topRight,
        child: Directionality(
          textDirection:TextDirection.rtl,
          child: Text(
            text,
            style: TextStyle(
              color: context.style?.color,
              fontWeight: context.style?.fontWeight,
              fontStyle: context.style?.fontStyle,
              fontFamily: 'Vazir',
              decorationColor: context.style?.textDecorationColor,
              decorationStyle: context.style?.textDecorationStyle,
              decorationThickness: context.style?.textDecorationThickness,
              letterSpacing: context.style?.letterSpacing,
              wordSpacing: context.style?.wordSpacing,
            ),
            textAlign:TextAlign.right,
          ),
        ),
      ),
    );
  }
}

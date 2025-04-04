import 'dart:ui';
import 'package:flutter/material.dart';

class BlurredButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final double height;
  final double fontSize;

  const BlurredButton({
    required this.onPressed,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.width,
    required this.height,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 450));
                    onPressed();
                  },
                  splashColor: Colors.black.withOpacity(0.2),
                  highlightColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: Center(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: textColor,
                          fontFamily: 'Vazir',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
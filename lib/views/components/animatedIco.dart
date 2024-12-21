import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TadaLogo extends StatefulWidget {
  final double width;
  final double height;
  final String path;

  final IconData? icon;
  final Color? Iconcolor;

  final Duration subtleShrinkDuration;
  final Duration subtleExpandDuration;
  final Duration pauseDuration;
  final Duration pauseBetweenCycle;
  final Duration shakeDuration;

  final int shakeCycles;

  final double smallerScale;
  final double biggerScale;
  final double shakeAngle;
  final double initialShrinkTilt;
  final double liftDuringShrink;

  const TadaLogo({
    Key? key,
    required this.width,
    required this.height,
    this.path = "",
    this.icon,
    this.Iconcolor,
    this.subtleShrinkDuration = const Duration(milliseconds: 50),
    this.subtleExpandDuration = const Duration(milliseconds: 50),
    this.pauseDuration = const Duration(milliseconds: 300),
    this.pauseBetweenCycle = const Duration(milliseconds: 500),
    this.shakeCycles = 3,
    this.shakeDuration = const Duration(milliseconds: 300),
    this.smallerScale = 0.9,
    this.biggerScale = 1.3,
    this.shakeAngle = 0.1,
    this.initialShrinkTilt = 0.05,
    this.liftDuringShrink = 15.0,
  }) : super(key: key);

  @override
  _TadaLogoState createState() => _TadaLogoState();
}

class _TadaLogoState extends State<TadaLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _rotationAnimation;

  bool _isPaused = false;

  @override
  void initState() {
    super.initState();

    final shakeTotalDuration = widget.shakeDuration * widget.shakeCycles;
    final totalDuration = widget.subtleShrinkDuration +
        widget.subtleExpandDuration +
        shakeTotalDuration +
        widget.pauseDuration;

    _controller = AnimationController(
      vsync: this,
      duration: totalDuration,
    );

    // Scale animate: Subtle Shrink → Subtle Expand → Shake → Return → Pause
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: widget.smallerScale)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 2),
      TweenSequenceItem(
          tween: Tween(begin: widget.smallerScale, end: widget.biggerScale)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 2),
      TweenSequenceItem(tween: ConstantTween(widget.biggerScale), weight: 20),
      TweenSequenceItem(
          tween: Tween(begin: widget.biggerScale, end: 1.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 10),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 10),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: -widget.initialShrinkTilt)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 2),
      TweenSequenceItem(
          tween: Tween(begin: -widget.initialShrinkTilt, end: 0.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 2),
      ..._buildShakeSequence(),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 10),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed && !_isPaused) {
        if (mounted) {
          _isPaused = true;
          await Future.delayed(widget.pauseBetweenCycle);
          if (mounted) {
            _isPaused = false;
            _controller.reset();
            _controller.forward();
          }
        }
      }
    });

    if (mounted) {
      _controller.forward();
    }
  }

  List<TweenSequenceItem<double>> _buildShakeSequence() {
    final List<TweenSequenceItem<double>> shakes = [];
    for (int i = 0; i < widget.shakeCycles; i++) {
      shakes.add(TweenSequenceItem(
          tween: Tween(begin: 0.0, end: -widget.shakeAngle)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 5));
      shakes.add(TweenSequenceItem(
          tween: Tween(begin: -widget.shakeAngle, end: widget.shakeAngle)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 5));
    }
    shakes.add(TweenSequenceItem(tween: ConstantTween(0.0), weight: 5));
    return shakes;
  }

  @override
  void dispose() {
    if (mounted) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: child,
          ),
        );
      },
      child: _buildImage(),
    );
  }

  bool _isBase64(String string) {
    final base64Pattern = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
    if (!base64Pattern.hasMatch(string) || string.length % 4 != 0) {
      return false;
    }

    try {
      base64Decode(string);
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _buildImage() {
    if (widget.path.startsWith('http') || widget.path.startsWith('https')) {
      return Image.network(
        widget.path,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.cover,
      );
    } else if (widget.icon != null) {
      return Icon(
        widget.icon,
        color: widget.Iconcolor,
        size: widget.width,
      );
    } else if (_isBase64(widget.path)) {
      final bytes = base64Decode(widget.path);
      return Image.memory(
        Uint8List.fromList(bytes),
        width: widget.width,
        height: widget.height,
        fit: BoxFit.cover,
      );
    } else if (File(widget.path).existsSync()) {
      return Image.file(
        File(widget.path),
        width: widget.width,
        height: widget.height,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        widget.path,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.cover,
      );
    }
  }
}

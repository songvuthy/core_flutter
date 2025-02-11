import 'package:core_flutter/app/constants/app_decoration.dart';
import 'package:core_flutter/app/theme/app_colors.dart';
import 'package:core_flutter/app/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomToast {
  static void showToast(
    BuildContext context,
    String message, {
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    final overlayState = Navigator.of(context).overlay!;
    final overlayEntry = OverlayEntry(
      builder: (context) => _ToastOverlay(
        message: message,
        gravity: gravity,
      ),
    );

    overlayState.insert(overlayEntry);

    // Total duration for the toast to be visible including fade in and fade out
    const displayDuration = Duration(milliseconds: 2500);
    const fadeDuration = Duration(milliseconds: 400);

    Future.delayed(displayDuration + fadeDuration * 2, () {
      overlayEntry.remove();
    });
  }
}

class _ToastOverlay extends StatefulWidget {
  final String message;
  final ToastGravity gravity;

  const _ToastOverlay({required this.message, required this.gravity});

  @override
  _ToastOverlayState createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2500), () {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true, // Allow touch events to pass through
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _controller.value,
                  child: child,
                );
              },
              child: Align(
                alignment: _getAlignment(widget.gravity),
                child: IntrinsicHeight(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppDecoration.defaultRadius),
                      color: Colors.black.withOpacity(0.7),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    margin: const EdgeInsets.all(AppDecoration.defaultSpacing),
                    child: Text(
                      widget.message,
                      style:
                          AppTextStyle.body4.copyWith(color: AppColors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Alignment _getAlignment(ToastGravity gravity) {
    switch (gravity) {
      case ToastGravity.TOP:
        return Alignment.topCenter;
      case ToastGravity.CENTER:
        return Alignment.center;
      case ToastGravity.BOTTOM:
        return Alignment.bottomCenter;
    }
  }
}

enum ToastGravity {
  CENTER,
  BOTTOM,
  TOP,
}

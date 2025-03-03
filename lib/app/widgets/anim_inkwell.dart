import 'package:flutter/material.dart';

class AnimInkWell extends StatefulWidget {
  final Duration duration;
  final double scaleFactor;
  final VoidCallback onTap;
  final Widget child;

  const AnimInkWell({
    super.key,
    this.duration = const Duration(milliseconds: 100),
    this.scaleFactor = 0.95,
    required this.onTap,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimInkWellState();
  }
}

class _AnimInkWellState extends State<AnimInkWell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    Future.delayed(widget.duration, () {
      _controller.reverse().then((_) {
        widget.onTap();
      });
    });
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimListItem extends StatefulWidget {
  final Function()? onRemove;
  final Widget Function(AnimListItemState) child;

  const AnimListItem({super.key, required this.onRemove, required this.child});

  @override
  State<StatefulWidget> createState() => AnimListItemState();
}

class AnimListItemState extends State<AnimListItem>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  bool _isRemoved = false;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeOut);
    _controller?.forward(from: 1.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    _animation = null;
    super.dispose();
  }

  void remove() {
    _controller?.reverse().then((_) {
      setState(() {
        _isRemoved = true;
      });
      widget.onRemove?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isRemoved == true) {
      return const SizedBox();
    }
    if (_animation == null) {
      return const SizedBox();
    }
    return FadeTransition(
      opacity: _animation!,
      child: CustomSizeTransition(
        sizeFactor: _animation!,
        child: widget.child(this),
      ),
    );
  }
}

class CustomSizeTransition extends AnimatedWidget {
  /// Creates a size transition.
  ///
  /// The [axis], [sizeFactor], and [axisAlignment] arguments must not be null.
  /// The [axis] argument defaults to [Axis.vertical]. The [axisAlignment]
  /// defaults to 0.0, which centers the child along the main axis during the
  /// transition.
  const CustomSizeTransition({
    super.key,
    this.axis = Axis.vertical,
    required Animation<double> sizeFactor,
    this.axisAlignment = 0.0,
    this.child,
  }) : super(listenable: sizeFactor);

  /// [Axis.horizontal] if [sizeFactor] modifies the width, otherwise
  /// [Axis.vertical].
  final Axis axis;

  /// The animation that controls the (clipped) size of the child.
  ///
  /// The width or height (depending on the [axis] value) of this widget will be
  /// its intrinsic width or height multiplied by [sizeFactor]'s value at the
  /// current point in the animation.
  ///
  /// If the value of [sizeFactor] is less than one, the child will be clipped
  /// in the appropriate axis.
  Animation<double> get sizeFactor => listenable as Animation<double>;

  /// Describes how to align the child along the axis that [sizeFactor] is
  /// modifying.
  ///
  /// A value of -1.0 indicates the top when [axis] is [Axis.vertical], and the
  /// start when [axis] is [Axis.horizontal]. The start is on the left when the
  /// text direction in effect is [TextDirection.ltr] and on the right when it
  /// is [TextDirection.rtl].
  ///
  /// A value of 1.0 indicates the bottom or end, depending upon the [axis].
  ///
  /// A value of 0.0 (the default) indicates the center for either [axis] value.
  final double axisAlignment;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final AlignmentDirectional alignment;
    if (axis == Axis.vertical) {
      alignment = AlignmentDirectional(-1.0, axisAlignment);
    } else {
      alignment = AlignmentDirectional(axisAlignment, -1.0);
    }
    return ClipRect(
      clipBehavior: Clip.none,
      child: Align(
        alignment: alignment,
        heightFactor:
            axis == Axis.vertical ? math.max(sizeFactor.value, 0.0) : null,
        widthFactor:
            axis == Axis.horizontal ? math.max(sizeFactor.value, 0.0) : null,
        child: child,
      ),
    );
  }
}

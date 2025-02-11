import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class AppAnimSwitcher extends StatelessWidget {
  final Widget? child;

  const AppAnimSwitcher({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeThroughTransition(
          fillColor: Colors.transparent,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: child,
    );
  }
}

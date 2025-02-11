import 'package:core_flutter/app/constants/app_decoration.dart';
import 'package:flutter/material.dart';

class SpaceVertical extends StatelessWidget {
  const SpaceVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      color: Colors.transparent,
      height: AppDecoration.defaultSpacing,
    );
  }
}

import 'package:core_flutter/app/constants/app_decoration.dart';
import 'package:flutter/material.dart';

class SpaceHorizontal extends StatelessWidget {
  const SpaceHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: AppDecoration.defaultSpacing,
    );
  }
}

import 'package:core_flutter/app/constants/app_decoration.dart';
import 'package:flutter/material.dart';

class SliverSpacingHorizontal extends StatelessWidget {
  const SliverSpacingHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: SizedBox(
        width: AppDecoration.defaultSpacing,
      ),
    );
  }
}

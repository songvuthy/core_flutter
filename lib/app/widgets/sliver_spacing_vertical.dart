import 'package:core_flutter/app/constants/app_decoration.dart';
import 'package:flutter/material.dart';

class SliverSpacingVertical extends StatelessWidget {
  const SliverSpacingVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: SizedBox(
        height: AppDecoration.defaultSpacing,
      ),
    );
  }
}

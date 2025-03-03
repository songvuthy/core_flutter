import 'package:core_flutter/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppBoxShadow {
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: AppColors.shadow.withAlpha(15),
      spreadRadius: 3,
      blurRadius: 10,
      offset: Offset(4, 4),
    ),
    BoxShadow(
      color: AppColors.white.withAlpha(70),
      spreadRadius: -3,
      blurRadius: 10,
      offset: Offset(-4, -4),
    ),
  ];

  static List<BoxShadow> darkShadow = [
    BoxShadow(
      color: AppColors.shadow.withAlpha(30),
      spreadRadius: 3,
      blurRadius: 10,
      offset: Offset(4, 4),
    ),
    BoxShadow(
      color: AppColors.white.withAlpha(70),
      spreadRadius: -3,
      blurRadius: 10,
      offset: Offset(-4, -4),
    ),
  ];

  static List<BoxShadow> glowShadow(Color color) {
    return [
      BoxShadow(
        color: color.withAlpha(50),
        spreadRadius: 5,
        blurRadius: 20,
        offset: Offset(0, 0),
      ),
    ];
  }
}

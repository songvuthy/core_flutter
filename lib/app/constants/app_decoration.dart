import 'package:get/get.dart';

class AppDecoration {
  // Radius
  static const double defaultRadius = 8.0;
  static const double smallRadius = 6.0;
  static const double defaultBigRadius = 30.0;
  // Spacing
  static const double defaultSpacing = 12.0;
  static const double smallSpacing = 5.0;
  static const double mediumSpacing = 10.0;
  static const double bigSpacing = 15.0;

  // App Bar
  static const double appBarIconSize = 24;
  static const double appBarIconSpaceBetween = 8;

  static bool isTablet = Get.context!.isTablet;
}

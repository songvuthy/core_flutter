import 'package:core_flutter/app/constants/app_decoration.dart';
import 'package:core_flutter/app/theme/app_colors.dart';
import 'package:core_flutter/app/widgets/app_icon_button_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? onPressed;
  final Widget? leadAction;
  final bool isShowBack;
  final bool centerTitle;
  final Widget title;
  final double? titleSpacing;
  final List<Widget>? actions;
  final double height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final double? elevation;

  const CustomAppBar({
    super.key,
    this.onPressed,
    this.leadAction,
    this.isShowBack = true,
    this.centerTitle = true,
    required this.title,
    this.titleSpacing,
    this.actions,
    this.height = kToolbarHeight,
    this.backgroundColor = AppColors.white,
    this.foregroundColor = AppColors.black,
    this.systemOverlayStyle = const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light, // For iOS: (light icons)
      statusBarIconBrightness: Brightness.dark, // For Android: (dark icons)
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.background,
    ),
    this.elevation = 0.5,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  List<Widget>? _getAndAddSpacingToActions() {
    return actions
        ?.map(
          (e) => Padding(
            padding: const EdgeInsets.only(
                right: AppDecoration.appBarIconSpaceBetween),
            child: e,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: titleSpacing,
      leading: isShowBack
          ? Container(
              padding: const EdgeInsets.only(
                  left: AppDecoration.appBarIconSpaceBetween),
              child: AppIconButtonAppBar(
                onPressed: () {
                  if (onPressed != null) {
                    onPressed!.call();
                    return;
                  }
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: AppDecoration.appBarIconSize,
                ),
              ),
            )
          : leadAction,
      leadingWidth: 48,
      elevation: elevation,
      shadowColor: elevation != null ? AppColors.shadow : null,
      surfaceTintColor: backgroundColor,
      systemOverlayStyle: systemOverlayStyle,
      title: title,
      actions: _getAndAddSpacingToActions(),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }
}

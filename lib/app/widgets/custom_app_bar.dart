import 'package:core_flutter/app/constants/app_decoration.dart';
import 'package:core_flutter/app/theme/app_colors.dart';
import 'package:core_flutter/app/widgets/app_icon_button_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function()? onPressed;
  final bool isShowBack;
  final bool centerTitle;
  final bool autoElevation;
  final Widget title;
  final double? titleSpacing;
  final List<Widget>? actions;
  final double height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;

  const CustomAppBar({
    super.key,
    this.onPressed,
    this.isShowBack = true,
    this.centerTitle = true,
    this.autoElevation = true,
    required this.title,
    this.titleSpacing,
    this.actions,
    this.height = kToolbarHeight,
    this.backgroundColor = AppColors.background,
    this.foregroundColor = AppColors.primaryNormal,
    this.systemOverlayStyle = const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light, // For iOS: (light icons)
      statusBarIconBrightness: Brightness.dark, // For Android: (dark icons)
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.background,
    ),
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  State<StatefulWidget> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  var isBelowAppBar = false;

  bool scrollStatus(bool isBelowAppBar) {
    if (!widget.autoElevation) {
      return false;
    }
    if (this.isBelowAppBar != isBelowAppBar) {
      setState(() {
        this.isBelowAppBar = isBelowAppBar;
      });
      return true;
    }
    return false;
  }

  List<Widget>? _getAndAddSpacingToActions() {
    return widget.actions
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
      titleSpacing: widget.titleSpacing,
      leading: widget.isShowBack
          ? Container(
              padding: const EdgeInsets.only(
                  left: AppDecoration.appBarIconSpaceBetween),
              child: AppIconButtonAppBar(
                onPressed: () {
                  if (widget.onPressed != null) {
                    widget.onPressed!.call();
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
          : null,
      leadingWidth: 48,
      shadowColor: isBelowAppBar ? AppColors.shadow : null,
      systemOverlayStyle: widget.systemOverlayStyle,
      title: widget.title,
      actions: _getAndAddSpacingToActions(),
      notificationPredicate: (notification) =>
          scrollStatus(notification.metrics.pixels > 0),
      centerTitle: widget.centerTitle,
      backgroundColor: isBelowAppBar ? Colors.white : widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
    );
  }
}

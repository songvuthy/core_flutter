import 'package:core_flutter/app/constants/app_decoration.dart';
import 'package:core_flutter/app/theme/app_colors.dart';
import 'package:core_flutter/app/widgets/app_icon_button_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomSliverAppBar extends StatelessWidget {
  final Function()? onPressed;
  final Widget? leadAction;
  final bool isShowBack;
  final bool centerTitle;
  final Widget title;
  final double? titleSpacing;
  final List<Widget>? actions;
  final double height;
  final double? expandedHeight;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool pinned;
  final double? elevation;
  final Widget? flexibleSpace;
  const CustomSliverAppBar({
    super.key,
    this.onPressed,
    this.leadAction,
    this.isShowBack = true,
    this.centerTitle = true,
    required this.title,
    this.titleSpacing,
    this.actions,
    this.height = kToolbarHeight,
    this.expandedHeight,
    this.backgroundColor = Colors.transparent,
    this.foregroundColor = AppColors.primaryNormal,
    this.systemOverlayStyle = const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light, // For iOS: (light icons)
      statusBarIconBrightness: Brightness.dark, // For Android: (dark icons)
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.background,
    ),
    this.pinned = false,
    this.elevation,
    this.flexibleSpace,
  });

  List<Widget>? _getAndAddSpacingToActions() {
    var newList = actions
        ?.map(
          (e) => Padding(
            padding: const EdgeInsets.only(
              right: AppDecoration.appBarIconSpaceBetween,
            ),
            child: e,
          ),
        )
        .toList();
    return newList;
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      titleSpacing: titleSpacing,
      leading: isShowBack
          ? Container(
              padding: const EdgeInsets.only(
                left: AppDecoration.appBarIconSpaceBetween,
              ),
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
      elevation: elevation,
      shadowColor: elevation != null ? AppColors.shadow : null,
      leadingWidth: isShowBack ? 48 : 75,
      toolbarHeight: height,
      systemOverlayStyle: systemOverlayStyle,
      title: title,
      actions: _getAndAddSpacingToActions(),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      pinned: pinned,
      flexibleSpace: flexibleSpace,
      expandedHeight: expandedHeight,
    );
  }
}

import 'package:core_flutter/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppIconButtonAppBar extends StatelessWidget {
  final Function() onPressed;
  final Widget icon;
  final Color? backgroundColor;
  final Color? forcegroundColor;
  final bool isEnabled;
  const AppIconButtonAppBar({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor = AppColors.white,
    this.forcegroundColor = AppColors.primaryNormal,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(
          side: BorderSide(
            color: AppColors.primaryLight,
          ),
        ),
        iconColor: Colors.red,
        disabledIconColor: Colors.grey,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: Colors.grey,
        minimumSize: const Size(40, 40),
        maximumSize: const Size(40, 40),
      ),
      child: ColorFiltered(
        colorFilter: isEnabled
            ? const ColorFilter.mode(Colors.transparent, BlendMode.saturation)
            : const ColorFilter.mode(
                Colors.grey,
                BlendMode.srcIn,
              ),
        child: icon,
      ),
    );
  }
}

import 'package:core_flutter/app/constants/app_decoration.dart';
import 'package:core_flutter/app/theme/app_colors.dart';
import 'package:core_flutter/app/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppOutlinedButton extends StatelessWidget {
  final String? iconPath;
  final Widget? icon;
  final String? text;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final BorderSide? side;
  final Color? backgroundColor;
  final TextStyle? style;
  final Function() onPressed;

  const AppOutlinedButton({
    super.key,
    this.iconPath,
    this.text,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius,
    required this.onPressed,
    this.side,
    this.backgroundColor,
    this.style,
    this.icon,
  });

  Future<void> logEvent() async {
    // await FirebaseAnalytics.instance.logEvent(
    //   name: "select_content",
    //   parameters: {
    //     "content_type": "button",
    //     "title": text ?? "",
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryNormal,
      backgroundColor: backgroundColor,
      padding: padding ??
          const EdgeInsets.symmetric(
            vertical: AppDecoration.bigSpacing,
            horizontal: AppDecoration.defaultSpacing,
          ),
      side: side ?? const BorderSide(color: AppColors.body, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ??
            BorderRadius.circular(
              AppDecoration.defaultRadius,
            ),
      ),
    );

    final textWidget = text != null
        ? Text(
            text!,
            maxLines: 1,
            style: style ??
                AppTextStyle.body3.copyWith(color: AppColors.primaryNormal),
          )
        : const SizedBox.shrink();
    Widget button;
    if (iconPath == null && icon == null) {
      button = OutlinedButton(
        onPressed: () {
          onPressed.call();
          logEvent();
        },
        style: buttonStyle,
        child: textWidget,
      );
    } else {
      button = OutlinedButton.icon(
        icon: icon ??
            SvgPicture.asset(
              iconPath!,
              width: 20,
              height: 20,
            ),
        label: textWidget,
        onPressed: () {
          onPressed.call();
          logEvent();
        },
        style: buttonStyle,
      );
    }

    return (width != null || height != null)
        ? Container(
            margin: margin,
            width: width,
            height: height,
            child: button,
          )
        : button;
  }
}

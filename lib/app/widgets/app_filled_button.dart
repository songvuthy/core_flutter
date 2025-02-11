import 'package:core_flutter/app/constants/app_decoration.dart';
import 'package:core_flutter/app/theme/app_colors.dart';
import 'package:core_flutter/app/theme/app_text_style.dart';
import 'package:core_flutter/app/widgets/app_marquee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppFilledButton extends StatelessWidget {
  final String? iconPath;
  final String? text;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final TextStyle? textStyle;
  final Color textColor;
  final Color iconColor;
  final Color color;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final double? elevation;
  final Function() onPressed;
  final bool isEnabled;
  final Size? minimumSize;
  final Size? fixedSize;
  final Size? maximumSize;

  const AppFilledButton({
    super.key,
    this.iconPath,
    this.text,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.color = AppColors.primaryNormal,
    this.foregroundColor = Colors.white,
    this.disabledBackgroundColor,
    this.elevation,
    required this.onPressed,
    this.isEnabled = true, // Default value is true
    this.borderRadius,
    this.textStyle,
    this.minimumSize,
    this.fixedSize,
    this.maximumSize,
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
    final style = ElevatedButton.styleFrom(
      elevation: elevation,
      surfaceTintColor: color,
      foregroundColor: foregroundColor,
      backgroundColor: color,
      disabledBackgroundColor: disabledBackgroundColor,
      minimumSize: minimumSize,
      fixedSize: fixedSize,
      maximumSize: maximumSize,
      padding: padding ??
          const EdgeInsets.symmetric(
            vertical: AppDecoration.bigSpacing,
            horizontal: AppDecoration.defaultSpacing,
          ),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ??
            BorderRadius.circular(AppDecoration.defaultBigRadius),
      ),
    );
    final textWidget = text != null
        ? AppMarquee(
            child: Text(
              text!,
              maxLines: 1,
              style: textStyle ?? AppTextStyle.body3.copyWith(color: textColor),
            ),
          )
        : const SizedBox.shrink();
    Widget button;
    if (iconPath == null) {
      button = ElevatedButton(
          onPressed: isEnabled == false
              ? null
              : () async {
                  onPressed.call();
                  logEvent();
                },
          style: style,
          child: textWidget);
    } else {
      button = ElevatedButton.icon(
        icon: SvgPicture.asset(
          iconPath!,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        label: textWidget,

        onPressed: isEnabled == false
            ? null
            : () async {
                onPressed.call();
                logEvent();
              }, // Disable onPressed if isDisabled is true
        style: style,
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

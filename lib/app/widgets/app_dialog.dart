import 'dart:ui';
import 'package:core_flutter/app/constants/app_decoration.dart';
import 'package:core_flutter/app/theme/app_colors.dart';
import 'package:core_flutter/app/theme/app_text_style.dart';
import 'package:core_flutter/app/widgets/app_filled_button.dart';
import 'package:core_flutter/app/widgets/app_outlined_button.dart';
import 'package:core_flutter/app/widgets/space_horizontal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog {
  static Future<void> show({
    required String? title,
    required String? message,
    String? titlePositive,
    String? titleNegative,
    Function()? positiveCallback,
    Function()? negativeCallback,
    bool isAutoBack = true,
  }) async {
    await Get.dialog(AppDialogWidget(
      title: title,
      content: message != null
          ? Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyle.body6,
            )
          : null,
      titleNegative: titleNegative,
      titlePositive: titlePositive,
      negativeCallback: negativeCallback,
      positiveCallback: positiveCallback,
      isAutoBack: isAutoBack,
    ));
  }

  static Future<void> showContent({
    required String? title,
    required Widget content,
    required String? titlePositive,
    required String? titleNegative,
    Function()? positiveCallback,
    Function()? negativeCallback,
    bool isAutoBack = true,
  }) async {
    await Get.dialog(
      AppDialogWidget(
        title: title,
        content: content,
        titleNegative: titleNegative,
        titlePositive: titlePositive,
        negativeCallback: negativeCallback,
        positiveCallback: positiveCallback,
        isAutoBack: isAutoBack,
      ),
    );
  }
}

class AppDialogWidget extends StatelessWidget {
  final String? title;
  final Widget? content;
  final String? titleNegative;
  final String? titlePositive;
  final Function()? negativeCallback;
  final Function()? positiveCallback;
  final bool isAutoBack;
  const AppDialogWidget({
    super.key,
    this.title,
    this.content,
    this.titleNegative,
    this.titlePositive,
    this.negativeCallback,
    this.positiveCallback,
    this.isAutoBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withAlpha(0),
            ), // Semi-transparent effect
          ),
          // Dialog Box
          Center(
            child: Container(
              constraints:
                  const BoxConstraints(minWidth: 250.0, maxWidth: 300.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.circular(AppDecoration.defaultRadius),
              ),
              padding: const EdgeInsets.all(AppDecoration.bigSpacing),
              child: Wrap(
                runSpacing: AppDecoration.mediumSpacing,
                children: [
                  if (title != null)
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        title!,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.subtitle1,
                      ),
                    ),
                  if (content != null)
                    SizedBox(
                      width: double.infinity,
                      child: content!,
                    ),
                  if (titleNegative != null && titlePositive != null)
                    Row(
                      children: [
                        Flexible(
                          child: AppOutlinedButton(
                            width: double.infinity,
                            height: 41,
                            padding: EdgeInsets.zero,
                            borderRadius: BorderRadius.circular(8),
                            onPressed: () {
                              if (isAutoBack) {
                                Get.back();
                              }
                              negativeCallback?.call();
                            },
                            text: titleNegative,
                          ),
                        ),
                        const SpaceHorizontal(),
                        Flexible(
                          child: AppFilledButton(
                            width: double.infinity,
                            height: 41,
                            padding: EdgeInsets.zero,
                            borderRadius: BorderRadius.circular(8),
                            onPressed: () {
                              if (isAutoBack) {
                                Get.back();
                              }
                              positiveCallback?.call();
                            },
                            text: titlePositive,
                          ),
                        ),
                      ],
                    )
                  else if (titleNegative != null)
                    AppOutlinedButton(
                      width: double.infinity,
                      height: 41,
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(8),
                      onPressed: () {
                        if (isAutoBack) {
                          Get.back();
                        }
                        negativeCallback?.call();
                      },
                      text: titleNegative,
                    )
                  else if (titlePositive != null)
                    AppFilledButton(
                      width: double.infinity,
                      height: 41,
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(8),
                      onPressed: () {
                        if (isAutoBack) {
                          Get.back();
                        }
                        positiveCallback?.call();
                      },
                      text: titlePositive,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

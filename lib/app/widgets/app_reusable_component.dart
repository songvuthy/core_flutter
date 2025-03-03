import 'package:core_flutter/app/constants/app_decoration.dart';
import 'package:core_flutter/app/theme/app_colors.dart';
import 'package:core_flutter/app/widgets/app_custom_toast.dart';
import 'package:core_flutter/app/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin AppReusableComponent {
  void showLoading() {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.dialog(
      Scaffold(
        backgroundColor: Colors.transparent,
        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (val, result) => Future.value(false),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius:
                    BorderRadius.circular(AppDecoration.defaultRadius),
              ),
              child: Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.all(AppDecoration.defaultSpacing),
                child: const CircularProgressIndicator.adaptive(
                  strokeCap: StrokeCap.round,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primaryNormal),
                ),
              ),
            ),
          ),
        ),
      ),
      name: "dialog_loading",
      barrierDismissible: false,
    );
  }

  void hideLoading() {
    Get.back();
  }

  Future<void> showCustomDialog({
    required String? title,
    required String? message,
    required String? titlePositive,
    required String? titleNegative,
    Function()? positiveCallback,
    Function()? negativeCallback,
    bool isAutoBack = true,
  }) async {
    await AppDialog.show(
      title: title,
      message: message,
      titlePositive: titlePositive,
      titleNegative: titleNegative,
      positiveCallback: positiveCallback,
      negativeCallback: negativeCallback,
      isAutoBack: isAutoBack,
    );
  }

  Future<void> showCustomDialogInfo({
    required String title,
    required String message,
    Function()? positiveCallback,
    bool isAutoBack = true,
  }) async {
    await AppDialog.show(
      title: title,
      message: message,
      titlePositive: "Okay",
      titleNegative: null,
      positiveCallback: positiveCallback,
      negativeCallback: null,
      isAutoBack: isAutoBack,
    );
  }

  Future<void> showCustomDialogContent({
    required String? title,
    required Widget content,
    required String? titlePositive,
    required String? titleNegative,
    Function()? positiveCallback,
    Function()? negativeCallback,
    bool isAutoBack = true,
  }) async {
    await AppDialog.showContent(
      title: title,
      content: content,
      titlePositive: titlePositive,
      titleNegative: titleNegative,
      positiveCallback: positiveCallback,
      negativeCallback: negativeCallback,
      isAutoBack: isAutoBack,
    );
  }

  void showToast(String message, {ToastGravity gravity = ToastGravity.BOTTOM}) {
    CustomToast.showToast(Get.context!, message, gravity: gravity);
  }
}

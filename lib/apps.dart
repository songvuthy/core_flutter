import 'package:core_flutter/app/routes/app_pages.dart';
import 'package:core_flutter/app/theme/app_colors.dart';
import 'package:core_flutter/app/translations/translation_service.dart';
import 'package:core_flutter/env/app_config.dart';
import 'package:core_flutter/env/device_info.dart';
import 'package:core_flutter/env/main_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

late AppConfig instanceAppConfig;
late DeviceInfo instanceDeviceInfo;
String? accessToken;

class Apps extends StatelessWidget {
  const Apps({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primaryNormal,
        scaffoldBackgroundColor: AppColors.background,
        dialogTheme: DialogThemeData(backgroundColor: AppColors.background),
        focusColor: AppColors.primaryNormal,
        indicatorColor: AppColors.primaryNormal,
      ),
      themeMode: ThemeMode.light,
      initialBinding: MainBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      translations: TranslationService(),
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
    );
  }
}

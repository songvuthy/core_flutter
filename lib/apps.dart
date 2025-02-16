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
        dialogBackgroundColor: AppColors.background,
        focusColor: AppColors.primaryNormal,
        indicatorColor: AppColors.primaryNormal,
        fontFamily: 'Poppins',
        fontFamilyFallback: const ['Poppins', 'KantumruyPro'],
        textTheme: Theme.of(context).textTheme.copyWith(
              // Ensure all text styles have font family fallbacks
              labelSmall: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontFamilyFallback: ['Poppins', 'KantumruyPro'],
              ),
              labelMedium: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontFamilyFallback: ['Poppins', 'KantumruyPro'],
              ),
              labelLarge: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontFamilyFallback: ['Poppins', 'KantumruyPro'],
              ),
              bodySmall: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamilyFallback: ['Poppins', 'KantumruyPro'],
              ),
              bodyMedium: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamilyFallback: ['Poppins', 'KantumruyPro'],
              ),
              bodyLarge: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontFamilyFallback: ['Poppins', 'KantumruyPro'],
              ),
              titleSmall: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontFamilyFallback: ['Poppins', 'KantumruyPro'],
              ),
              titleMedium: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontFamilyFallback: ['Poppins', 'KantumruyPro'],
              ),
              titleLarge: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamilyFallback: ['Poppins', 'KantumruyPro'],
              ),
              headlineSmall:
                  Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontFamilyFallback: ['Poppins', 'KantumruyPro'],
              ),
              headlineMedium:
                  Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontFamilyFallback: ['Poppins', 'KantumruyPro'],
              ),
              headlineLarge:
                  Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontFamilyFallback: ['Poppins', 'KantumruyPro'],
              ),
              displaySmall: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontFamilyFallback: ['Poppins', 'KantumruyPro'],
              ),
              displayMedium:
                  Theme.of(context).textTheme.displayMedium?.copyWith(
                fontFamilyFallback: ['Poppins', 'KantumruyPro'],
              ),
              displayLarge: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontFamilyFallback: ['Poppins', 'KantumruyPro'],
              ),
              // Add other text styles as needed
            ),
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

import 'package:core_flutter/app/constants/app_storage.dart';
import 'package:core_flutter/app/translations/app_language_extension.dart';
import 'package:core_flutter/app/translations/lang/en_us_translation.dart';
import 'package:core_flutter/app/translations/lang/km_kh_translation.dart';
import 'package:core_flutter/app/translations/lang/zh_cn_translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TranslationService extends Translations {
  static final _storage = GetStorage(AppStorage.init);

  // Using enum for supported languages and locales
  static final langs = AppLanguage.values;

  // Default and fallback locales
  static final locale = _getCurrentLocale();
  static final fallbackLocale = Locale('en', 'US');

  // Register translations for GetX
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUs,
        'km_KH': kmKh,
        'zh_CN': zhCn, // Added Chinese translations
      };

  // Get current locale from storage or fallback to English
  static Locale _getCurrentLocale() {
    String? langCode = _storage.read(AppStorage.selectedLocale);
    if (langCode != null) {
      try {
        return AppLanguage.values
            .firstWhere((lang) => lang.languageCode == langCode)
            .locale;
      } catch (e) {
        return Locale('en', 'US');
      }
    }
    return Locale('en', 'US'); // Default to English
  }

  // Change the locale and store the choice
  static void changeLocale(AppLanguage lang) {
    String? langCode = _storage.read(AppStorage.selectedLocale);
    if (langCode == lang.languageCode) {
      return;
    }
    _storage.write(AppStorage.selectedLocale, lang.languageCode);
    Get.updateLocale(lang.locale);
  }
}

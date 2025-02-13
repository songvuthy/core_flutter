import 'package:core_flutter/app/constants/app_storage.dart';
import 'package:core_flutter/app/translations/en_us_translation.dart';
import 'package:core_flutter/app/translations/km_kh_translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TranslationService extends Translations {
  static final _storage = GetStorage(AppStorage.init);
  static final _localeKey = 'selected_locale';

  // Supported languages and locales
  static final langs = ['English', 'Khmer'];
  static final locales = [
    Locale('en', 'US'),
    Locale('km', 'KH'),
  ];

  // Default and fallback locales
  static final locale = getCurrentLocale();
  static final fallbackLocale = Locale('en', 'US');

  // Register translations for GetX
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUs,
        'km_KH': kmKh,
      };

  // Get current locale from storage or fallback to English
  static Locale getCurrentLocale() {
    String? langCode = _storage.read(_localeKey);
    if (langCode != null) {
      return locales.firstWhere((locale) => locale.languageCode == langCode);
    }
    return Locale('en', 'US'); // Default to English
  }

  // Change the locale and store the choice
  static Future<void> changeLocale(String lang) async {
    final locale = _getLocaleFromLanguage(lang);
    _storage.write(_localeKey, locale.languageCode);
    Get.updateLocale(locale);
  }

  static Locale _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale!;
  }
}

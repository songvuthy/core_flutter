import 'package:flutter/material.dart';
enum AppLanguage {
  english,
  khmer,
  chinese,
}

extension AppLanguageExtension on AppLanguage {
  String get name {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.khmer:
        return 'Khmer';
      case AppLanguage.chinese:
        return 'Chinese';
    }
  }

  String get languageCode {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.khmer:
        return 'km';
      case AppLanguage.chinese:
        return 'zh';
    }
  }

  Locale get locale {
    switch (this) {
      case AppLanguage.english:
        return Locale('en', 'US');
      case AppLanguage.khmer:
        return Locale('km', 'KH');
      case AppLanguage.chinese:
        return Locale('zh', 'CN');
    }
  }
}

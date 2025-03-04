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
        return 'ខ្មែរ';
      case AppLanguage.chinese:
        return '中文';
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

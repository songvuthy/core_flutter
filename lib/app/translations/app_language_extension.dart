import 'package:flutter/material.dart';

enum AppLanguage {
  english,
  khmer,
}

extension AppLanguageExtension on AppLanguage {
  String get name {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.khmer:
        return 'Khmer';
    }
  }

  String get languageCode {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.khmer:
        return 'km';
    }
  }

  Locale get locale {
    switch (this) {
      case AppLanguage.english:
        return Locale('en', 'US');
      case AppLanguage.khmer:
        return Locale('km', 'KH');
    }
  }
}

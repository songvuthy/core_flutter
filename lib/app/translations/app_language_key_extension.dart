import 'package:get/get.dart';

enum LanguageKey {
  homeTitle,
  homeSelectLanguage
}

extension AppLanguageKeyExtension on LanguageKey {
  String get key {
    return toString().split('.').last;
  }

  String get tr {
    return key.tr;
  }
}

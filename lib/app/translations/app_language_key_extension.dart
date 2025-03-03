import 'package:get/get.dart';

enum LanguageKey {
  homeTitle,
  homeItem,
  homeSearch
}

extension AppLanguageKeyExtension on LanguageKey {
  String get key {
    return toString().split('.').last;
  }

  String get tr {
    return key.tr;
  }
}

import 'package:get/get.dart';

enum LanguageKey {
  homeTitle,
  hello,
  welcome,
  language,
}

extension AppLanguageKeyExtension on LanguageKey {
  String get key {
    return toString().split('.').last;
  }

  String get tr {
    return key.tr;
  }
}

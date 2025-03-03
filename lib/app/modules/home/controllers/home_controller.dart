import 'package:core_flutter/app/translations/app_language_extension.dart';
import 'package:core_flutter/app/translations/app_language_key_extension.dart';
import 'package:core_flutter/app/translations/translation_service.dart';
import 'package:core_flutter/app/widgets/app_reusable_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with AppReusableComponent {
  final List<String> items = List.generate(8, (index) => 'Item ${index + 1}');

  void changeLanguage() {
    showCustomDialogContent(
      titleNegative: null,
      titlePositive: null,
      title: LanguageKey.homeSelectLanguage.tr,
      content: Column(
        children: [
          ListTile(
            title: Text(AppLanguage.english.name),
            onTap: () {
              TranslationService.changeLocale(AppLanguage.english);
              Get.back();
            },
          ),
          ListTile(
            title: Text(AppLanguage.khmer.name),
            onTap: () {
              TranslationService.changeLocale(AppLanguage.khmer);
              Get.back();
            },
          ),
          ListTile(
            title: Text(AppLanguage.chinese.name),
            onTap: () {
              TranslationService.changeLocale(AppLanguage.chinese);
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}

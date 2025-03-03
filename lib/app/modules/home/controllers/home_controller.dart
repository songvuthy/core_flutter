import 'package:core_flutter/app/data/providers/local_data_source.dart';
import 'package:core_flutter/app/translations/app_language_extension.dart';
import 'package:core_flutter/app/translations/translation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  LocalDataSource localDataSource = Get.find();
  final searchController = TextEditingController();
  final List<String> items = List.generate(8, (index) => '${index + 1}');
  final isGrid = false.obs;

  @override
  void onInit() async {
    super.onInit();
    isGrid.value = await localDataSource.getDisplaySettings();
  }

  void toggleGrid() {
    isGrid.value = !isGrid.value;
    localDataSource.setDisplaySettings(isGrid.value);
  }

  changeLanguage(String code) {
    final lang = AppLanguage.values.firstWhere((e) => e.languageCode == code);
    TranslationService.changeLocale(lang);
  }
}

import 'package:core_flutter/app/data/providers/local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  LocalDataSource localDataSource = Get.find();
  final searchController = TextEditingController();
  final List<String> items = List.generate(8, (index) => 'Item ${index + 1}');
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
}

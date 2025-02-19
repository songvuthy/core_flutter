import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HomeController extends GetxController {
  // Scroll controllers
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  // Active menu index
  var selectedMenuIndex = 0.obs;
  // Menu and section data
  final List<String> menuItems = ['Hits', 'Rolls', 'Boxes', 'Drinks', 'Sets'];
  final List<String> sections = [
    'Hits Section',
    'Rolls Section',
    'Boxes Section',
    'Drinks Section',
    'Sets Section'
  ];

  @override
  void onInit() {
    super.onInit();
    // Update active menu when scrolling
    itemPositionsListener.itemPositions.addListener(() {
      final visibleItems = itemPositionsListener.itemPositions.value;
      if (visibleItems.isNotEmpty) {
        int firstVisibleIndex = visibleItems.first.index;
        selectedMenuIndex.value = firstVisibleIndex;
      }
    });
  }

  // Scroll to specific section
  void scrollToSection(int index) {
    itemScrollController.scrollTo(
      index: index,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

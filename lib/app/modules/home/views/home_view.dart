import 'package:core_flutter/app/routes/app_pages.dart';
import 'package:core_flutter/app/translations/app_language_key_extension.dart';
import 'package:core_flutter/app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static void open() {
    Get.offAndToNamed(Routes.HOME);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isShowBack: false,
        title: Text(LanguageKey.homeTitle.tr),
      ),
      body: Row(
        children: [
          // Pinned Menu without wrapping the entire ListView
          Container(
            width: 100,
            color: Colors.orange[100],
            child: ListView.builder(
              itemCount: controller.menuItems.length,
              itemBuilder: (context, index) {
                return Obx(() => ListTile(
                      title: Column(
                        children: [
                          Icon(
                            Icons.circle,
                            color: controller.selectedMenuIndex.value == index
                                ? Colors.orange
                                : Colors.grey,
                          ),
                          Text(
                            controller.menuItems[index],
                            style: TextStyle(
                              fontSize: 12,
                              color: controller.selectedMenuIndex.value == index
                                  ? Colors.orange
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Scroll to the section on tap
                        controller.scrollToSection(index);
                      },
                    ));
              },
            ),
          ),
          // Scrollable List of Sections
          Expanded(
            child: ScrollablePositionedList.builder(
              itemScrollController: controller.itemScrollController,
              itemPositionsListener: controller.itemPositionsListener,
              itemCount: controller.sections.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 300,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(bottom: 10),
                  color: Colors.orange[50 * (index + 1)],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.sections[index],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Description for ${controller.sections[index]}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Order'),
              Text('Total: 0'),
            ],
          ),
        ),
      ),
    );
  }
}

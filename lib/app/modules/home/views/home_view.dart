import 'package:core_flutter/app/modules/home/views/widgets/home_widget.dart';
import 'package:core_flutter/app/routes/app_pages.dart';
import 'package:core_flutter/app/translations/app_language_extension.dart';
import 'package:core_flutter/app/translations/app_language_key_extension.dart';
import 'package:core_flutter/app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
        leadAction: Builder(
          // ✅ Wrap in Builder to get correct context
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Text(LanguageKey.homeTitle.tr),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              controller.changeLanguage(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: AppLanguage.english.languageCode,
                  child: Text(AppLanguage.english.name),
                ),
                PopupMenuItem(
                  value: AppLanguage.khmer.languageCode,
                  child: Text(AppLanguage.khmer.name),
                ),
                PopupMenuItem(
                  value: AppLanguage.chinese.languageCode,
                  child: Text(AppLanguage.chinese.name),
                ),
              ];
            },
          ),
        ],
      ),
      body: HomeWidget(controller: controller),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                Get.back();
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}

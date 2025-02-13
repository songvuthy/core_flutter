import 'package:core_flutter/app/routes/app_pages.dart';
import 'package:core_flutter/app/theme/app_text_style.dart';
import 'package:core_flutter/app/translations/translation_service.dart';
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
      appBar: CustomAppBar(isShowBack: false, title: Text("home_title".tr)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'hello'.tr,
              style: AppTextStyle.h1Headline,
            ),
            Text(
              'welcome'.tr,
              style: AppTextStyle.body1,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                TranslationService.changeLocale('English');
              },
              child: Text('English'),
            ),
            ElevatedButton(
              onPressed: () {
                TranslationService.changeLocale('Khmer');
              },
              child: Text('ភាសាខ្មែរ'),
            ),
          ],
        ),
      ),
    );
  }
}

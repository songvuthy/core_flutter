import 'package:core_flutter/app/modules/home/views/widgets/home_widget.dart';
import 'package:core_flutter/app/routes/app_pages.dart';
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
          isShowBack: false, title: Text(LanguageKey.homeTitle.tr)),
      body: HomeWidget(controller: controller),
    );
  }
}

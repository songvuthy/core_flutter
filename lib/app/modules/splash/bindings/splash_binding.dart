import 'package:core_flutter/app/repository/common_repository.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommonRepository());
    Get.put<SplashController>(SplashController());
  }
}

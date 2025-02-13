import 'package:core_flutter/app/extension/string_extension.dart';
import 'package:core_flutter/app/modules/home/views/home_view.dart';
import 'package:core_flutter/env/device_info.dart';
import 'package:core_flutter/app/utils/token_utils.dart';
import 'package:core_flutter/apps.dart';
import 'package:core_flutter/env/app_config.dart';
import 'package:core_flutter/env/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    _initComponent();
    super.onInit();
  }

  Future<void> _initComponent() async {
    // App Config
    instanceAppConfig = AppConfigOption.appConfig;
    // Firebase Initialize App
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Device Info
    instanceDeviceInfo = await DeviceInfoData.deviceInfo();
    // Access Token
    accessToken = await TokenUtils.instance.accessToken;
    //Init Screen
    Future.delayed(Duration(seconds: 3), () {
      HomeView.open();
    });
  }
}

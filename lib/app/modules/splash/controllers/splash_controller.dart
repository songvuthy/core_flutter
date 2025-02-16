import 'package:core_flutter/app/constants/app_decoration.dart';
import 'package:core_flutter/app/extension/api_extension.dart';
import 'package:core_flutter/app/modules/home/views/home_view.dart';
import 'package:core_flutter/app/repository/common_repository.dart';
import 'package:core_flutter/env/device_info.dart';
import 'package:core_flutter/app/utils/token_utils.dart';
import 'package:core_flutter/apps.dart';
import 'package:core_flutter/env/app_config.dart';
import 'package:core_flutter/env/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final CommonRepository _commonRepository = CommonRepository();

  @override
  void onInit() {
    _getSetting();
    super.onInit();
  }

  Future<void> _getSetting() async {
    await _initComponent();
    final result = await _commonRepository.getSettting();
    result.validateWithRetryDialog(
      onNext: (data) => HomeView.open(),
      onRetry: () => _getSetting(),
    );
  }

  Future<void> _initComponent() async {
    // Device Orientation
    SystemChrome.setPreferredOrientations(_getDeviceOrientations());
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
  }

  List<DeviceOrientation> _getDeviceOrientations() {
    if (AppDecoration.isTablet) {
      return [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
    }
    return [DeviceOrientation.portraitUp];
  }
}

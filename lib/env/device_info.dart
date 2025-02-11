// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfo {
  final String udid;
  final String deviceName;
  final String modelName;
  final String osVersion;
  final String appVersion;
  final String appBuildVersion;

  DeviceInfo({
    required this.udid,
    required this.deviceName,
    required this.modelName,
    required this.osVersion,
    required this.appVersion,
    required this.appBuildVersion,
  });
}

class DeviceInfoData {
  static Future<DeviceInfo> deviceInfo() async {
    var deviceInfo = DeviceInfoPlugin();
    var packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return DeviceInfo(
        udid: iosDeviceInfo.identifierForVendor!,
        deviceName: iosDeviceInfo.name,
        modelName: iosDeviceInfo.model,
        osVersion: "${iosDeviceInfo.systemName} ${iosDeviceInfo.systemVersion}",
        appVersion: packageInfo.version,
        appBuildVersion: packageInfo.buildNumber,
      );
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return DeviceInfo(
        udid: androidDeviceInfo.id,
        deviceName: androidDeviceInfo.name,
        modelName: androidDeviceInfo.model,
        osVersion: "Android ${androidDeviceInfo.version.release}",
        appVersion: packageInfo.version,
        appBuildVersion: packageInfo.buildNumber,
      );
    } else {
      throw Exception("Not found device specific");
    }
  }
}

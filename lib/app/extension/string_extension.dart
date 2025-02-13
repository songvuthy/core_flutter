import 'package:core_flutter/apps.dart';

extension StringExtension on String {
  String mergeBaseUrlApiEndPoint() {
    return instanceAppConfig.baseUrlApi + this;
  }

  String mergeBaseUrlMediaEndPoint() {
    return instanceAppConfig.baseUrlMedia + this;
  }
}

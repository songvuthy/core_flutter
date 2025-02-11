import 'package:core_flutter/apps.dart';

class ApiUtils {
  ApiUtils._();
  static final instance = ApiUtils._();

  String mergeEndPoint({required String endPoint}) {
    return instanceAppConfig.baseUrlApi + endPoint;
  }
}

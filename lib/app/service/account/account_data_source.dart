import 'package:core_flutter/app/data/providers/api_request.dart';
import 'package:core_flutter/app/utils/api_utils.dart';
import 'package:http/http.dart' as http;

class AccountDataSource {
  final ApiRequest _apiRequest = ApiRequest();

  http.Request logout() {
    return _apiRequest.methodPost(
      ApiUtils.instance.mergeEndPoint(endPoint: "auth/logout"),
      null,
    );
  }
}

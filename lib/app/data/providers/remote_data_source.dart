import 'package:core_flutter/app/data/providers/api_request.dart';
import 'package:core_flutter/app/extension/string_extension.dart';
import 'package:http/http.dart' as http;

class RemoteDataSource {
  final ApiRequest _apiRequest = ApiRequest();

  http.Request login({required Map<String, dynamic> body}) {
    return _apiRequest.methodPost(
      "auth-password/login".mergeBaseUrlApiEndPoint(),
      body,
    );
  }

  http.Request logout() {
    return _apiRequest.methodPost(
      "auth-logout/logout".mergeBaseUrlApiEndPoint(),
      null,
    );
  }

  http.Request getSetting() {
    return _apiRequest.methodGet("setting".mergeBaseUrlApiEndPoint());
  }
}

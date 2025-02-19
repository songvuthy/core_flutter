import 'package:core_flutter/app/data/models/response/setting_response.dart';
import 'package:core_flutter/app/data/providers/api_request.dart';
import 'package:core_flutter/app/extension/api_extension.dart';
import 'package:core_flutter/app/extension/string_extension.dart';
import 'package:core_flutter/app/widgets/custom_state_view.dart';

class CommonRepository {
  final ApiRequest _apiRequest = ApiRequest();

  Future<ViewState<SettingResponse>> getSettting() async {
    final request = _apiRequest.methodGet("setting".mergeBaseUrlApiEndPoint());
    return request.toViewState(SettingResponse.fromMap);
  }
}

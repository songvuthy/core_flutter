import 'package:core_flutter/app/data/models/dto/login_dto.dart';
import 'package:core_flutter/app/data/models/response/message_response.dart';
import 'package:core_flutter/app/data/models/response/token_response.dart';
import 'package:core_flutter/app/data/providers/api_request.dart';
import 'package:core_flutter/app/extension/api_extension.dart';
import 'package:core_flutter/app/extension/string_extension.dart';
import 'package:core_flutter/app/widgets/custom_state_view.dart';

class AccountRepository {
  final ApiRequest _apiRequest = ApiRequest();

  Future<ViewState<TokenResponse>> login({required LoginDto body}) async {
    final request = _apiRequest.methodPost(
      "auth-login/login".mergeBaseUrlApiEndPoint(),
      body.toJson(),
    );
    return await request.toViewState(TokenResponse.fromMap);
  }

  Future<ViewState<MessageResponse>> logout() async {
    final request = _apiRequest.methodPost(
      "auth-logout/logout".mergeBaseUrlApiEndPoint(),
      null,
    );
    return await request.toViewState(MessageResponse.fromMap);
  }

  
}

import 'package:core_flutter/app/data/models/message_response.dart';
import 'package:core_flutter/app/data/models/token_response.dart';
import 'package:core_flutter/app/data/providers/remote_data_source.dart';
import 'package:core_flutter/app/extension/api_extension.dart';
import 'package:core_flutter/app/widgets/custom_state_view.dart';
import 'package:get/get.dart';

class AccountRepository {
  final RemoteDataSource _remoteDataSource = Get.find();

  Future<ViewState<TokenResponse>> login({
    required String user,
    required String password,
    required String deviceToken,
  }) async {
    final body = {
      "user": user,
      "password": password,
      "deviceToken": deviceToken,
    };
    final request = _remoteDataSource.login(body: body);
    return await request.toViewState(TokenResponse.fromMap);
  }

  Future<ViewState<MessageResponse>> logout() async {
    final request = _remoteDataSource.logout();
    return await request.toViewState(MessageResponse.fromMap);
  }
}

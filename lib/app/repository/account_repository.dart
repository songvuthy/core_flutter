import 'package:core_flutter/app/data/models/message_response.dart';
import 'package:core_flutter/app/data/providers/remote_data_source.dart';
import 'package:core_flutter/app/extension/api_extension.dart';
import 'package:core_flutter/app/widgets/custom_state_view.dart';
import 'package:get/get.dart';

class AccountRepository {
  final RemoteDataSource _remote = Get.find();

  Future<ViewState<MessageResponse>> logout() async {
    final request = _remote.logout();
    return await request.toViewState(MessageResponse.fromMap);
  }
}

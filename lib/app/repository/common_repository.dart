import 'package:core_flutter/app/data/models/setting_response.dart';
import 'package:core_flutter/app/data/providers/remote_data_source.dart';
import 'package:core_flutter/app/extension/api_extension.dart';
import 'package:core_flutter/app/widgets/custom_state_view.dart';
import 'package:get/get.dart';

class CommonRepository {
  final RemoteDataSource _remoteDataSource = Get.find();

  Future<ViewState<SettingResponse>> getSettting() async {
    final request = _remoteDataSource.getSetting();
    return request.toViewState(SettingResponse.fromMap);
  }
}

import 'package:core_flutter/app/data/providers/local_data_source.dart';
import 'package:get/get.dart';

class CredentialRepository {
  final LocalDataSource _local = Get.find();

  Future<String?> getAccessToken() async {
    return await _local.getAccessToken();
  }

  Future<String?> getRefreshToken() async {
    return await _local.getRefreshToken();
  }

  Future<void> setAccessToken(String value) async {
    await _local.setAccessToken(value);
  }

  Future<void> setRefreshToken(String value) async {
    await _local.setRefreshToken(value);
  }

  bool getIsLogged() {
    return _local.getIsLogged();
  }

  Future<void> setIsLogged(bool value) async {
    await _local.setIsLogged(value);
  }
}

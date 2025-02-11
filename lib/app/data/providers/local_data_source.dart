import 'package:core_flutter/app/constants/app_storage.dart';
import 'package:core_flutter/app/data/providers/storage_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalDataSource {
  final _storage = StorageClient();
  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<String?> getAccessToken() async {
    return _secureStorage.read(key: AppStorage.accessToken);
  }

  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: AppStorage.refreshToken);
  }

  Future<void> setAccessToken(String value) async {
    await _secureStorage.write(
        key: AppStorage.accessToken, value: value);
  }

  Future<void> setRefreshToken(String value) async {
    await _secureStorage.write(
        key: AppStorage.refreshToken, value: value);
  }

  Future<void> setIsLogged(bool value) async {
    await _storage.save(AppStorage.logged, value);
  }

  bool getIsLogged() {
    return (_storage.read(AppStorage.logged) as bool?) ?? false;
  }

  Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll(
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
  }
}

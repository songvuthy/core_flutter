import 'package:core_flutter/app/data/providers/local_data_source.dart';
import 'package:core_flutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TokenUtils {
  TokenUtils._();
  static final instance = TokenUtils._();

  final LocalDataSource _local = Get.find();

  Future<String?> get accessToken async => await _local.getAccessToken();
  Future<String?> get refreshToken async => await _local.getRefreshToken();

  Future<void> showSessionExpired() async {
    await Get.dialog(
      PopScope(
        canPop: false,
        onPopInvokedWithResult: (val, result) => Future.value(false),
        child: AlertDialog(
          title: const Text("Session Expired!"),
          content: const Text("Please login again"),
          actions: [
            TextButton(
              onPressed: () async {
                await GetStorage().erase();
                await _local.clearSecureStorage();
                Get.offAllNamed(Routes.SPLASH);
              },
              child: Text("Okay"),
            )
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}

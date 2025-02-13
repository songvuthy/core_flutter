import 'dart:async';
import 'package:core_flutter/app/constants/app_storage.dart';
import 'package:core_flutter/apps.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

FutureOr<void> main() async {
  await GetStorage.init(AppStorage.init);
  runApp(const Apps());
}

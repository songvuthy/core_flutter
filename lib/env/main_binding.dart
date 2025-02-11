import 'package:core_flutter/app/data/providers/local_data_source.dart';
import 'package:core_flutter/app/data/providers/remote_data_source.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  MainBinding();
  @override
  void dependencies() {
    Get.put(LocalDataSource(), permanent: true);
    Get.put(RemoteDataSource(), permanent: true);
  }
}

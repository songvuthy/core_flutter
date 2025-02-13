import 'package:core_flutter/app/constants/app_storage.dart';
import 'package:get_storage/get_storage.dart';

class StorageClient {
  final GetStorage _box = GetStorage(AppStorage.init);

  // Save an item to the storage
  Future<void> save(String key, dynamic value) async {
    await _box.write(key, value);
  }

  // Read an item from the storage
  dynamic read(String key) {
    return _box.read(key);
  }

  // Delete an item from the storage
  Future<void> delete(String key) async {
    await _box.remove(key);
  }

  // Check if an item exists in the storage
  bool containsKey(String key) {
    return _box.hasData(key);
  }

  // Clear all items from the storage
  void clearStorage() {
    _box.erase();
  }

  // Get all keys stored in the storage
  List<String> getAllKeys() {
    return _box.getKeys().toList();
  }
}

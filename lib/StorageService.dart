import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

abstract class StorageService {
  Future<void> init();
  Future<void> save(String key, String value);
  Future<String?> find(String key);
}

class HiveStorageService implements StorageService {
  @override
  Future<void> init() async {
    final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);

    await Hive.openBox("myBox");
  }

  @override
  Future<void> save(String key, String value) async {
    var box = await Hive.openBox("myBox");
    box.put(key, value);
  }

  @override
  Future<String?> find(String key) async {
    var box = await Hive.openBox("myBox");
    if (box.get("timers") == null) {
      box.put("timers", "[]");
    }

    return box.get(key);
  }
}
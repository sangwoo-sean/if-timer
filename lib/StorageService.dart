import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'components/Item.dart';

abstract class StorageService {
  Future<void> init();
  Future<void> save(String key, String value);
  Future<String?> find(String key);
  Future<void> saveTimers(Item item);
  Future<List<Item>> findTimers();
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

  @override
  Future<List<Item>> findTimers() async {
    var timersJson = await find("timers");
    if (timersJson == null) return List<Item>.empty();

    List<dynamic> timers = jsonDecode(timersJson);
    return timers.map((i) => Item.fromJson(i)).toList();
  }

  @override
  Future<void> saveTimers(Item item) async {
    List<Item> items = await findTimers();
    items.add(item);
    await save("timers", jsonEncode(items));
  }
}
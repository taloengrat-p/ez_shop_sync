import 'dart:developer';

import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class BaseHiveRepository<I, T extends BaseHiveObject> {
  String boxName;
  late Box<T> box;

  BaseHiveRepository({required this.boxName}) {
    init();
  }
  init() {
    box = Hive.box<T>(boxName);
  }

  Future<T> create(T request) async {
    await box.put(
      request.id,
      request
        ..createDate = DateTime.now()
        ..updateDate = DateTime.now(),
    );

    return request;
  }

  T? getById(I id) {
    return box.get(id);
  }

  List<T> getAll() {
    List<T> result = box.values.toList();
    result.sort((a, b) => a.createDate!.millisecondsSinceEpoch
        .compareTo(b.createDate!.millisecondsSinceEpoch));
    return result;
  }

  Future<void> delete(I id) async {
    await box.delete(id);
  }

  Future<void> deleteAll(List<I> ids) async {
    await box.deleteAll(ids);
  }

  Future<T> update(I id, T updated) async {
    await box.put(id, updated);
    return updated;
  }

  List<T> getAllById(List<I> ids) {
    log('box.values $T : ${box.values.map((e) => e.id)}');
    return box.values.where((e) => ids.contains(e.id)).toList();
  }
}

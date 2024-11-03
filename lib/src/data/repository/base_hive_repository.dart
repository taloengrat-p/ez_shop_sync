import 'dart:developer';

import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_repository.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

abstract class BaseHiveRepository<I, T extends BaseHiveObject> {
  String boxName;
  late Box<T> box;

  BaseHiveRepository({required this.boxName}) {
    init();
  }
  init() {
    box = Hive.box<T>(boxName);
  }

  Future<T> create(
    T request, {
    String? userId,
  }) async {
    final id = request.id ?? const Uuid().v4();
    await box.put(
      id,
      request
        ..createDate = DateTime.now()
        ..updateDate = DateTime.now()
        ..createBy = userId
        ..updateBy = userId,
    );
    request.id = id;
    return request;
  }

  T? getById(I id) {
    return box.get(id);
  }

  List<T> getAll() {
    List<T> result = box.values.toList();
    result.sort(
        (a, b) => b.createDate?.millisecondsSinceEpoch.compareTo(a.createDate?.millisecondsSinceEpoch ?? -1) ?? -1);
    return result;
  }

  List<T> getAllRange(int start, int end) {
    List<T> result = box.values.toList();
    result.sort(
        (a, b) => b.createDate?.millisecondsSinceEpoch.compareTo(a.createDate?.millisecondsSinceEpoch ?? -1) ?? -1);
    return result.length < (end - start) ? result : result.sublist(start, end);
  }

  Future<void> delete(I id) async {
    await box.delete(id);
  }

  Future<void> deleteAllByIds(List<I> ids) async {
    await box.deleteAll(ids);
  }

  Future<void> deleteAll() async {
    await box.deleteFromDisk();
  }

  Future<T> update(
    I id,
    T updated, {
    String? userId,
  }) async {
    await box.put(
      id,
      updated
        ..updateDate = DateTime.now()
        ..updateBy = userId,
    );

    return updated;
  }

  List<T> getAllById(List<I> ids) {
    return getAll().where((e) => ids.contains(e.id)).toList();
  }

  List<T> getAllBetween({required DateTime start, required DateTime end}) {
    return getAll().where((e) {
      final result = (e.createDate?.isAfter(start) ?? false) && (e.createDate?.isBefore(end) ?? false) ||
          (e.createDate?.isAtSameMomentAs(start) ?? false) ||
          (e.createDate?.isAtSameMomentAs(end) ?? false);
      log('getAllBetween ${start.toDisplay()} to ${end.toDisplay()} but ${e.createDate!.toDisplay()} is $result');
      return result;
    }).toList();
  }
}

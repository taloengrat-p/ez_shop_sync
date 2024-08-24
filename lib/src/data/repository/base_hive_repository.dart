import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/v1.dart';

abstract class BaseHiveRepository<I, T extends Object> {
  String boxName;
  late Box<T> box;

  BaseHiveRepository({required this.boxName}) {
    init();
  }
  init() {
    box = Hive.box<T>(boxName);
  }

  Future<T> create(T request, {String? idCustom}) async {
    final String id = idCustom ?? const UuidV1().generate();

    await box.put(
      id,
      request,
    );

    return request;
  }

  T? getById(I id) {
    return box.get(id);
  }

  List<T> getAll() {
    return box.values.toList();
  }

  delete(I id) {
    box.delete(id);
  }

  deleteAll(List<I> ids) {
    box.deleteAll(ids);
  }

  T update(I id, T updated) {
    box.put(id, updated);
    return updated;
  }
}

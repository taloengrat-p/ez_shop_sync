import 'dart:developer';

import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
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

  Future<ApiResult<T>> create(BaseRepoRequest<T> request) async {
    try {
      final id = request.data.id ?? const Uuid().v4();
      await box.put(
        id,
        request.data
          ..info?.createAt = DateTime.now()
          ..info?.createBy = request.userId
          ..info?.updateBy = request.userId,
      );
      request.data.id = id;
      return Future.value(ApiResult(response: request.data));
    } catch (e) {
      return Future.value(ApiResult(error: e));
    }
  }

  Future<ApiResult<T>> createIfNotExist(BaseRepoRequest<T> request) async {
    final resultExist = await getById(request.data.id);

    await resultExist.when(
      success: (response) async {
        return await create(request);
      },
      failure: (error) {
        return ApiResult(error: error);
      },
    );

    return resultExist;
  }

  Future<ApiResult<T>> getById(I id) {
    final result = box.get(id);
    if (result != null) {
      return Future.value(ApiResult(response: result));
    } else {
      return Future.value(ApiResult(error: null));
    }
  }

  Future<ApiResult<List<T>>> getAll() {
    try {
      List<T> result = box.values.toList();
      result.sort(
        (a, b) =>
            b.info?.createAt?.millisecondsSinceEpoch.compareTo(a.info?.createAt?.millisecondsSinceEpoch ?? -1) ?? -1,
      );
      return Future.value(ApiResult(response: result));
    } catch (e) {
      return Future.value(ApiResult(error: e));
    }
  }

  List<T> getAllRange(int start, int end) {
    List<T> result = box.values.toList();
    result.sort(
      (a, b) =>
          b.info?.createAt?.millisecondsSinceEpoch.compareTo(a.info?.createAt?.millisecondsSinceEpoch ?? -1) ?? -1,
    );
    return result.length < (end - start) ? result : result.sublist(start, end);
  }

  Future<ApiResult> delete(I id) async {
    try {
      await box.delete(id);
      return Future.value(ApiResult());
    } catch (e) {
      return Future.value(ApiResult(error: e));
    }
  }

  Future<ApiResult> deleteAllByIds(List<I> ids) async {
    try {
      await box.deleteAll(ids);
      return Future.value(ApiResult());
    } catch (e) {
      return Future.value(ApiResult(error: e));
    }
  }

  Future<ApiResult> deleteAll() async {
    try {
      await box.deleteFromDisk();
      return ApiResult(response: 'Delete all success');
    } catch (e) {
      return ApiResult(error: e);
    }
  }

  Future<ApiResult<T>> update(BaseRepoRequest<T> request) async {
    try {
      await box.put(
        request.data.id,
        request.data
          ..info?.updateAt = DateTime.now()
          ..info?.updateBy = request.userId,
      );

      return Future.value(ApiResult(response: request.data));
    } catch (e) {
      return Future.value(ApiResult(error: e));
    }
  }

  Future<ApiResult<List<T>>> getAllById(List<I> ids) async {
    final result = await getAll();

    return Future.value(ApiResult(response: result.response?.where((e) => ids.contains(e.id)).toList()));
  }

  Future<ApiResult<List<T>>> getAllBetween({required DateTime start, required DateTime end}) async {
    final result = await getAll();
    return Future.value(
      ApiResult(
        response:
            result.response?.where((e) {
              final result =
                  (e.info?.createAt?.isAfter(start) ?? false) && (e.info?.createAt?.isBefore(end) ?? false) ||
                  (e.info?.createAt?.isAtSameMomentAs(start) ?? false) ||
                  (e.info?.createAt?.isAtSameMomentAs(end) ?? false);
              log(
                'getAllBetween ${start.toDisplay()} to ${end.toDisplay()} but ${e.info?.createAt!.toDisplay()} is $result',
              );
              return result;
            }).toList(),
      ),
    );
  }
}

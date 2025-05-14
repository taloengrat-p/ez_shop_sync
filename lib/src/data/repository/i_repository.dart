import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/services/navigation_service.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';

abstract class IRepository<T> {
  String? _tag;
  AppMode appMode;
  NavigationService navigationService;

  String get tag => _tag ?? runtimeType.toString();

  IRepository(this.appMode, {required this.navigationService, String? tag});
  Future<ApiResult<List<T>>> getAll();
  Future<ApiResult<List<T>>> getAllByIds(List<String> ids);
  Future<ApiResult<T>> getById(BaseRepoRequest<String> id);
  // Future<ApiResult<T>> create(BaseRepoRequest<T> request);
  Future<ApiResult<T>> update(BaseRepoRequest<T> request);
  Future<ApiResult> delete(BaseRepoRequest<String> request);
  Future<ApiResult> deleteAllByIds(List<String> ids);
  Future<ApiResult> deleteAll();

  showToast({
    String? title,
    String? desc,
    ToastificationType? type,
    ToastificationStyle? style,
    Function(BuildContext? context, ToastificationItem item)? onTap,
  }) {
    ToastNotificationService.show(
      title: title ?? (type == ToastificationType.success ? 'Success' : 'Failure'),
      desc: desc,
      type: type,
      style: style,

      onTap: (toastItem) => onTap?.call(navigationService.navigatorKey.currentState?.context, toastItem),
    );
  }
}

import 'package:ez_shop_sync/src/models/enums/app_error_type.dart';

class ApiResult<T> {
  // final HttpResponse<T>? response;
  // DioException? error;
  final T? response;
  final Object? error;
  final AppErrorType? appErrorType;
  ApiResult({
    this.response,
    this.error,
    this.appErrorType,
  });

  when({
    required Function(T response) success,
    required Function(
      Object? error, {
      AppErrorType? errorType,
    }) failure,
  }) {
    if (response != null && response is T) {
      success.call(response as T);
    }

    if (error != null) {
      failure.call(
        error,
        errorType: appErrorType ?? AppErrorType.somethingWentWrong,
      );
    }
  }
}

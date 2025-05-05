// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:ez_shop_sync/src/data/repository/image/i_image_repository.dart';
// import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
// import 'package:injectable/injectable.dart';

// import 'package:ez_shop_sync/src/data/api_result.dart';
// import 'package:ez_shop_sync/src/data/dto/hive_object/notification.dart';
// import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
// import 'package:ez_shop_sync/src/data/repository/i_repository.dart';
// import 'package:ez_shop_sync/src/data/repository/image/local/image_local_repository.dart';
// import 'package:ez_shop_sync/src/data/repository/image/server/image_server_repository.dart';
// import 'package:ez_shop_sync/src/pages/_app/base_cubit.dart';

// @Singleton()
// @Injectable()
// class ImageRepository extends IRepository<Notification> implements IImageRepository {
//   final ImageServerRepository server;
//   final ImageLocalRepository local;
//   final AppCubit appCubit;

//   ImageRepository({required this.server, required this.local, required this.appCubit});

//   @override
//   Future<ApiResult<Notification>> create(BaseRepoRequest<Notification> request) {
//     if (appCubit.appMode == AppMode.local) {
//       // TODO: implement delete
//       throw UnimplementedError();
//     } else {
//       // TODO: implement delete
//       throw UnimplementedError();
//     }
//   }

//   @override
//   Future<ApiResult<void>> delete(BaseRepoRequest<String> request) {
//     if (appCubit.appMode == AppMode.local) {
//       // TODO: implement delete
//       throw UnimplementedError();
//     } else {
//       // TODO: implement delete
//       throw UnimplementedError();
//     }
//   }

//   @override
//   Future<ApiResult<void>> deleteAllByIds(List<String> ids) {
//     if (appCubit.appMode == AppMode.local) {
//       // TODO: implement delete
//       throw UnimplementedError();
//     } else {
//       // TODO: implement delete
//       throw UnimplementedError();
//     }
//   }

//   @override
//   Future<ApiResult<List<Notification>>> getAll() {
//     if (appCubit.appMode == AppMode.local) {
//       // TODO: implement delete
//       throw UnimplementedError();
//     } else {
//       // TODO: implement delete
//       throw UnimplementedError();
//     }
//   }

//   @override
//   Future<ApiResult<List<Notification>>> getAllByIds(List<String> ids) {
//     if (appCubit.appMode == AppMode.local) {
//       // TODO: implement delete
//       throw UnimplementedError();
//     } else {
//       // TODO: implement delete
//       throw UnimplementedError();
//     }
//   }

//   @override
//   Future<ApiResult<Notification>> getById(BaseRepoRequest<String> request) {
//     if (appCubit.appMode == AppMode.local) {
//       // TODO: implement delete
//       throw UnimplementedError();
//     } else {
//       // TODO: implement delete
//       throw UnimplementedError();
//     }
//   }

//   @override
//   Future<ApiResult<Notification>> update(BaseRepoRequest<Notification> request) {
//     if (appCubit.appMode == AppMode.local) {
//       // TODO: implement delete
//       throw UnimplementedError();
//     } else {
//       // TODO: implement delete
//       throw UnimplementedError();
//     }
//   }

//   @override
//   Future<ApiResult> deleteAll() {
//     // TODO: implement deleteAll
//     throw UnimplementedError();
//   }
// }

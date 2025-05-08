import 'dart:developer';

import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/image/i_image_repository.dart';
import 'package:ez_shop_sync/src/data/repository/image/local/image_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/image/server/image_server_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class ImageRepository extends IImageRepository {
  final ImageLocalRepository imageLocalRepository;
  final ImageServerRepository imageServerRepository;
  AppMode appMode = AppMode.server;

  ImageRepository({required this.imageLocalRepository, required this.imageServerRepository});

  @override
  Future<String> uploadImageToStore(BaseRepoRequest<UploadImageRequest> request) {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      return imageServerRepository.uploadImageToStore(request);
    }
  }

  @override
  Future<String> uploadImageToUser(BaseRepoRequest<UploadImageRequest> request) {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      return imageServerRepository.uploadImageToUser(request);
    }
  }

  @override
  Future deleteImageFromStore(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      log('deleteImageFromStore ${request.storeId}, ${request.data}');
      await imageServerRepository.deleteImageFromStore(request);
      return ApiResult(response: 'deleteImageFromStore ${request.data} success');
    }
  }

  @override
  Future deleteImageFromUser(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      await imageServerRepository.deleteImageFromStore(request);
    }
  }
}

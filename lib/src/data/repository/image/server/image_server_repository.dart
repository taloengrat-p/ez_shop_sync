// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/image/i_image_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/services/firebase_service.dart';

@Singleton()
class ImageServerRepository implements IImageRepository {
  final FirebaseService firebaseService;
  AppMode appMode = AppMode.server;

  ImageServerRepository({required this.firebaseService});

  @override
  Future<String> uploadImageToUser(BaseRepoRequest<UploadImageRequest> request) async {
    throwIf(request.userId == null, 'uploadImageToUser() request.userId == null');
    final storageRef = firebaseService.userStorage.child('${request.userId!}/${request.data.fileName}');
    await storageRef.putFile(request.data.file);
    final imageUrl = await storageRef.getDownloadURL();
    return imageUrl;
  }

  @override
  Future<String> uploadImageToStore(BaseRepoRequest<UploadImageRequest> request) async {
    throwIf(request.storeId == null, 'uploadImageToStore() request.userId == null');
    throwIf(request.data.fileName.isEmpty, 'uploadImageToStore() fileName.isEmpty');

    String reference = '${request.storeId!}/${request.data.fileName}';
    log('uploadImageToStore() $reference');
    final storageRef = firebaseService.storeStorage.child(reference);
    await storageRef.putFile(request.data.file);
    final imageUrl = await storageRef.getDownloadURL();
    return imageUrl;
  }

  @override
  Future deleteImageFromStore(BaseRepoRequest<String> request) async {
    try {
      final ref = firebaseService.storage.refFromURL(request.data);

      return await ref.delete();
    } catch (e) {
      throw ('deleteImageFromStore failure $e');
    }
  }

  @override
  Future deleteImageFromUser(BaseRepoRequest<String> request) async {
    try {
      final ref = firebaseService.storage.refFromURL(request.data);

      return await ref.delete();
    } catch (e) {
      throw ('deleteImageFromStore failure $e');
    }
  }
}

class UploadImageRequest {
  final File file;
  final String fileName;

  UploadImageRequest({required this.file, required this.fileName});
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/image_request/upload_image_request.dart';
import 'package:ez_shop_sync/src/data/repository/image/server/i_image_server_repository.dart';
import 'package:ez_shop_sync/src/services/firebase_service.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IImageServerRepository, env: [Flavor.DEV, Flavor.STG, Flavor.PROD])
class FirebaseStorageImageServerRepository implements IImageServerRepository {
  final FirebaseService firebaseService;

  FirebaseStorageImageServerRepository({required this.firebaseService});

  @override
  Future<String> uploadImageToUser(BaseRepoRequest<UploadImageRequest> request) async {
    final storageRef = firebaseService.userStorage.child('${request.userId}/${request.data.fileName}');
    await storageRef.putFile(request.data.file);
    final imageUrl = await storageRef.getDownloadURL();
    return imageUrl;
  }

  @override
  Future<String> uploadImageToStore(BaseRepoRequest<UploadImageRequest> request) async {
    throwIf(request.data.fileName.isEmpty, 'uploadImageToStore() fileName.isEmpty');

    String reference = '${request.storeId}/${request.data.fileName}';
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

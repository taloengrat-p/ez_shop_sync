// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/image/server/image_server_repository.dart';

abstract class IImageRepository {
  Future<String> uploadImageToStore(BaseRepoRequest<UploadImageRequest> request);
  Future<String> uploadImageToUser(BaseRepoRequest<UploadImageRequest> request);
  Future deleteImageFromStore(BaseRepoRequest<String> request);
  Future deleteImageFromUser(BaseRepoRequest<String> request);
}

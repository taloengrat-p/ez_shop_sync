// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/image_request/upload_image_request.dart';

abstract class IImageServerRepository {
  Future<String> uploadImageToUser(BaseRepoRequest<UploadImageRequest> request);

  Future<String> uploadImageToStore(BaseRepoRequest<UploadImageRequest> request);

  Future deleteImageFromStore(BaseRepoRequest<String> request);
}

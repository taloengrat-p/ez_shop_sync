import 'dart:io';

class UploadImageRequest {
  final File file;
  final String fileName;

  UploadImageRequest({required this.file, required this.fileName});
}

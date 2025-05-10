import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

@Singleton()
class ImagePickerUtils {
  static Future<File?> pickImage({ImageSource imageSource = ImageSource.gallery}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: imageSource);
    File image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
      return image;
    }

    return null;
  }

  static Future<File?> compressImageForThumbnail(
    File? file, {
    int quality = 70,
    int minWidth = 400,
    int minHeight = 400,
  }) async {
    throwIf(file == null, 'compressImageForThumbnail : file == null');

    try {
      Uint8List? compressed = await FlutterImageCompress.compressWithFile(
        file!.path,
        quality: quality,
        minHeight: minHeight,
        minWidth: minWidth,
        format: CompressFormat.jpeg,
      );

      if (compressed == null) {
        throw Exception('Compression failed');
      }
      final tempDir = await getTemporaryDirectory();
      final targetPath = path.join(tempDir.path, 'thumb_${DateTime.now().millisecondsSinceEpoch}.jpg');

      final result = await File(targetPath).writeAsBytes(compressed);

      return result;
    } catch (e) {
      throw ('compressImageForThumbnail $e');
    }
  }
}

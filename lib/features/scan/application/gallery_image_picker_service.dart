import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class PickedImageData {
  const PickedImageData({
    required this.path,
    required this.bytes,
  });

  final String path;
  final Uint8List bytes;
}

abstract class ImagePickerClient {
  Future<XFile?> pickImageFromGallery();
}

class DefaultImagePickerClient implements ImagePickerClient {
  DefaultImagePickerClient({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<XFile?> pickImageFromGallery() {
    return _picker.pickImage(source: ImageSource.gallery);
  }
}

class GalleryImagePickerService {
  GalleryImagePickerService({required ImagePickerClient client}) : _client = client;

  final ImagePickerClient _client;

  Future<PickedImageData?> pickSingleImage() async {
    final XFile? file = await _client.pickImageFromGallery();
    if (file == null) {
      return null;
    }

    try {
      final Uint8List bytes = await file.readAsBytes();
      return PickedImageData(path: file.path, bytes: bytes);
    } catch (_) {
      // Some platforms/tests may provide a path-only handle. Keep the path so
      // UI can still render via file/network fallback.
      return PickedImageData(path: file.path, bytes: Uint8List(0));
    }
  }

  Future<String?> pickSingleImagePath() async {
    final PickedImageData? picked = await pickSingleImage();
    return picked?.path;
  }
}

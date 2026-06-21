import 'dart:io';
import 'dart:typed_data';

/// Service for managing problem image files on disk
/// 
/// Responsibilities:
/// - Save image bytes to disk organized by problem ID
/// - Retrieve image paths for display
/// - Delete images when problems are removed
/// - List all images for a given problem
class ImageStorageService {
  final String baseDirectory;

  ImageStorageService({required this.baseDirectory});

  /// Save image bytes to disk and return the file path
  /// 
  /// Images are organized in subdirectories by problem ID:
  /// baseDirectory/
  ///   └─ {problemId}/
  ///     ├─ image_001.jpg
  ///     ├─ image_002.jpg
  ///     └─ ...
  Future<String> saveImage({
    required Uint8List imageBytes,
    required String problemId,
  }) async {
    if (imageBytes.isEmpty) {
      throw ArgumentError('Image bytes cannot be empty');
    }

    final problemDir = Directory('$baseDirectory/$problemId');
    if (!await problemDir.exists()) {
      await problemDir.create(recursive: true);
    }

    // Generate unique filename with timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filename = 'image_$timestamp.jpg';
    final file = File('${problemDir.path}/$filename');

    await file.writeAsBytes(imageBytes);
    return file.path;
  }

  /// Delete an image file
  /// 
  /// Returns true if deletion succeeded, false if file doesn't exist
  Future<bool> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get the directory path for a problem's images
  /// 
  /// Note: Directory may not exist yet
  String getImagePath(String problemId) {
    return '$baseDirectory/$problemId';
  }

  /// List all image files for a problem
  /// 
  /// Returns empty list if directory doesn't exist
  Future<List<String>> listImagesForProblem(String problemId) async {
    try {
      final problemDir = Directory('$baseDirectory/$problemId');
      if (!await problemDir.exists()) {
        return <String>[];
      }

      final files = await problemDir.list().toList();
      final imageFiles = files
          .whereType<File>()
          .where((file) => _isImageFile(file.path))
          .map((file) => file.path)
          .toList();

      // Sort by filename (which includes timestamp)
      imageFiles.sort();
      return imageFiles;
    } catch (e) {
      return <String>[];
    }
  }

  /// Delete all images for a problem
  /// 
  /// Returns true if all deletions succeeded
  Future<bool> deleteAllImagesForProblem(String problemId) async {
    try {
      final problemDir = Directory('$baseDirectory/$problemId');
      if (await problemDir.exists()) {
        await problemDir.delete(recursive: true);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check if file is an image based on extension
  static bool _isImageFile(String path) {
    final ext = path.toLowerCase().split('.').last;
    return <String>{'jpg', 'jpeg', 'png', 'gif', 'webp'}.contains(ext);
  }
}

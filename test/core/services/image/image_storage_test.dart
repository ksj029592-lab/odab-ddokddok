import 'package:flutter_test/flutter_test.dart';
import 'package:odab_ddokddok/core/services/image/image_storage.dart';
import 'dart:io';
import 'dart:typed_data';

void main() {
  group('ImageStorageService', () {
    late ImageStorageService service;
    late Directory testDir;

    setUp(() async {
      // Create a temporary directory for testing
      final tempDir = Directory.systemTemp;
      testDir = await tempDir.createTemp('image_storage_test_');
      service = ImageStorageService(baseDirectory: testDir.path);
    });

    tearDown(() async {
      if (await testDir.exists()) {
        await testDir.delete(recursive: true);
      }
    });

    group('saveImage', () {
      test('saves image file and returns path', () async {
        // Create a test image file (1x1 PNG)
        final testImageBytes = <int>[
          137, 80, 78, 71, 13, 10, 26, 10, // PNG signature
          0, 0, 0, 13, // IHDR chunk size
          73, 72, 68, 82, // IHDR
          0, 0, 0, 1, 0, 0, 0, 1, // 1x1 size
          8, 2, 0, 0, 0, 144, 119, 83, 222, // color type, etc
          0, 0, 0, 12, // IDAT chunk size
          73, 68, 65, 84, // IDAT
          120, 156, 99, 248, 15, 0, 0, 1, 1, 1, 0, 24, 24, 0, 26,
          0, 0, 0, 0, // IDAT data
          73, 69, 78, 68, 174, 66, 96, 130, // IEND
        ];

        final result = await service.saveImage(
          imageBytes: Uint8List.fromList(testImageBytes),
          problemId: 'test-problem-1',
        );

        expect(result, isNotNull);
        expect(result.contains('test-problem-1'), isTrue);
        expect(File(result).existsSync(), isTrue);
      });

      test('creates unique filename for same problem', () async {
        final testImageBytes = <int>[
          137, 80, 78, 71, 13, 10, 26, 10,
          0, 0, 0, 13,
          73, 72, 68, 82,
          0, 0, 0, 1, 0, 0, 0, 1,
          8, 2, 0, 0, 0, 144, 119, 83, 222,
          0, 0, 0, 12,
          73, 68, 65, 84,
          120, 156, 99, 248, 15, 0, 0, 1, 1, 1, 0, 24, 24, 0, 26,
          0, 0, 0, 0,
          73, 69, 78, 68, 174, 66, 96, 130,
        ];

        final path1 = await service.saveImage(
          imageBytes: Uint8List.fromList(testImageBytes),
          problemId: 'test-problem-2',
        );

        final path2 = await service.saveImage(
          imageBytes: Uint8List.fromList(testImageBytes),
          problemId: 'test-problem-2',
        );

        expect(path1, isNotNull);
        expect(path2, isNotNull);
        expect(path1 != path2, isTrue); // Different files
      });

      test('handles empty image bytes gracefully', () async {
        expect(
          () => service.saveImage(
            imageBytes: Uint8List.fromList([]),
            problemId: 'test-problem-3',
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('deleteImage', () {
      test('deletes existing image file', () async {
        final testImageBytes = <int>[
          137, 80, 78, 71, 13, 10, 26, 10,
          0, 0, 0, 13,
          73, 72, 68, 82,
          0, 0, 0, 1, 0, 0, 0, 1,
          8, 2, 0, 0, 0, 144, 119, 83, 222,
          0, 0, 0, 12,
          73, 68, 65, 84,
          120, 156, 99, 248, 15, 0, 0, 1, 1, 1, 0, 24, 24, 0, 26,
          0, 0, 0, 0,
          73, 69, 78, 68, 174, 66, 96, 130,
        ];

        final path = await service.saveImage(
          imageBytes: Uint8List.fromList(testImageBytes),
          problemId: 'test-delete-1',
        );

        expect(File(path).existsSync(), isTrue);

        final deleted = await service.deleteImage(path);

        expect(deleted, isTrue);
        expect(File(path).existsSync(), isFalse);
      });

      test('returns false for non-existent file', () async {
        final deleted = await service.deleteImage('/non/existent/path.jpg');
        expect(deleted, isFalse);
      });
    });

    group('getImagePath', () {
      test('returns valid path for saved image', () async {
        final testImageBytes = <int>[
          137, 80, 78, 71, 13, 10, 26, 10,
          0, 0, 0, 13,
          73, 72, 68, 82,
          0, 0, 0, 1, 0, 0, 0, 1,
          8, 2, 0, 0, 0, 144, 119, 83, 222,
          0, 0, 0, 12,
          73, 68, 65, 84,
          120, 156, 99, 248, 15, 0, 0, 1, 1, 1, 0, 24, 24, 0, 26,
          0, 0, 0, 0,
          73, 69, 78, 68, 174, 66, 96, 130,
        ];

          await service.saveImage(
          imageBytes: Uint8List.fromList(testImageBytes),
          problemId: 'test-path-1',
        );

        final retrievedPath = service.getImagePath('test-path-1');
        
        // The returned path should be retrievable
        expect(retrievedPath, isNotNull);
        expect(retrievedPath.contains('test-path-1'), isTrue);
      });
    });

    group('listImagesForProblem', () {
      test('returns list of image paths for problem', () async {
        final testImageBytes = <int>[
          137, 80, 78, 71, 13, 10, 26, 10,
          0, 0, 0, 13,
          73, 72, 68, 82,
          0, 0, 0, 1, 0, 0, 0, 1,
          8, 2, 0, 0, 0, 144, 119, 83, 222,
          0, 0, 0, 12,
          73, 68, 65, 84,
          120, 156, 99, 248, 15, 0, 0, 1, 1, 1, 0, 24, 24, 0, 26,
          0, 0, 0, 0,
          73, 69, 78, 68, 174, 66, 96, 130,
        ];

        await service.saveImage(
          imageBytes: Uint8List.fromList(testImageBytes),
          problemId: 'test-list-1',
        );

        await service.saveImage(
          imageBytes: Uint8List.fromList(testImageBytes),
          problemId: 'test-list-1',
        );

        final images = await service.listImagesForProblem('test-list-1');

        expect(images, isNotEmpty);
        expect(images.length, 2);
      });

      test('returns empty list for problem with no images', () async {
        final images = await service.listImagesForProblem('nonexistent');
        expect(images, isEmpty);
      });
    });
  });
}

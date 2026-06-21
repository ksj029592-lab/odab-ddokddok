import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odab_ddokddok/features/scan/application/gallery_image_picker_service.dart';

class _FakeImagePickerClient implements ImagePickerClient {
  _FakeImagePickerClient(this._result);

  final XFile? _result;
  int calls = 0;

  @override
  Future<XFile?> pickImageFromGallery() async {
    calls += 1;
    return _result;
  }
}

void main() {
  group('GalleryImagePickerService', () {
    test('선택한 이미지 경로를 반환한다', () async {
      final fakeClient = _FakeImagePickerClient(XFile('/tmp/paper1.jpg'));
      final service = GalleryImagePickerService(client: fakeClient);

      final path = await service.pickSingleImagePath();

      expect(path, '/tmp/paper1.jpg');
      expect(fakeClient.calls, 1);
    });

    test('선택 취소 시 null을 반환한다', () async {
      final fakeClient = _FakeImagePickerClient(null);
      final service = GalleryImagePickerService(client: fakeClient);

      final path = await service.pickSingleImagePath();

      expect(path, isNull);
      expect(fakeClient.calls, 1);
    });
  });
}

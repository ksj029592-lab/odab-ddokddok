import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odab_ddokddok/features/scan/application/gallery_image_picker_service.dart';
import 'package:odab_ddokddok/features/scan/presentation/scan_screen.dart';
import 'dart:typed_data';

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
  XFile fakeImageFile(String path) {
    return XFile.fromData(
      Uint8List.fromList(<int>[0x89, 0x50, 0x4E, 0x47]),
      path: path,
      mimeType: 'image/png',
      name: 'picked.png',
    );
  }

  group('ScanScreen', () {
    testWidgets('초기 상태에서 선택된 이미지 없음 표시', (WidgetTester tester) async {
      final fakeClient = _FakeImagePickerClient(null);
      final service = GalleryImagePickerService(client: fakeClient);

      await tester.pumpWidget(
        MaterialApp(home: ScanScreen(galleryService: service)),
      );

      expect(find.text('갤러리에서 가져오기'), findsOneWidget);
      expect(find.text('선택된 이미지 없음'), findsOneWidget);
    });

    testWidgets('갤러리 선택 성공 시 경로를 표시', (WidgetTester tester) async {
      final fakeClient = _FakeImagePickerClient(fakeImageFile('/tmp/math_problem.jpg'));
      final service = GalleryImagePickerService(client: fakeClient);

      await tester.pumpWidget(
        MaterialApp(home: ScanScreen(galleryService: service)),
      );

      await tester.tap(find.text('갤러리에서 가져오기'));
      await tester.pumpAndSettle();

      expect(fakeClient.calls, 1);
      expect(find.byKey(const Key('selected-image-path')), findsOneWidget);
      expect(find.text('/tmp/math_problem.jpg'), findsOneWidget);
    });

    testWidgets('갤러리 선택 취소 시 빈 상태 유지', (WidgetTester tester) async {
      final fakeClient = _FakeImagePickerClient(null);
      final service = GalleryImagePickerService(client: fakeClient);

      await tester.pumpWidget(
        MaterialApp(home: ScanScreen(galleryService: service)),
      );

      await tester.tap(find.text('갤러리에서 가져오기'));
      await tester.pumpAndSettle();

      expect(fakeClient.calls, 1);
      expect(find.text('선택된 이미지 없음'), findsOneWidget);
    });

    testWidgets('이미지 선택 전에는 원근 보정 버튼이 비활성화된다', (WidgetTester tester) async {
      final fakeClient = _FakeImagePickerClient(null);
      final service = GalleryImagePickerService(client: fakeClient);

      await tester.pumpWidget(
        MaterialApp(home: ScanScreen(galleryService: service)),
      );

      final button = tester.widget<OutlinedButton>(find.widgetWithText(OutlinedButton, '원근 보정 적용'));
      expect(button.onPressed, isNull);
    });

    testWidgets('이미지 선택 후 원근 보정 버튼이 활성화된다', (WidgetTester tester) async {
      final fakeClient = _FakeImagePickerClient(fakeImageFile('/tmp/picked.jpg'));
      final galleryService = GalleryImagePickerService(client: fakeClient);

      await tester.pumpWidget(
        MaterialApp(home: ScanScreen(galleryService: galleryService)),
      );

      await tester.tap(find.text('갤러리에서 가져오기'));
      await tester.pumpAndSettle();

      final button = tester.widget<OutlinedButton>(find.widgetWithText(OutlinedButton, '원근 보정 적용'));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('이미지 선택 후 수동 크롭 핸들과 회전 UI를 표시한다', (WidgetTester tester) async {
      final fakeClient = _FakeImagePickerClient(fakeImageFile('/tmp/picked.jpg'));
      final galleryService = GalleryImagePickerService(client: fakeClient);

      await tester.pumpWidget(
        MaterialApp(home: ScanScreen(galleryService: galleryService)),
      );

      await tester.tap(find.text('갤러리에서 가져오기'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('crop-handle-top-left')), findsOneWidget);
      expect(find.byKey(const Key('crop-handle-top-right')), findsOneWidget);
      expect(find.byKey(const Key('crop-handle-bottom-right')), findsOneWidget);
      expect(find.byKey(const Key('crop-handle-bottom-left')), findsOneWidget);
      expect(find.byKey(const Key('crop-rotate-button')), findsOneWidget);

      expect(find.text('회전: 0°'), findsOneWidget);
      await tester.tap(find.byKey(const Key('crop-rotate-button')));
      await tester.pump();
      expect(find.text('회전: 90°'), findsOneWidget);
    });
  });
}

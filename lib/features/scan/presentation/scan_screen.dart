import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:odab_ddokddok/core/services/image/perspective_corrector.dart';
import 'package:odab_ddokddok/features/scan/application/gallery_image_picker_service.dart';
import 'package:odab_ddokddok/features/scan/presentation/widgets/manual_crop_editor.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({
    super.key,
    GalleryImagePickerService? galleryService,
    PerspectiveCorrectorService? perspectiveCorrector,
  })  : _galleryService = galleryService,
        _perspectiveCorrector = perspectiveCorrector;

  final GalleryImagePickerService? _galleryService;
  final PerspectiveCorrectorService? _perspectiveCorrector;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late final GalleryImagePickerService _galleryService;
  late final PerspectiveCorrectorService _perspectiveCorrector;
  String? _selectedImagePath;
  Uint8List? _selectedImageBytes;
  String? _statusMessage;
  CropPoints _cropPoints = CropPoints.initial();
  int _quarterTurns = 0;

  @override
  void initState() {
    super.initState();
    _galleryService = widget._galleryService ??
        GalleryImagePickerService(client: DefaultImagePickerClient());
    _perspectiveCorrector = widget._perspectiveCorrector ??
        PerspectiveCorrectorService(
          engine: PassthroughPerspectiveCorrectionEngine(),
        );
  }

  Future<void> _pickFromGallery() async {
    final PickedImageData? selected = await _galleryService.pickSingleImage();
    if (!mounted) {
      return;
    }

    final Uint8List? selectedBytes = selected == null || selected.bytes.isEmpty
        ? null
        : selected.bytes;

    setState(() {
      _selectedImagePath = selected?.path;
      _selectedImageBytes = selectedBytes;
      _statusMessage = selected == null
          ? null
          : (selectedBytes == null ? '선택한 이미지 데이터를 읽지 못했어요' : null);
      _cropPoints = CropPoints.initial();
      _quarterTurns = 0;
    });
  }

  Future<void> _captureFromCamera() async {
    if (kIsWeb) {
      setState(() {
        _statusMessage = '웹 환경에서는 카메라 촬영이 지원되지 않습니다';
      });
      return;
    }

    // 카메라 권한 요청
    final PermissionStatus status = await Permission.camera.request();

    if (!mounted) {
      return;
    }

    if (status.isDenied) {
      setState(() {
        _statusMessage = '카메라 권한이 거부되었습니다';
      });
      return;
    }

    if (status.isPermanentlyDenied) {
      setState(() {
        _statusMessage = '카메라 권한이 영구적으로 거부되었습니다. 설정에서 허용해주세요';
      });
      openAppSettings();
      return;
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);

      if (photo == null) {
        if (!mounted) {
          return;
        }
        setState(() {
          _statusMessage = '촬영이 취소되었습니다';
        });
        return;
      }

      final Uint8List imageBytes = await photo.readAsBytes();

      if (!mounted) {
        return;
      }

      setState(() {
        _selectedImagePath = photo.path;
        _selectedImageBytes = imageBytes;
        _statusMessage = null;
        _cropPoints = CropPoints.initial();
        _quarterTurns = 0;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _statusMessage = '카메라 촬영 중 오류가 발생했습니다';
      });
    }
  }

  Future<void> _applyPerspectiveCorrection() async {
    if (_selectedImagePath == null) {
      return;
    }

    if (kIsWeb) {
      setState(() {
        _statusMessage = '웹에서는 원근 보정을 지원하지 않아요';
      });
      return;
    }

    final File selectedFile = File(_selectedImagePath!);
    if (!await selectedFile.exists()) {
      if (!mounted) {
        return;
      }
      setState(() {
        _statusMessage = '이미지 파일을 찾을 수 없어요';
      });
      return;
    }

    final Uint8List bytes = await selectedFile.readAsBytes();
    final result = await _perspectiveCorrector.correct(bytes);

    if (!mounted) {
      return;
    }

    if (result.fallbackUsed) {
      setState(() {
        _statusMessage = '원근 보정 실패: 원본을 사용해요';
      });
      return;
    }

    final String correctedPath = _selectedImagePath!.replaceFirst(RegExp(r'\.(jpg|jpeg|png)$', caseSensitive: false), '_corrected.jpg');
    final File correctedFile = File(correctedPath);
    await correctedFile.writeAsBytes(result.correctedBytes, flush: true);

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedImagePath = correctedPath;
      _statusMessage = '원근 보정 완료 (${result.processingTimeMs}ms)';
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImage = _selectedImageBytes != null || _selectedImagePath != null;
    final Widget previewImage = _selectedImageBytes != null
        ? Image.memory(
            _selectedImageBytes!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Text('미리보기를 불러올 수 없어요'),
              );
            },
          )
        : kIsWeb
        ? Image.network(
            _selectedImagePath ?? '',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Text('미리보기를 불러올 수 없어요'),
              );
            },
          )
        : Image.file(
            File(_selectedImagePath ?? ''),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Text('미리보기를 불러올 수 없어요'),
              );
            },
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('스캔'),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: '메인으로 돌아가기',
          onPressed: () => context.go('/'),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFF8FAFC), Color(0xFFE6FFFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: const Color(0xFF0F766E),
                ),
                child: const Text(
                  '문제를 촬영하거나 갤러리에서 선택하세요',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (kIsWeb)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF93C5FD)),
                  ),
                  child: const Text(
                    'ℹ️ 웹 환경에서는 촬영이 지원되지 않습니다. 갤러리에서 선택해주세요.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1E40AF),
                    ),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _captureFromCamera,
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('카메라로 촬영'),
                  ),
                ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickFromGallery,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('갤러리에서 가져오기'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _selectedImagePath == null ? null : _applyPerspectiveCorrection,
                  icon: const Icon(Icons.crop_free_outlined),
                  label: const Text('원근 보정 적용'),
                ),
              ),
              const SizedBox(height: 20),
              if (_statusMessage != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Text(
                    _statusMessage!,
                    key: const Key('scan-status-message'),
                  ),
                ),
              Expanded(
                child: hasImage
                    ? Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  '선택된 이미지',
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _selectedImagePath ?? '(경로 정보 없음)',
                                  key: const Key('selected-image-path'),
                                ),
                                const SizedBox(height: 12),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 400,
                                  ),
                                  child: ManualCropEditor(
                                    points: _cropPoints,
                                    onPointsChanged: (CropPoints next) {
                                      setState(() {
                                        _cropPoints = next;
                                      });
                                    },
                                    quarterTurns: _quarterTurns,
                                    onRotate: () {
                                      setState(() {
                                        _quarterTurns = (_quarterTurns + 1) % 4;
                                      });
                                    },
                                    background: previewImage,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const Center(child: Text('선택된 이미지 없음')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

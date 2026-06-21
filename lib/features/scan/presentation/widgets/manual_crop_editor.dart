import 'dart:math' as math;

import 'package:flutter/material.dart';

class CropPoints {
  const CropPoints({
    required this.topLeft,
    required this.topRight,
    required this.bottomRight,
    required this.bottomLeft,
  });

  final Offset topLeft;
  final Offset topRight;
  final Offset bottomRight;
  final Offset bottomLeft;

  factory CropPoints.initial() {
    return const CropPoints(
      topLeft: Offset(0.1, 0.1),
      topRight: Offset(0.9, 0.1),
      bottomRight: Offset(0.9, 0.9),
      bottomLeft: Offset(0.1, 0.9),
    );
  }

  CropPoints copyWith({
    Offset? topLeft,
    Offset? topRight,
    Offset? bottomRight,
    Offset? bottomLeft,
  }) {
    return CropPoints(
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      bottomRight: bottomRight ?? this.bottomRight,
      bottomLeft: bottomLeft ?? this.bottomLeft,
    );
  }
}

class ManualCropEditor extends StatelessWidget {
  const ManualCropEditor({
    super.key,
    required this.points,
    required this.onPointsChanged,
    required this.quarterTurns,
    required this.onRotate,
    this.height = 220,
    this.background,
  });

  final CropPoints points;
  final ValueChanged<CropPoints> onPointsChanged;
  final int quarterTurns;
  final VoidCallback onRotate;
  final double height;
  final Widget? background;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('회전: ${quarterTurns * 90}°', key: const Key('crop-rotation-text')),
            const Spacer(),
            IconButton(
              key: const Key('crop-rotate-button'),
              onPressed: onRotate,
              icon: const Icon(Icons.rotate_90_degrees_cw),
              tooltip: '90도 회전',
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double width = constraints.maxWidth;
            return SizedBox(
              key: const Key('manual-crop-canvas'),
              height: height,
              width: width,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: background ?? const ColoredBox(color: Color(0xFFF8FAFC)),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _CropGuidePainter(points: points),
                    ),
                  ),
                  _buildHandle(
                    keyName: 'crop-handle-top-left',
                    canvasWidth: width,
                    canvasHeight: height,
                    normalizedPoint: points.topLeft,
                    onDrag: (Offset p) => onPointsChanged(points.copyWith(topLeft: p)),
                  ),
                  _buildHandle(
                    keyName: 'crop-handle-top-right',
                    canvasWidth: width,
                    canvasHeight: height,
                    normalizedPoint: points.topRight,
                    onDrag: (Offset p) => onPointsChanged(points.copyWith(topRight: p)),
                  ),
                  _buildHandle(
                    keyName: 'crop-handle-bottom-right',
                    canvasWidth: width,
                    canvasHeight: height,
                    normalizedPoint: points.bottomRight,
                    onDrag: (Offset p) => onPointsChanged(points.copyWith(bottomRight: p)),
                  ),
                  _buildHandle(
                    keyName: 'crop-handle-bottom-left',
                    canvasWidth: width,
                    canvasHeight: height,
                    normalizedPoint: points.bottomLeft,
                    onDrag: (Offset p) => onPointsChanged(points.copyWith(bottomLeft: p)),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHandle({
    required String keyName,
    required double canvasWidth,
    required double canvasHeight,
    required Offset normalizedPoint,
    required ValueChanged<Offset> onDrag,
  }) {
    const double handleSize = 20;
    final double left = normalizedPoint.dx * canvasWidth - handleSize / 2;
    final double top = normalizedPoint.dy * canvasHeight - handleSize / 2;

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        key: Key(keyName),
        onPanUpdate: (DragUpdateDetails details) {
          final double nextDx = (left + details.delta.dx + handleSize / 2) / canvasWidth;
          final double nextDy = (top + details.delta.dy + handleSize / 2) / canvasHeight;
          onDrag(Offset(_clamp01(nextDx), _clamp01(nextDy)));
        },
        child: Container(
          width: handleSize,
          height: handleSize,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue, width: 2),
            boxShadow: const <BoxShadow>[
              BoxShadow(color: Colors.black26, blurRadius: 3),
            ],
          ),
        ),
      ),
    );
  }

  double _clamp01(double value) => math.max(0, math.min(1, value));
}

class _CropGuidePainter extends CustomPainter {
  _CropGuidePainter({required this.points});

  final CropPoints points;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Path path = Path()
      ..moveTo(points.topLeft.dx * size.width, points.topLeft.dy * size.height)
      ..lineTo(points.topRight.dx * size.width, points.topRight.dy * size.height)
      ..lineTo(points.bottomRight.dx * size.width, points.bottomRight.dy * size.height)
      ..lineTo(points.bottomLeft.dx * size.width, points.bottomLeft.dy * size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CropGuidePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

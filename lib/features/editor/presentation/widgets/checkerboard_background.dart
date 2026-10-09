import 'package:flutter/material.dart';

class CheckerboardBackground extends StatelessWidget {
  const CheckerboardBackground({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _CheckerboardPainter(), child: child);
  }
}

class _CheckerboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const tileSize = 16.0;

    final lightPaint = Paint()..color = const Color(0xFFEEF0F4);
    final darkPaint = Paint()..color = const Color(0xFFD8DCE3);

    for (double y = 0; y < size.height; y += tileSize) {
      for (double x = 0; x < size.width; x += tileSize) {
        final column = (x / tileSize).floor();
        final row = (y / tileSize).floor();

        canvas.drawRect(
          Rect.fromLTWH(x, y, tileSize, tileSize),
          (row + column).isEven ? lightPaint : darkPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

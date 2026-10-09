import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

enum EditorBackdrop { checkerboard, white, dark, green }

class BackdropSelector extends StatelessWidget {
  const BackdropSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final EditorBackdrop selected;
  final ValueChanged<EditorBackdrop> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _BackdropOption(
            label: 'Auto',
            backdrop: EditorBackdrop.checkerboard,
            selected: selected,
            onChanged: onChanged,
            child: const _CheckerPreview(),
          ),
          _BackdropOption(
            label: 'White',
            backdrop: EditorBackdrop.white,
            selected: selected,
            onChanged: onChanged,
            child: const ColoredBox(color: Colors.white),
          ),
          _BackdropOption(
            label: 'Dark',
            backdrop: EditorBackdrop.dark,
            selected: selected,
            onChanged: onChanged,
            child: const ColoredBox(color: Color(0xFF111827)),
          ),
          _BackdropOption(
            label: 'Green',
            backdrop: EditorBackdrop.green,
            selected: selected,
            onChanged: onChanged,
            child: const ColoredBox(color: Color(0xFF22C55E)),
          ),
        ],
      ),
    );
  }
}

class _BackdropOption extends StatelessWidget {
  const _BackdropOption({
    required this.label,
    required this.backdrop,
    required this.selected,
    required this.onChanged,
    required this.child,
  });

  final String label;
  final EditorBackdrop backdrop;
  final EditorBackdrop selected;
  final ValueChanged<EditorBackdrop> onChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isSelected = backdrop == selected;

    return GestureDetector(
      onTap: () => onChanged(backdrop),
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: AppTheme.radiusSmall,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryBlue
                      : AppTheme.surfaceBorder,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: child,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? AppTheme.textPrimary : AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckerPreview extends StatelessWidget {
  const _CheckerPreview();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _MiniCheckerPainter());
  }
}

class _MiniCheckerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const tile = 8.0;

    final light = Paint()..color = const Color(0xFFEEF0F4);
    final dark = Paint()..color = const Color(0xFFD8DCE3);

    for (double y = 0; y < size.height; y += tile) {
      for (double x = 0; x < size.width; x += tile) {
        final row = (y / tile).floor();
        final column = (x / tile).floor();

        canvas.drawRect(
          Rect.fromLTWH(x, y, tile, tile),
          (row + column).isEven ? light : dark,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

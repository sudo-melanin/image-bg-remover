import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class EditorTopBar extends StatelessWidget {
  const EditorTopBar({
    required this.onClose,
    required this.onUndo,
    required this.onRedo,
    required this.onDone,
    super.key,
  });

  final VoidCallback onClose;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _EditorAction(icon: Icons.close, onPressed: onClose),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'Editor',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ),
        _EditorAction(icon: Icons.undo, onPressed: onUndo),
        const SizedBox(width: 8),
        _EditorAction(icon: Icons.redo, onPressed: onRedo),
        const SizedBox(width: 8),
        _EditorAction(icon: Icons.check, onPressed: onDone, highlighted: true),
      ],
    );
  }
}

class _EditorAction extends StatelessWidget {
  const _EditorAction({
    required this.icon,
    required this.onPressed,
    this.highlighted = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        gradient: highlighted ? AppTheme.primaryGradient : null,
        color: highlighted ? null : AppTheme.surfaceCard,
        borderRadius: AppTheme.radiusSmall,
        border: highlighted ? null : Border.all(color: AppTheme.surfaceBorder),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 20,
          color: highlighted ? Colors.white : AppTheme.textSecondary,
        ),
      ),
    );
  }
}

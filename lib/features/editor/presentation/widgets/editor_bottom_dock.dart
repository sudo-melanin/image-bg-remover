import 'package:bg_remover/core/widgets/gradient_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class EditorBottomDock extends StatelessWidget {
  const EditorBottomDock({
    required this.onBack,
    required this.onRemoveBackground,
    required this.onSave,
    required this.onShare,
    required this.isLoading,
    required this.hasRemovedBackground,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onRemoveBackground;
  final VoidCallback onShare;
  final VoidCallback onSave;
  final bool isLoading;
  final bool hasRemovedBackground;

  @override
  @override
Widget build(BuildContext context) {
  return Row(
  children: [
    _DockAction(
      icon: Icons.arrow_back,
      label: 'Back',
      onPressed: isLoading ? null : onBack,
    ),
    const SizedBox(width: 8),
    if (!hasRemovedBackground)
      Expanded(
        child: GradientButton(
          label: 'Remove Background',
          icon: Icons.auto_fix_high,
          onPressed: isLoading ? null : onRemoveBackground,
          isLoading: isLoading,
        ),
      )
    else
      Expanded(
        child: GradientButton(
          label: 'Save',
          icon: Icons.download_outlined,
          onPressed: isLoading ? null : onSave,
        ),
      ),
    if (hasRemovedBackground) ...[
      const SizedBox(width: 8),
      _DockAction(
        icon: Icons.share_outlined,
        label: 'Share',
        onPressed: isLoading ? null : onShare,
      ),
    ],
  ],
);
}
}

class _DockAction extends StatelessWidget {
  const _DockAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: AppTheme.radiusSmall,
              border: Border.all(
                color: AppTheme.surfaceBorder,
              ),
            ),
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(icon, size: 19),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
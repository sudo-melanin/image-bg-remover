import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class EditorBottomDock extends StatelessWidget {
  const EditorBottomDock({
    required this.onBack,
    required this.onRemoveBackground,
    required this.onShare,
    required this.isLoading,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onRemoveBackground;
  final VoidCallback onShare;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _DockAction(
          icon: Icons.arrow_back,
          label: 'Back',
          onPressed: isLoading ? null : onBack,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: AppTheme.radiusMedium,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLoading ? null : onRemoveBackground,
                borderRadius: AppTheme.radiusMedium,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isLoading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      else
                        const Icon(Icons.auto_fix_high),
                      const SizedBox(width: 8),
                      Text(
                        isLoading
                            ? 'Processing...'
                            : 'Remove Background',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _DockAction(
          icon: Icons.share_outlined,
          label: 'Share',
          onPressed: onShare,
        ),
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
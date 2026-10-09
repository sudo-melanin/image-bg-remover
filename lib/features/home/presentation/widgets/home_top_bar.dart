import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: AppTheme.radiusSmall,
          ),
          child: const Icon(Icons.auto_fix_high, color: Colors.white),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Background',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              Text(
                'Remover Pro',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
        _TopBarAction(icon: Icons.history),
        const SizedBox(width: 8),
        _TopBarAction(icon: Icons.light_mode),
        const SizedBox(width: 8),
        _TopBarAction(icon: Icons.settings),
      ],
    );
  }
}

class _TopBarAction extends StatelessWidget {
  const _TopBarAction({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: AppTheme.radiusSmall,
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Icon(icon, size: 19, color: AppTheme.textSecondary),
    );
  }
}

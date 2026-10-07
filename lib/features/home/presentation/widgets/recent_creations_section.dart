import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class RecentCreationsSection extends StatelessWidget {
  const RecentCreationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Creations',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Your recent background removals will appear here.',
          style: TextStyle(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
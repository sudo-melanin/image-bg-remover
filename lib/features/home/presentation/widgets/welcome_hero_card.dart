import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class WelcomeHeroCard extends StatelessWidget {
  const WelcomeHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1D2E), Color(0xFF16192B)],
        ),
        borderRadius: AppTheme.radiusLarge,
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '👋 Welcome back!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8),
          Text(
            'Start by selecting an image and let AI remove the background for you.',
            style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/recent_creation.dart';

class RecentCreationsSection extends StatelessWidget {
  const RecentCreationsSection({
    required this.creations,
    required this.onCreationTap,
    super.key,
  });

  final List<RecentCreation> creations;
  final ValueChanged<RecentCreation> onCreationTap;

  @override
  Widget build(BuildContext context) {
    if (creations.isEmpty) {
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
            'Your processed images will appear here.',
            style: TextStyle(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Creations',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: creations.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final creation = creations[index];

            return GestureDetector(
              onTap: () => onCreationTap(creation),
              child: ClipRRect(
                borderRadius: AppTheme.radiusMedium,
                child: Container(
                  color: AppTheme.surfaceElevated,
                  child: Image.memory(
                    creation.previewBytes,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
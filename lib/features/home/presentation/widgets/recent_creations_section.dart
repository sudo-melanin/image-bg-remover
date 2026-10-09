import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/recent_creation.dart';

class RecentCreationsSection extends StatelessWidget {
  const RecentCreationsSection({
    required this.creations,
    required this.onCreationTap,
    required this.onDeleteCreation,
    super.key,
  });

  final List<RecentCreation> creations;
  final ValueChanged<RecentCreation> onCreationTap;
  final ValueChanged<RecentCreation> onDeleteCreation;

  @override
  Widget build(BuildContext context) {
    if (creations.isEmpty) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Creations',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 12),
          Text(
            'Your processed images will appear here.',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Creations',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: creations.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final creation = creations[index];

            return ClipRRect(
              borderRadius: AppTheme.radiusMedium,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Material(
                    color: AppTheme.surfaceElevated,
                    child: InkWell(
                      onTap: () => onCreationTap(creation),
                      child: Image.memory(
                        creation.previewBytes,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Material(
                      color: Colors.black54,
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: 'Remove from Recent Creations',
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.cancel_sharp,
                          color: Colors.white,
                          size: 16,
                        ),
                        onPressed: () => onDeleteCreation(creation),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

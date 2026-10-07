import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/gradient_button.dart';

class ImageUploadWorkspace extends StatelessWidget {
  const ImageUploadWorkspace({
    required this.imageBytes,
    required this.onPickImage,
    required this.onOpenEditor,
    super.key,
  });

  final Uint8List? imageBytes;
  final VoidCallback onPickImage;
  final VoidCallback onOpenEditor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: AppTheme.radiusLarge,
        border: Border.all(
          color: AppTheme.surfaceBorder,
        ),
      ),
      child: imageBytes == null
          ? _EmptyState(
              onPickImage: onPickImage,
            )
          : _SelectedState(
              imageBytes: imageBytes!,
              onPickImage: onPickImage,
              onOpenEditor: onOpenEditor,
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.onPickImage,
  });

  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppTheme.surfaceElevated,
            borderRadius: AppTheme.radiusMedium,
          ),
          child: const Icon(
            Icons.add_photo_alternate_outlined,
            size: 34,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Select an image to start',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose a photo from your device gallery.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: GradientButton(
            label: 'Select Image',
            icon: Icons.add_photo_alternate_outlined,
            onPressed: onPickImage,
          ),
        ),
      ],
    );
  }
}

class _SelectedState extends StatelessWidget {
  const _SelectedState({
    required this.imageBytes,
    required this.onPickImage,
    required this.onOpenEditor,
  });

  final Uint8List imageBytes;
  final VoidCallback onPickImage;
  final VoidCallback onOpenEditor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: AppTheme.radiusMedium,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: AppTheme.surfaceElevated,
              child: Image.memory(
                imageBytes,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: GradientButton(
            label: 'Open Editor',
            icon: Icons.auto_fix_high,
            onPressed: onOpenEditor,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onPickImage,
            icon: const Icon(Icons.swap_horiz),
            label: const Text('Choose Another Image'),
          ),
        ),
      ],
    );
  }
}
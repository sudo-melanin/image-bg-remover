import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/background_removal/background_removal_service.dart';
import '../../../services/media/recent_creations_storage.dart';
import '../../editor/presentation/editor_screen.dart';
import '../domain/recent_creation.dart';
import 'widgets/home_top_bar.dart';
import 'widgets/image_upload_workspace.dart';
import 'widgets/recent_creations_section.dart';
import 'widgets/welcome_hero_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  final BackgroundRemovalService _removalService = BackgroundRemovalService();

  final RecentCreationsStorage _storage = RecentCreationsStorage();

  final List<RecentCreation> _recentCreations = [];

  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _loadRecentCreations();
  }

  Future<void> _loadRecentCreations() async {
    try {
      final creations = await _storage.loadAll();

      if (!mounted) return;

      setState(() {
        _recentCreations
          ..clear()
          ..addAll(creations);
      });
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load recent creations.')),
      );
    }
  }

  Future<void> _persistRecentCreations() async {
    try {
      final creations = await _storage.saveAll(
        List<RecentCreation>.of(_recentCreations),
      );

      if (!mounted) return;

      setState(() {
        _recentCreations
          ..clear()
          ..addAll(creations);
      });
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save recent creations on this device.'),
        ),
      );
    }
  }

  Future<void> _confirmDeleteCreation(RecentCreation creation) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete recent creation?'),
          content: const Text(
            'This will remove the image from Recent Creations '
            'on this device. Images already saved to your gallery '
            'will not be deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    // Dismissing the dialog or choosing Cancel does nothing.
    if (shouldDelete != true || !mounted) return;

    try {
      await _storage.deleteCreation(creation.id);

      if (!mounted) return;

      setState(() {
        _recentCreations.removeWhere((item) => item.id == creation.id);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Recent creation deleted.')));
    } catch (error) {
      debugPrint('Could not delete recent creation: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not delete the recent creation.')),
      );
    }
  }

  Future<void> _pickImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final bytes = await image.readAsBytes();

    if (!mounted) return;

    setState(() {
      _imageBytes = bytes;
    });
  }

  Future<void> _openEditor() async {
    if (_imageBytes == null) return;

    final originalBytes = _imageBytes!;

    final result = await Navigator.of(context).push<RecentCreation>(
      MaterialPageRoute(
        builder: (_) => EditorScreen(
          imageBytes: originalBytes,
          onRemoveBackground: () async {
            final bytes = await _removalService.removeBackground(originalBytes);

            return Uint8List.fromList(bytes);
          },
        ),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      _imageBytes = result.imageBytes;
      _recentCreations.insert(0, result);
    });

    await _persistRecentCreations();
  }

  Future<void> _openRecentCreation(RecentCreation creation) async {
    final result = await Navigator.of(context).push<RecentCreation>(
      MaterialPageRoute(
        builder: (_) => EditorScreen(
          imageBytes: creation.imageBytes,
          isProcessed: true,
          initialBackdrop: creation.backdrop,
          onRemoveBackground: () async {
            final bytes = await _removalService.removeBackground(
              creation.imageBytes,
            );

            return Uint8List.fromList(bytes);
          },
        ),
      ),
    );

    if (!mounted || result == null) return;

    final updatedCreation = result.copyWith(id: creation.id);

    setState(() {
      _imageBytes = updatedCreation.imageBytes;

      _recentCreations.removeWhere((item) => item.id == creation.id);

      _recentCreations.insert(0, updatedCreation);
    });

    await _persistRecentCreations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeTopBar(),
              const SizedBox(height: 24),
              const WelcomeHeroCard(),
              const SizedBox(height: 20),
              ImageUploadWorkspace(
                imageBytes: _imageBytes,
                onPickImage: _pickImage,
                onOpenEditor: _openEditor,
              ),
              const SizedBox(height: 28),
              RecentCreationsSection(
                creations: _recentCreations,
                onCreationTap: _openRecentCreation,
                onDeleteCreation: _confirmDeleteCreation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/background_removal/background_removal_service.dart';
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
  final BackgroundRemovalService _removalService =
      BackgroundRemovalService();

  Uint8List? _imageBytes;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();

    setState(() {
      _imageBytes = bytes;
    });
  }

  Future<void> _removeBackground() async {
    if (_imageBytes == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _removalService.removeBackground(
        _imageBytes!,
      );

      if (!mounted) return;

      setState(() {
        _imageBytes = Uint8List.fromList(result);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not remove the background.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                isLoading: _isLoading,
                onPickImage: _pickImage,
                onRemoveBackground: _removeBackground,
              ),
              const SizedBox(height: 28),
              const RecentCreationsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
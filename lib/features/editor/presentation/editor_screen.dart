
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../services/media/media_service.dart';
import '../../home/domain/recent_creation.dart';
import 'widgets/backdrop_selector.dart';
import 'widgets/checkerboard_background.dart';
import 'widgets/editor_bottom_dock.dart';
import 'widgets/editor_top_bar.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({
    required this.imageBytes,
    required this.onRemoveBackground,
    this.isProcessed = false,
    this.initialBackdrop = EditorBackdrop.checkerboard,
    super.key,
  });

  final Uint8List imageBytes;
  final Future<Uint8List> Function() onRemoveBackground;
  final bool isProcessed;
  final EditorBackdrop initialBackdrop;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late Uint8List _imageBytes;

  final MediaService _mediaService = MediaService();

  late EditorBackdrop _backdrop;
  bool _isLoading = false;
  bool _hasRemovedBackground = false;

  @override
  void initState() {
    super.initState();
    _imageBytes = widget.imageBytes;
    _backdrop = widget.initialBackdrop;
    _hasRemovedBackground = widget.isProcessed;
  }

  Color? get _solidBackdrop {
    switch (_backdrop) {
      case EditorBackdrop.white:
        return Colors.white;
      case EditorBackdrop.dark:
        return const Color(0xFF111827);
      case EditorBackdrop.green:
        return const Color(0xFF22C55E);
      case EditorBackdrop.checkerboard:
        return null;
    }
  }

  Future<Uint8List> _buildExportImage() async {
    final codec = await ui.instantiateImageCodec(_imageBytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final backdrop = _solidBackdrop;

    if (backdrop != null) {
      final paint = Paint()..color = backdrop;

      canvas.drawRect(
        Rect.fromLTWH(
          0,
          0,
          image.width.toDouble(),
          image.height.toDouble(),
        ),
        paint,
      );
    }

    canvas.drawImage(image, Offset.zero, Paint());

    final picture = recorder.endRecording();
    final outputImage = await picture.toImage(
      image.width,
      image.height,
    );

    final byteData = await outputImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    codec.dispose();
    image.dispose();
    picture.dispose();
    outputImage.dispose();

    if (byteData == null) {
      throw Exception('Could not prepare image for export.');
    }

    return byteData.buffer.asUint8List();
  }

  Future<void> _saveImage() async {
    try {
      final exportBytes = await _buildExportImage();
      final saved = await _mediaService.saveImage(exportBytes);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            saved
                ? 'Image saved to your gallery.'
                : 'Could not save the image.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save the image.'),
        ),
      );
    }
  }

  Future<void> _shareImage() async {
    try {
      final exportBytes = await _buildExportImage();
      await _mediaService.shareImage(exportBytes);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not share the image.'),
        ),
      );
    }
  }

  Future<void> _removeBackground() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await widget.onRemoveBackground();

      if (!mounted) return;

      setState(() {
        _imageBytes = result;
        _hasRemovedBackground = true;
      });
    } catch (_) {
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

  Future<void> _finishEditing() async {
    if (!_hasRemovedBackground || _isLoading) return;

    try {
      final exportBytes = await _buildExportImage();

      if (!mounted) return;

      Navigator.of(context).pop(
        RecentCreation(
          imageBytes: _imageBytes,
          previewBytes: exportBytes,
          backdrop: _backdrop,
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not prepare the image.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: Column(
            children: [
              EditorTopBar(
                onClose: () => Navigator.of(context).pop(),
                onUndo: () {},
                onRedo: () {},
                onDone: _finishEditing,
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Backdrop',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              BackdropSelector(
                selected: _backdrop,
                onChanged: (value) {
                  setState(() {
                    _backdrop = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: AppTheme.radiusLarge,
                    border: Border.all(
                      color: AppTheme.surfaceBorder,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _solidBackdrop == null
                      ? CheckerboardBackground(
                          child: Center(
                            child: InteractiveViewer(
                              minScale: 0.7,
                              maxScale: 4,
                              child: Image.memory(
                                _imageBytes,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                      : ColoredBox(
                          color: _solidBackdrop!,
                          child: Center(
                            child: InteractiveViewer(
                              minScale: 0.7,
                              maxScale: 4,
                              child: Image.memory(
                                _imageBytes,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              EditorBottomDock(
                onBack: () => Navigator.of(context).pop(),
                onRemoveBackground: _removeBackground,
                onSave: _saveImage,
                onShare: _shareImage,
                isLoading: _isLoading,
                hasRemovedBackground: _hasRemovedBackground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
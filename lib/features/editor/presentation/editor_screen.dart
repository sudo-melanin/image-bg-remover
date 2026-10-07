import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'widgets/backdrop_selector.dart';
import 'widgets/checkerboard_background.dart';
import 'widgets/editor_bottom_dock.dart';
import 'widgets/editor_top_bar.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({
    required this.imageBytes,
    required this.onRemoveBackground,
    super.key,
  });

  final Uint8List imageBytes;
  final Future<Uint8List> Function() onRemoveBackground;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late Uint8List _imageBytes;

  EditorBackdrop _backdrop = EditorBackdrop.checkerboard;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageBytes = widget.imageBytes;
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
                onDone: () => Navigator.of(context).pop(_imageBytes),
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
                onShare: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share will be connected next.'),
                    ),
                  );
                },
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
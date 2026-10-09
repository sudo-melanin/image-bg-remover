import 'dart:typed_data';

import '../../editor/presentation/widgets/backdrop_selector.dart';

class RecentCreation {
  const RecentCreation({
    this.id = '',
    required this.imageBytes,
    required this.previewBytes,
    required this.backdrop,
  });

  final String id;
  final Uint8List imageBytes;
  final Uint8List previewBytes;
  final EditorBackdrop backdrop;

  RecentCreation copyWith({
    String? id,
    Uint8List? imageBytes,
    Uint8List? previewBytes,
    EditorBackdrop? backdrop,
  }) {
    return RecentCreation(
      id: id ?? this.id,
      imageBytes: imageBytes ?? this.imageBytes,
      previewBytes: previewBytes ?? this.previewBytes,
      backdrop: backdrop ?? this.backdrop,
    );
  }
}

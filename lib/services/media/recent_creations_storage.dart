import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../features/editor/presentation/widgets/backdrop_selector.dart';
import '../../features/home/domain/recent_creation.dart';

class RecentCreationsStorage {
  Future<Directory> _getStorageDirectory() async {
    final appDirectory = await getApplicationDocumentsDirectory();

    final directory = Directory('${appDirectory.path}/recent_creations');

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
  }

  Future<List<RecentCreation>> loadAll() async {
    final directory = await _getStorageDirectory();
    final indexFile = File('${directory.path}/index.json');

    if (!await indexFile.exists()) {
      return [];
    }

    final decoded = jsonDecode(await indexFile.readAsString());

    if (decoded is! List) {
      throw const FormatException('Invalid recent creations index.');
    }

    final creations = <RecentCreation>[];

    for (final entry in decoded) {
      if (entry is! Map<String, dynamic>) continue;

      final id = entry['id'] as String?;
      final backdropName = entry['backdrop'] as String?;

      if (id == null || id.isEmpty) continue;

      final sourceFile = File('${directory.path}/${id}_source.png');
      final previewFile = File('${directory.path}/${id}_preview.png');

      if (!await sourceFile.exists() || !await previewFile.exists()) {
        continue;
      }

      final backdrop = EditorBackdrop.values.firstWhere(
        (value) => value.name == backdropName,
        orElse: () => EditorBackdrop.checkerboard,
      );

      creations.add(
        RecentCreation(
          id: id,
          imageBytes: await sourceFile.readAsBytes(),
          previewBytes: await previewFile.readAsBytes(),
          backdrop: backdrop,
        ),
      );
    }

    return creations;
  }

  Future<void> deleteCreation(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('Creation ID cannot be empty.');
    }

    final directory = await _getStorageDirectory();
    final indexFile = File('${directory.path}/index.json');

    if (await indexFile.exists()) {
      final decoded = jsonDecode(await indexFile.readAsString());

      if (decoded is! List) {
        throw const FormatException('Invalid recent creations index.');
      }

      final remainingEntries = decoded.where((entry) {
        return entry is! Map || entry['id'] != id;
      }).toList();

      await indexFile.writeAsString(jsonEncode(remainingEntries), flush: true);
    }

    final sourceFile = File('${directory.path}/${id}_source.png');
    final previewFile = File('${directory.path}/${id}_preview.png');

    if (await sourceFile.exists()) {
      await sourceFile.delete();
    }

    if (await previewFile.exists()) {
      await previewFile.delete();
    }
  }

  Future<List<RecentCreation>> saveAll(List<RecentCreation> creations) async {
    final directory = await _getStorageDirectory();
    final savedCreations = <RecentCreation>[];
    final metadata = <Map<String, String>>[];

    for (var index = 0; index < creations.length; index++) {
      final creation = creations[index];

      final id = creation.id.isEmpty
          ? '${DateTime.now().microsecondsSinceEpoch}_$index'
          : creation.id;

      final savedCreation = creation.copyWith(id: id);

      final sourceFile = File('${directory.path}/${id}_source.png');
      final previewFile = File('${directory.path}/${id}_preview.png');

      await sourceFile.writeAsBytes(savedCreation.imageBytes, flush: true);

      await previewFile.writeAsBytes(savedCreation.previewBytes, flush: true);

      savedCreations.add(savedCreation);

      metadata.add({'id': id, 'backdrop': savedCreation.backdrop.name});
    }

    final indexFile = File('${directory.path}/index.json');

    await indexFile.writeAsString(jsonEncode(metadata), flush: true);

    return savedCreations;
  }
}

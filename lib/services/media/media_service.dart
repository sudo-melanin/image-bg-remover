import 'dart:typed_data';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:share_plus/share_plus.dart';

class MediaService {
  Future<bool> saveImage(Uint8List imageBytes) async {
    final result = await ImageGallerySaverPlus.saveImage(
      imageBytes,
      quality: 100,
      name: 'bg_remover_${DateTime.now().millisecondsSinceEpoch}',
    );

    return result['isSuccess'] == true;
  }

  Future<void> shareImage(Uint8List imageBytes) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(
            imageBytes,
            mimeType: 'image/png',
          ),
        ],
        fileNameOverrides: [
          'background_removed.png',
        ],
      ),
    );
  }
}
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BackgroundRemovalService {
  Future<List<int>> removeBackground(List<int> imageBytes) async {
    final apiKey = dotenv.env['REMOVE_BG_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Remove.bg API key is not configured.');
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.remove.bg/v1.0/removebg'),
    );

    request.headers['X-Api-Key'] = apiKey;

    request.files.add(
      http.MultipartFile.fromBytes(
        'image_file',
        imageBytes,
        filename: 'image.png',
      ),
    );

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception(
        'Background removal failed (${response.statusCode}).',
      );
    }

    return response.stream.toBytes();
  }
}
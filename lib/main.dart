import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';


Future<void> main() async {
  await dotenv.load(fileName: '.env');

  runApp(const MaterialApp(
    home: BackgroundRemover(),
    debugShowCheckedModeBanner: false,
  ));
}

class BackgroundRemover extends StatefulWidget {
  const BackgroundRemover({super.key});

  @override
  State<BackgroundRemover> createState() => _BackgroundRemoverState();
}

class _BackgroundRemoverState extends State<BackgroundRemover> {
  Uint8List? _imageBytes;
  bool _isLoading = false;

  // 1. Logic to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      var bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  // 2. Logic to send image to Remove.bg API
  Future<void> _removeBackground() async {
    if (_imageBytes == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var url = Uri.parse('https://api.remove.bg/v1.0/removebg');
      var request = http.MultipartRequest('POST', url);

      // ADD YOUR KEY HERE
      request.headers['X-Api-Key'] = dotenv.env['REMOVE_BG_API_KEY']!;

      request.files.add(http.MultipartFile.fromBytes(
        'image_file',
        _imageBytes!,
        filename: 'image.png',
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        setState(() {
          _imageBytes = responseData;
        });
        print("Success!");
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      // This ensures the spinner stops regardless of success or failure
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 3. Logic to save the result back to the phone gallery
  Future<void> _saveImage() async {
    if (_imageBytes != null) {
      await ImageGallerySaverPlus.saveImage(_imageBytes!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved to Gallery!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Background Remover'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display Area
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : (_imageBytes == null
                        ? const Icon(Icons.image, size: 80, color: Colors.grey)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.memory(_imageBytes!, fit: BoxFit.contain),
                          )),
              ),

              const SizedBox(height: 30),

              // Pick Image Button
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text('Pick Image'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons Row
              if (_imageBytes != null && !_isLoading)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _removeBackground,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: const Text('Remove Background'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: _saveImage,
                      icon: const Icon(Icons.download),
                      label: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
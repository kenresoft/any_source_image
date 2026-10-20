import 'package:any_source_image/any_source_image.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: GalleryPage()));

/// The same widget for a network URL, an asset path and a missing image.
class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('any_source_image')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          AppImage(
            'https://picsum.photos/400/200',
            height: 160,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            placeholder: Center(child: CircularProgressIndicator()),
          ),
          SizedBox(height: 16),
          // an asset path (add the file to your pubspec assets)
          AppImage('assets/photo.png', height: 160),
          SizedBox(height: 16),
          // nothing to show: the error widget appears instead
          AppImage(null, height: 80, errorWidget: Icon(Icons.image_not_supported)),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: AppCircleImage('https://picsum.photos/100', radius: 32),
          ),
        ],
      ),
    );
  }
}

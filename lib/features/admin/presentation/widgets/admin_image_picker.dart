import 'dart:typed_data';

import 'package:flutter/material.dart';

class AdminImagePicker extends StatelessWidget {
  const AdminImagePicker({
    required this.imageUrl,
    required this.imageBytes,
    required this.onTap,
    this.height = 200,
    super.key,
  });

  final String imageUrl;
  final Uint8List? imageBytes;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.hardEdge,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (imageBytes != null) {
      return Image.memory(
        imageBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }
    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add_photo_alternate_outlined, size: 48),
          SizedBox(height: 8),
          Text('Tap to select image'),
        ],
      ),
    );
  }
}

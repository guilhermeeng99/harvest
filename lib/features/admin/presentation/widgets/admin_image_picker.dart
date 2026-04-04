import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FaIcon(FontAwesomeIcons.camera, size: 40),
          const SizedBox(height: 8),
          Text(t.admin.tapToSelectImage),
        ],
      ),
    );
  }
}

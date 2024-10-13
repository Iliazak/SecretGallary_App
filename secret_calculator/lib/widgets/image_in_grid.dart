// lib/widgets/image_in_grid.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageInGrid extends StatelessWidget {
  final Function(bool) onSelect;
  final Uint8List bytes;
  final bool isSelected; // Добавьте этот параметр

  const ImageInGrid({
    Key? key,
    required this.onSelect,
    required this.bytes,
    this.isSelected = false, // Значение по умолчанию
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelect(!isSelected);
      },
      child: Stack(
        children: [
          Image.memory(
            bytes,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          if (isSelected)
            Positioned(
              top: 8,
              right: 8,
              child: Icon(
                Icons.check_circle,
                color: Colors.blue,
              ),
            ),
        ],
      ),
    );
  }
}

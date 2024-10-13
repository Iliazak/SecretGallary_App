import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:secret_calculator/models/gallery_model.dart';
import 'package:secret_calculator/ui/colors.dart';

class ImageViewPage extends StatelessWidget {
  final Gallery image;
  const ImageViewPage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [popUpMenu(image.bytes!)],
      ),
      body: Center(
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          alignPanAxis: true,
          child: Hero(
            tag: image.key.toString(),
            child: Image.memory(image.bytes!),
          ),
        ),
      ),
    );
  }

  popUpMenu(Uint8List imageBytes) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          onTap: () {
            image.delete();
            Navigator.pop(context);
          },
          child: menuItem(Icons.delete, "Delete", Colors.red),
        ),
        PopupMenuItem(
          value: 2,
          onTap: () async {
            await saveImageToGallery(imageBytes);
            Navigator.pop(context);
          },
          child: menuItem(Icons.save_alt, "Save to Gallery", Colors.blue),
        ),
      ],
      offset: const Offset(0, 50),
      color: mainColorDark,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      constraints: const BoxConstraints(minWidth: 128),
    );
  }

// Функция для сохранения изображения в галерею
  Future<void> saveImageToGallery(Uint8List imageBytes) async {
    final status = await Permission.storage
        .request(); // Запрашиваем разрешение на доступ к хранилищу
    if (status.isGranted) {
      final result = await ImageGallerySaver.saveImage(
        imageBytes,
        quality: 80, // Качество изображения
        name:
            'saved_image_${DateTime.now().millisecondsSinceEpoch}', // Имя файла
      );
      if (result['isSuccess']) {
        print('Image saved to gallery');
      } else {
        print('Failed to save image');
      }
    } else {
      print('Permission denied');
    }
  }

  menuItem(IconData iconData, String lable, [Color? color]) {
    return Row(
      children: [
        Icon(iconData, color: color),
        const Spacer(),
        Text(
          lable,
          style: TextStyle(
            color: color ?? Colors.white,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

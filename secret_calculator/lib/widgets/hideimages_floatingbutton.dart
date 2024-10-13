import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:photo_manager/photo_manager.dart';

import '../models/gallery_model.dart';

class HideImagesButton extends StatefulWidget {
  final List<AssetEntity> selectedAssets;
  final Function onHideComplete;

  const HideImagesButton({
    Key? key,
    required this.selectedAssets,
    required this.onHideComplete,
  }) : super(key: key);

  @override
  State<HideImagesButton> createState() => _HideImagesButtonState();
}

class _HideImagesButtonState extends State<HideImagesButton> {
  bool hiding = false;

  @override
  Widget build(BuildContext context) {
    if (hiding) {
      return FloatingActionButton(
        onPressed: null, // Отключаем кнопку, когда процесс скрытия запущен
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    } else {
      return FloatingActionButton.extended(
        onPressed: () => hide(), // Запуск процесса скрытия изображений
        label: Text("Hide Images (${widget.selectedAssets.length})"),
      );
    }
  }

  Future<void> hide() async {
    setState(() => hiding = true);

    // Проверяем и открываем box 'gallery'
    Box<Gallery> box;
    if (Hive.isBoxOpen('gallery')) {
      box = Hive.box<Gallery>('gallery');
    } else {
      box = await Hive.openBox<Gallery>('gallery');
    }

    // Получаем уже скрытые пути изображений
    List<String?> alreadyHiddenImagesPath =
        box.values.map((image) => image.localPath).toList();
    int saveImageCount = 0;

    // Обрабатываем выбранные пользователем изображения
    for (var asset in widget.selectedAssets) {
      var imageFile = await asset.loadFile(); // Загружаем файл изображения
      if (imageFile != null) {
        if (!alreadyHiddenImagesPath.contains(imageFile.path)) {
          // Загружаем миниатюру
          var thumbnailBytes = await asset
              .thumbnailDataWithSize(const ThumbnailSize.square(256));

          // Проверка на null для миниатюры
          if (thumbnailBytes != null) {
            // Асинхронно читаем байты изображения
            var imageBytes = await imageFile.readAsBytes();

            // Сохраняем изображение в box Hive
            await box.add(Gallery(
              type: 'image',
              thumbnailBytes: thumbnailBytes,
              bytes: imageBytes,
              dateTime: DateTime.now(),
              localPath: imageFile.path,
            ));

            saveImageCount++;
          }
        }
      }
    }

    // Отображаем уведомление о завершении процесса
    if (saveImageCount != 0) {
      Fluttertoast.showToast(
        msg: "Hidden successfully",
        backgroundColor: Colors.green,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Skipped hiding",
        backgroundColor: Colors.red,
      );
    }

    setState(() => hiding = false);
    widget.onHideComplete();
  }
}

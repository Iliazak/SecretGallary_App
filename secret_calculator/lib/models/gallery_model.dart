// lib/models/gallery_model.dart
import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'gallery_model.g.dart';

@HiveType(typeId: 1) // Уникальный typeId
class Gallery extends HiveObject {
  @HiveField(0)
  String? type;

  @HiveField(1)
  String? localPath;

  @HiveField(2)
  Uint8List? thumbnailBytes;

  @HiveField(3)
  Uint8List? bytes;

  @HiveField(4)
  DateTime dateTime;

  Gallery({
    required this.type,
    required this.localPath,
    required this.thumbnailBytes,
    required this.bytes,
    required this.dateTime,
  });
}

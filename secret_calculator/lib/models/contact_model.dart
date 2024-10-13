// lib/models/contact_model.dart
import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'contact_model.g.dart';

@HiveType(typeId: 2) // Уникальный typeId
class Contact extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String phoneNumber;

  @HiveField(2)
  Uint8List? photoBytes;

  @HiveField(3)
  String? telegrammLink;

  Contact({
    required this.name,
    required this.phoneNumber,
    this.photoBytes,
    required this.telegrammLink,
  });
}

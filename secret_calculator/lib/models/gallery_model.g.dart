// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GalleryAdapter extends TypeAdapter<Gallery> {
  @override
  final int typeId = 1;

  @override
  Gallery read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Gallery(
      type: fields[0] as String?,
      localPath: fields[1] as String?,
      thumbnailBytes: fields[2] as Uint8List?,
      bytes: fields[3] as Uint8List?,
      dateTime: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Gallery obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.localPath)
      ..writeByte(2)
      ..write(obj.thumbnailBytes)
      ..writeByte(3)
      ..write(obj.bytes)
      ..writeByte(4)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GalleryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

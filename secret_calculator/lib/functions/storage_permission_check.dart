import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

Future<void> storagePermissionCheck({
  required Function onPermissionGranted,
  required Function onPermissionDenied,
}) async {
  if (Platform.isAndroid) {
    // Получаем версию SDK Android через плагин device_info_plus
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    int sdkVersion = androidInfo.version.sdkInt;

    if (sdkVersion >= 33) {
      // Для Android 13+ запрашиваем разрешения на фото, видео и аудио
      PermissionStatus imagesPermission = await Permission.photos.request();
      PermissionStatus videosPermission = await Permission.videos.request();
      PermissionStatus audioPermission = await Permission.audio.request();

      if (imagesPermission.isGranted &&
          videosPermission.isGranted &&
          audioPermission.isGranted) {
        onPermissionGranted();
      } else if (imagesPermission.isDenied ||
          videosPermission.isDenied ||
          audioPermission.isDenied) {
        onPermissionDenied();
      } else if (imagesPermission.isPermanentlyDenied ||
          videosPermission.isPermanentlyDenied ||
          audioPermission.isPermanentlyDenied) {
        openAppSettings(); // Открываем настройки, если пользователь запретил доступ
      }
    } else if (sdkVersion >= 30) {
      // Для Android 11 и выше (API 30+) запрашиваем MANAGE_EXTERNAL_STORAGE
      final status = await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        onPermissionGranted();
      } else if (status.isDenied) {
        onPermissionDenied();
      } else if (status.isPermanentlyDenied) {
        openAppSettings(); // Открываем настройки, если доступ был запрещен навсегда
      }
    } else {
      // Для версий ниже Android 11 (API < 30) используем обычный доступ к хранилищу
      final status = await Permission.storage.request();
      if (status.isGranted) {
        onPermissionGranted();
      } else if (status.isDenied) {
        onPermissionDenied();
      } else if (status.isPermanentlyDenied) {
        openAppSettings(); // Открываем настройки, если доступ был запрещен навсегда
      }
    }
  }
}

import 'package:permission_handler/permission_handler.dart';

Future getPermission() async {
  bool permissionCamera = false;
  bool permissionMedia = false;

  var cameraStatus = await Permission.camera.status;
  if (cameraStatus.isGranted) {
    permissionCamera = true;
  } else if (cameraStatus.isDenied) {
    // 카메라 권한 요청
    Permission.camera.request();
    openAppSettings();
  }
  var mediaStatus = await Permission.photos.status;
  if (mediaStatus.isGranted) {
    permissionMedia = true;
  } else if (cameraStatus.isDenied) {
    // 미디어 권한 요청
    Permission.photos.request();
    openAppSettings();
  }
}

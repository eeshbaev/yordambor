import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class LocalBookingPhotoStore {
  static Future<Directory> _bookingDir(String bookingId) async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(root.path, 'booking_photos', bookingId));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<String> saveFromPath({
    required String bookingId,
    required String sourcePath,
  }) async {
    final dir = await _bookingDir(bookingId);
    final ext = p.extension(sourcePath);
    final fileName = '${const Uuid().v4()}$ext';
    final destPath = p.join(dir.path, fileName);
    await File(sourcePath).copy(destPath);
    return destPath;
  }

  static Future<void> deletePhoto(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<void> deleteAllForBooking(String bookingId) async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(root.path, 'booking_photos', bookingId));
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }
}

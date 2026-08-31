import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:yordambor/core/config/env.dart';

class StorageFailure implements Exception {
  StorageFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

class StorageRepository {
  static const bucket = 'portfolio';

  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<String> uploadPortfolioImage({
    required String ownerId,
    required String xizmatId,
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    final client = _client;
    if (client == null) {
      throw StorageFailure('Supabase sozlanmagan');
    }

    final path =
        '$ownerId/$xizmatId/${const Uuid().v4()}.$fileExtension';

    await client.storage.from(bucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: _mimeForExtension(fileExtension),
            upsert: false,
          ),
        );

    return client.storage.from(bucket).getPublicUrl(path);
  }

  Future<String> uploadAvatarImage({
    required String ownerId,
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    final client = _client;
    if (client == null) {
      throw StorageFailure('Supabase sozlanmagan');
    }

    final path = '$ownerId/avatar/${const Uuid().v4()}.$fileExtension';

    await client.storage.from(bucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: _mimeForExtension(fileExtension),
            upsert: true,
          ),
        );

    return client.storage.from(bucket).getPublicUrl(path);
  }

  Future<String> uploadCertificateImage({
    required String ownerId,
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    final client = _client;
    if (client == null) {
      throw StorageFailure('Supabase sozlanmagan');
    }

    final path = '$ownerId/certificates/${const Uuid().v4()}.$fileExtension';

    await client.storage.from(bucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: _mimeForExtension(fileExtension),
            upsert: false,
          ),
        );

    return client.storage.from(bucket).getPublicUrl(path);
  }

  String _mimeForExtension(String ext) {
    return switch (ext.toLowerCase()) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };
  }
}

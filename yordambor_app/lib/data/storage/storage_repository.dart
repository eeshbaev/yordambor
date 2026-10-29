import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/core/l10n/current_strings.dart';

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
      throw StorageFailure(CurrentStrings.value.errServerNotSetUp);
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
      throw StorageFailure(CurrentStrings.value.errServerNotSetUp);
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
      throw StorageFailure(CurrentStrings.value.errServerNotSetUp);
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

  /// Every file under [ownerId]'s folder (service photos, avatar,
  /// certificates), for account deletion. Supabase allows removing files
  /// only through the Storage API, not from the database.
  Future<void> deleteAllFor(String ownerId) async {
    final client = _client;
    if (client == null) return;
    final storage = client.storage.from(bucket);
    const page = 100;

    final paths = <String>[];
    Future<void> collect(String folder) async {
      for (var offset = 0;; offset += page) {
        final items = await storage.list(
          path: folder,
          searchOptions: SearchOptions(limit: page, offset: offset),
        );
        for (final item in items) {
          final path = '$folder/${item.name}';
          // Folders come back without an id.
          if (item.id == null) {
            await collect(path);
          } else {
            paths.add(path);
          }
        }
        if (items.length < page) return;
      }
    }

    await collect(ownerId);
    for (var i = 0; i < paths.length; i += page) {
      await storage.remove(
        paths.sublist(i, i + page > paths.length ? paths.length : i + page),
      );
    }
  }
}

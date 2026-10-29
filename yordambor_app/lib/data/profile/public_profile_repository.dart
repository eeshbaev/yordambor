import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/data/demo/demo_user_profiles.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/data/xizmat/xizmat_repository.dart';
import 'package:yordambor/data/yordam_kerak/yordam_kerak_repository.dart';
import 'package:yordambor/domain/entities/public_user_profile.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/domain/entities/yordam_kerak_post.dart';

class PublicProfileRepository {
  PublicProfileRepository({
    required XizmatRepository xizmatRepository,
    required YordamKerakRepository yordamKerakRepository,
  })  : _xizmatRepository = xizmatRepository,
        _yordamKerakRepository = yordamKerakRepository;

  final XizmatRepository _xizmatRepository;
  final YordamKerakRepository _yordamKerakRepository;

  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<PublicUserProfile?> fetchProfile(String userId) async {
    if (userId.startsWith('demo-user-')) {
      return DemoUserProfiles.byId(userId);
    }

    final client = _client;
    if (client == null) return null;

    // Someone else's phone and email are not readable (migration 023).
    final row = await client
        .from('profiles')
        .select('id, full_name, show_phone, avatar_url, created_at')
        .eq('id', userId)
        .maybeSingle();

    if (row == null) return null;

    return PublicUserProfile(
      id: row['id'] as String,
      fullName: row['full_name'] as String? ?? '',
      showPhone: row['show_phone'] as bool? ?? false,
      avatarUrl: row['avatar_url'] as String?,
      createdAt: DateTime.tryParse(row['created_at'] as String? ?? ''),
    );
  }

  Future<List<XizmatFeedItem>> fetchXizmatlar(
    String userId,
    String language,
  ) {
    if (userId.startsWith('demo-user-')) {
      return Future.value(DemoUserProfiles.xizmatlarForOwner(userId));
    }
    return _xizmatRepository.fetchByOwnerId(userId, language);
  }

  Future<List<YordamKerakFeedItem>> fetchYordamKerakPosts(
    String userId,
    String language,
  ) {
    if (userId.startsWith('demo-user-')) {
      return Future.value(DemoUserProfiles.postsForAuthor(userId));
    }
    return _yordamKerakRepository.fetchOpenPostsByAuthor(
      authorId: userId,
      language: language,
    );
  }

  /// The phone [userId] lets signed-in people see, else null (migration
  /// 024: hidden between people who blocked each other).
  Future<String?> fetchPublicPhone(String userId) async {
    if (userId.startsWith('demo-user-')) {
      final profile = DemoUserProfiles.byId(userId);
      return profile != null && profile.hasVisiblePhone ? profile.phone : null;
    }
    return _rpcPhone('get_public_phone', {'p_user': userId});
  }

  /// The phone shown on a service: the listing's own, else its owner's,
  /// when they chose to show it.
  Future<String?> fetchServicePublicPhone(String xizmatId) =>
      _rpcPhone('get_xizmat_public_phone', {'p_xizmat': xizmatId});

  Future<String?> _rpcPhone(String function, Map<String, dynamic> params) async {
    final client = _client;
    if (client == null || client.auth.currentUser == null) return null;
    try {
      final result = await client.rpc<dynamic>(function, params: params);
      final phone = result is String ? result.trim() : '';
      return phone.isEmpty ? null : phone;
    } on PostgrestException {
      // Not on the server yet (before migration 024): no phone to show.
      return null;
    }
  }
}

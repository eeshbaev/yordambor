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

    final row = await client
        .from('profiles')
        .select('id, full_name, phone, show_phone, avatar_url')
        .eq('id', userId)
        .maybeSingle();

    if (row == null) return null;

    return PublicUserProfile(
      id: row['id'] as String,
      fullName: row['full_name'] as String? ?? '',
      phone: row['phone'] as String?,
      showPhone: row['show_phone'] as bool? ?? false,
      avatarUrl: row['avatar_url'] as String?,
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
}

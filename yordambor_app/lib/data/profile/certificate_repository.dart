import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/domain/entities/profile_certificate.dart';

class CertificateFailure implements Exception {
  CertificateFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

class CertificateRepository {
  static const maxCertificates = 8;

  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<List<ProfileCertificate>> fetchForProfile(String profileId) async {
    final client = _client;
    if (client == null) return [];

    final rows = await client
        .from('profile_certificates')
        .select('id, profile_id, title, issuer, image_url, sort_order')
        .eq('profile_id', profileId)
        .order('sort_order')
        .order('created_at', ascending: false);

    return (rows as List<dynamic>)
        .map(_mapRow)
        .where(_isDisplayableCertificate)
        .toList();
  }

  Future<ProfileCertificate> add({
    required String profileId,
    required AddProfileCertificateInput input,
  }) async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) {
      throw CertificateFailure('Kirish talab qilinadi');
    }
    if (userId != profileId) {
      throw CertificateFailure('Faqat o\'z profilingizga qo\'shishingiz mumkin');
    }

    final title = input.title.trim();
    if (title.length < 2) {
      throw CertificateFailure('Sarlavha kamida 2 ta belgidan iborat bo\'lsin');
    }

    final existing = await fetchForProfile(profileId);
    if (existing.length >= maxCertificates) {
      throw CertificateFailure('Maksimal $maxCertificates ta sertifikat');
    }

    final issuer = input.issuer?.trim();
    final inserted = await client
        .from('profile_certificates')
        .insert({
          'profile_id': profileId,
          'title': title,
          'issuer': issuer == null || issuer.isEmpty ? null : issuer,
          'image_url': input.imageUrl,
          'sort_order': existing.length,
        })
        .select('id, profile_id, title, issuer, image_url, sort_order')
        .single();

    return _mapRow(inserted);
  }

  Future<void> remove(String certificateId) async {
    final client = _client;
    if (client == null) throw CertificateFailure('Supabase sozlanmagan');

    await client.from('profile_certificates').delete().eq('id', certificateId);
  }

  ProfileCertificate _mapRow(dynamic raw) {
    final map = Map<String, dynamic>.from(raw as Map);
    return ProfileCertificate(
      id: map['id'] as String,
      profileId: map['profile_id'] as String,
      title: map['title'] as String,
      issuer: map['issuer'] as String?,
      imageUrl: map['image_url'] as String,
      sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
    );
  }

  bool _isDisplayableCertificate(ProfileCertificate certificate) {
    if (certificate.id.startsWith('demo-')) return false;
    if (certificate.profileId.startsWith('demo-user-')) return false;
    if (certificate.isDemo) return false;

    final url = certificate.imageUrl.trim();
    if (url.isEmpty || !url.startsWith('http')) return false;

    final lowerUrl = url.toLowerCase();
    if (lowerUrl.contains('placeholder') || lowerUrl.contains('picsum')) {
      return false;
    }

    return true;
  }
}

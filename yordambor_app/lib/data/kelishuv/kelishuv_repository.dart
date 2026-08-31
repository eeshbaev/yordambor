import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/data/kelishuv/kelishuv_exceptions.dart';
export 'package:yordambor/data/kelishuv/kelishuv_exceptions.dart';
import 'package:yordambor/data/safety/block_repository.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/domain/entities/kelishuv_message.dart';
import 'package:yordambor/domain/entities/kelishuv_summary.dart';

class KelishuvRepository {
  KelishuvRepository([BlockRepository? blockRepository])
      : _blockRepository = blockRepository ?? BlockRepository();

  final BlockRepository _blockRepository;

  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<Kelishuv> createFromXizmat({
    required String xizmatId,
    required TaklifInput input,
  }) async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) {
      throw KelishuvFailure('Kirish talab qilinadi');
    }

    final xizmat = await client
        .from('xizmatlar')
        .select('id, owner_id, name')
        .eq('id', xizmatId)
        .maybeSingle();

    if (xizmat == null) throw KelishuvFailure('Xizmat topilmadi');

    final ownerId = xizmat['owner_id'] as String;
    if (ownerId == userId) {
      throw KelishuvFailure('O\'z xizmatingizga so\'rov yuborib bo\'lmaydi');
    }

    await _blockRepository.assertCanInteract(ownerId);

    await _guardOneActive(client, xizmatId: xizmatId, userId: userId, ownerId: ownerId);

    final row = await client
        .from('kelishuvlar')
        .insert({
          'xizmat_id': xizmatId,
          'party_a_id': userId,
          'party_b_id': ownerId,
          'initiator_id': userId,
          'message': input.message?.trim().isEmpty ?? true
              ? null
              : input.message!.trim(),
          'price': input.price,
          'currency': input.price != null ? (input.currency ?? 'UZS') : null,
          'start_date': input.startDate?.toIso8601String().split('T').first,
          'duration_minutes': input.durationMinutes,
          'status': 'muzokarada',
        })
        .select('id')
        .single();

    final kelishuv = await fetchById(row['id'] as String);
    if (kelishuv == null) throw KelishuvFailure('Kelishuv yaratilmadi');
    return kelishuv;
  }

  Future<Kelishuv> createFromPost({
    required String postId,
    required String xizmatId,
    required TaklifInput input,
  }) async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) {
      throw KelishuvFailure('Kirish talab qilinadi');
    }

    final post = await client
        .from('yordam_kerak_posts')
        .select('id, author_id, title')
        .eq('id', postId)
        .maybeSingle();

    if (post == null) throw KelishuvFailure('E\'lon topilmadi');

    final authorId = post['author_id'] as String;
    if (authorId == userId) {
      throw KelishuvFailure('O\'z e\'loningizga taklif yuborib bo\'lmaydi');
    }

    await _blockRepository.assertCanInteract(authorId);

    final xizmat = await client
        .from('xizmatlar')
        .select('owner_id')
        .eq('id', xizmatId)
        .maybeSingle();

    if (xizmat == null || xizmat['owner_id'] != userId) {
      throw KelishuvFailure('Faqat o\'z xizmatingiz orqali taklif yuboring');
    }

    await _guardOneActive(
      client,
      xizmatId: xizmatId,
      userId: authorId,
      ownerId: userId,
    );

    final row = await client.from('kelishuvlar').insert({
      'xizmat_id': xizmatId,
      'yordam_kerak_post_id': postId,
      'party_a_id': authorId,
      'party_b_id': userId,
      'initiator_id': userId,
      'message': input.message?.trim().isEmpty ?? true
          ? null
          : input.message!.trim(),
      'price': input.price,
      'currency': input.price != null ? (input.currency ?? 'UZS') : null,
      'start_date': input.startDate?.toIso8601String().split('T').first,
      'duration_minutes': input.durationMinutes,
      'status': 'muzokarada',
    }).select('id').single();

    final kelishuv = await fetchById(row['id'] as String);
    if (kelishuv == null) throw KelishuvFailure('Kelishuv yaratilmadi');
    return kelishuv;
  }

  Future<void> accept(String kelishuvId, String userId) async {
    final client = _client;
    if (client == null) throw KelishuvFailure('Supabase sozlanmagan');

    final row = await client
        .from('kelishuvlar')
        .select('party_a_id, party_b_id, accept_a, accept_b, status')
        .eq('id', kelishuvId)
        .maybeSingle();

    if (row == null) throw KelishuvFailure('Kelishuv topilmadi');

    final partyA = row['party_a_id'] as String;
    final partyB = row['party_b_id'] as String;
    if (userId != partyA && userId != partyB) {
      throw KelishuvFailure('Ruxsat yo\'q');
    }

    final updates = <String, dynamic>{};
    if (userId == partyA) {
      updates['accept_a'] = true;
      updates['accept_a_at'] = DateTime.now().toUtc().toIso8601String();
    } else {
      updates['accept_b'] = true;
      updates['accept_b_at'] = DateTime.now().toUtc().toIso8601String();
    }

    final nextAcceptA = userId == partyA ? true : row['accept_a'] as bool;
    final nextAcceptB = userId == partyB ? true : row['accept_b'] as bool;

    if (nextAcceptA && nextAcceptB) {
      updates['status'] = 'jarayonda';
      updates['jarayonda_at'] = DateTime.now().toUtc().toIso8601String();
    }

    await client.from('kelishuvlar').update(updates).eq('id', kelishuvId);
  }

  Future<Kelishuv> updateTerms(
    String kelishuvId,
    String userId,
    TaklifInput input,
  ) async {
    final client = _client;
    if (client == null) throw KelishuvFailure('Supabase sozlanmagan');

    final row = await client
        .from('kelishuvlar')
        .select('party_a_id, party_b_id, status, jarayonda_at')
        .eq('id', kelishuvId)
        .maybeSingle();

    if (row == null) throw KelishuvFailure('Kelishuv topilmadi');

    final partyA = row['party_a_id'] as String;
    final partyB = row['party_b_id'] as String;
    if (userId != partyA && userId != partyB) {
      throw KelishuvFailure('Ruxsat yo\'q');
    }

    final status = _parseStatus(row['status'] as String);
    if (status != KelishuvStatus.muzokarada &&
        status != KelishuvStatus.jarayonda) {
      throw KelishuvFailure('Shartlarni faqat faol kelishuvda o\'zgartirish mumkin');
    }

    if (status == KelishuvStatus.jarayonda) {
      final jarayondaAtRaw = row['jarayonda_at'] as String?;
      final jarayondaAt =
          jarayondaAtRaw != null ? DateTime.tryParse(jarayondaAtRaw) : null;
      if (jarayondaAt != null &&
          DateTime.now().difference(jarayondaAt).inDays > 3) {
        throw KelishuvFailure('3 kundan keyin shartlarni o\'zgartirib bo\'lmaydi');
      }
    }

    final now = DateTime.now().toUtc().toIso8601String();
    await client.from('kelishuvlar').update({
      if (input.message != null)
        'message': input.message!.trim().isEmpty ? null : input.message!.trim(),
      'price': input.price,
      'currency': input.price != null ? (input.currency ?? 'UZS') : null,
      'start_date': input.startDate?.toIso8601String().split('T').first,
      'duration_minutes': input.durationMinutes,
      'accept_a': false,
      'accept_b': false,
      'accept_a_at': null,
      'accept_b_at': null,
      'complete_a': false,
      'complete_b': false,
      'complete_a_at': null,
      'complete_b_at': null,
      'status': 'muzokarada',
      'jarayonda_at': null,
      'updated_at': now,
    }).eq('id', kelishuvId);

    final kelishuv = await fetchById(kelishuvId);
    if (kelishuv == null) throw KelishuvFailure('Kelishuv yangilanmadi');
    return kelishuv;
  }

  Future<void> reject(String kelishuvId, String userId) async {
    await _updateStatus(
      kelishuvId,
      userId,
      allowed: {KelishuvStatus.muzokarada},
      nextStatus: 'rad',
    );
  }

  Future<void> cancel(String kelishuvId, String userId) async {
    await _updateStatus(
      kelishuvId,
      userId,
      allowed: {KelishuvStatus.muzokarada, KelishuvStatus.jarayonda},
      nextStatus: 'bekor',
    );
  }

  Future<void> markBajarildi(String kelishuvId, String userId) async {
    final client = _client;
    if (client == null) throw KelishuvFailure('Supabase sozlanmagan');

    final row = await client
        .from('kelishuvlar')
        .select(
          'party_a_id, party_b_id, status, xizmat_id, complete_a, complete_b, jarayonda_at',
        )
        .eq('id', kelishuvId)
        .maybeSingle();

    if (row == null) throw KelishuvFailure('Kelishuv topilmadi');

    final partyA = row['party_a_id'] as String;
    final partyB = row['party_b_id'] as String;
    if (userId != partyA && userId != partyB) {
      throw KelishuvFailure('Ruxsat yo\'q');
    }

    final status = _parseStatus(row['status'] as String);
    if (status != KelishuvStatus.jarayonda) {
      throw KelishuvFailure('Faqat jarayondagi kelishuvni yakunlash mumkin');
    }

    final jarayondaAtRaw = row['jarayonda_at'] as String?;
    final jarayondaAt =
        jarayondaAtRaw != null ? DateTime.tryParse(jarayondaAtRaw) : null;
    if (jarayondaAt != null &&
        DateTime.now().difference(jarayondaAt).inDays < 3) {
      throw KelishuvFailure(
        'Ishni tugatish jarayon boshlanganidan 3 kun o\'tgach mumkin',
      );
    }

    final now = DateTime.now().toUtc().toIso8601String();
    final updates = <String, dynamic>{
      'updated_at': now,
    };

    if (userId == partyA) {
      updates['complete_a'] = true;
      updates['complete_a_at'] = now;
    } else {
      updates['complete_b'] = true;
      updates['complete_b_at'] = now;
    }

    final nextCompleteA =
        userId == partyA ? true : row['complete_a'] as bool? ?? false;
    final nextCompleteB =
        userId == partyB ? true : row['complete_b'] as bool? ?? false;

    if (nextCompleteA && nextCompleteB) {
      updates['status'] = 'bajarildi';
      updates['bajarildi_at'] = now;
    }

    await client.from('kelishuvlar').update(updates).eq('id', kelishuvId);

    if (nextCompleteA && nextCompleteB) {
      final xizmatId = row['xizmat_id'] as String?;
      if (xizmatId != null) {
        final xizmat = await client
            .from('xizmatlar')
            .select('completed_count')
            .eq('id', xizmatId)
            .maybeSingle();

        if (xizmat != null) {
          final count = (xizmat['completed_count'] as num?)?.toInt() ?? 0;
          await client
              .from('xizmatlar')
              .update({'completed_count': count + 1})
              .eq('id', xizmatId);
        }
      }
    }
  }

  Future<List<KelishuvSummary>> fetchArchived(String userId) async {
    final client = _client;
    if (client == null) return [];
    return _fetchArchivedRemote(client, userId);
  }

  Future<List<KelishuvSummary>> _fetchArchivedRemote(
    SupabaseClient client,
    String userId,
  ) async {
    final rows = await client
        .from('kelishuvlar')
        .select(_summarySelect)
        .or('party_a_id.eq.$userId,party_b_id.eq.$userId')
        .inFilter('status', ['bajarildi', 'bekor', 'rad', 'archived'])
        .order('updated_at', ascending: false)
        .limit(50);

    return (rows as List<dynamic>)
        .map(
          (raw) => _mapSummary(
            Map<String, dynamic>.from(raw as Map),
            viewerId: userId,
          ),
        )
        .toList();
  }

  Future<void> _updateStatus(
    String kelishuvId,
    String userId, {
    required Set<KelishuvStatus> allowed,
    required String nextStatus,
  }) async {
    final client = _client;
    if (client == null) throw KelishuvFailure('Supabase sozlanmagan');

    final row = await client
        .from('kelishuvlar')
        .select('party_a_id, party_b_id, status')
        .eq('id', kelishuvId)
        .maybeSingle();

    if (row == null) throw KelishuvFailure('Kelishuv topilmadi');

    final partyA = row['party_a_id'] as String;
    final partyB = row['party_b_id'] as String;
    if (userId != partyA && userId != partyB) {
      throw KelishuvFailure('Ruxsat yo\'q');
    }

    final status = _parseStatus(row['status'] as String);
    if (!allowed.contains(status)) {
      throw KelishuvFailure('Bu amal hozirgi holatda mumkin emas');
    }

    await client.from('kelishuvlar').update({
      'status': nextStatus,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', kelishuvId);
  }

  Future<List<KelishuvInboxGroup>> fetchIncomingGrouped(String ownerId) async {
    final client = _client;
    if (client == null) return [];
    return _fetchIncomingGroupedRemote(client, ownerId);
  }

  Future<List<KelishuvInboxGroup>> _fetchIncomingGroupedRemote(
    SupabaseClient client,
    String ownerId,
  ) async {
    final xizmatRows = await client
        .from('xizmatlar')
        .select('id, name')
        .eq('owner_id', ownerId);

    final xizmatMaps = (xizmatRows as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    if (xizmatMaps.isEmpty) return [];

    final xizmatIds = xizmatMaps.map((row) => row['id'] as String).toList();
    final nameById = {
      for (final row in xizmatMaps) row['id'] as String: row['name'] as String,
    };

    final rows = await client
        .from('kelishuvlar')
        .select(_summarySelect)
        .inFilter('xizmat_id', xizmatIds)
        .inFilter('status', ['muzokarada', 'jarayonda'])
        .order('updated_at', ascending: false);

    final grouped = <String, List<KelishuvSummary>>{};
    for (final raw in rows as List<dynamic>) {
      final summary = _mapSummary(
        Map<String, dynamic>.from(raw as Map),
        viewerId: ownerId,
      );
      final xizmatId = summary.xizmatId;
      if (xizmatId == null) continue;
      grouped.putIfAbsent(xizmatId, () => []).add(summary);
    }

    return xizmatIds
        .where(grouped.containsKey)
        .map(
          (id) => KelishuvInboxGroup(
            xizmatId: id,
            xizmatName: nameById[id] ?? 'Xizmat',
            items: grouped[id]!,
          ),
        )
        .toList();
  }

  Future<List<KelishuvSummary>> fetchIncomingForXizmat(
    String xizmatId,
    String ownerId,
  ) async {
    final client = _client;
    if (client == null) return [];

    final rows = await client
        .from('kelishuvlar')
        .select(_summarySelect)
        .eq('xizmat_id', xizmatId)
        .inFilter('status', ['muzokarada', 'jarayonda'])
        .order('updated_at', ascending: false);

    return (rows as List<dynamic>)
        .map(
          (raw) => _mapSummary(
            Map<String, dynamic>.from(raw as Map),
            viewerId: ownerId,
          ),
        )
        .toList();
  }

  Future<List<KelishuvSummary>> fetchMyRequests(String userId) async {
    final client = _client;
    if (client == null) return [];
    return _fetchMyRequestsRemote(client, userId);
  }

  Future<List<KelishuvSummary>> _fetchMyRequestsRemote(
    SupabaseClient client,
    String userId,
  ) async {
    final rows = await client
        .from('kelishuvlar')
        .select(_summarySelect)
        .or(
          'initiator_id.eq.$userId,and(party_a_id.eq.$userId,yordam_kerak_post_id.not.is.null)',
        )
        .inFilter('status', ['muzokarada', 'jarayonda'])
        .order('updated_at', ascending: false);

    final summaries = <KelishuvSummary>[];
    for (final raw in rows as List<dynamic>) {
      final map = Map<String, dynamic>.from(raw as Map);
      final xizmat = map['xizmatlar'] as Map<String, dynamic>?;
      final xizmatOwnerId = xizmat?['owner_id'] as String?;
      if (xizmatOwnerId == userId) continue;
      summaries.add(_mapSummary(map, viewerId: userId));
    }
    return summaries;
  }

  Future<List<KelishuvMessage>> fetchMessages(String kelishuvId) async {
    final client = _client;
    if (client == null) return [];

    final rows = await client
        .from('kelishuv_messages')
        .select('''
          id,
          kelishuv_id,
          sender_id,
          content,
          created_at,
          profiles!kelishuv_messages_sender_id_fkey ( full_name )
        ''')
        .eq('kelishuv_id', kelishuvId)
        .order('created_at', ascending: true);

    return (rows as List<dynamic>).map((raw) {
      final map = Map<String, dynamic>.from(raw as Map);
      final profile = map['profiles'] as Map<String, dynamic>?;
      return KelishuvMessage(
        id: map['id'] as String,
        kelishuvId: map['kelishuv_id'] as String,
        senderId: map['sender_id'] as String,
        content: map['content'] as String,
        createdAt: DateTime.parse(map['created_at'] as String),
        senderName: profile?['full_name'] as String?,
      );
    }).toList();
  }

  Future<KelishuvSendMessageResult> sendMessage(
    String kelishuvId,
    String content,
  ) async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) {
      throw KelishuvFailure('Kirish talab qilinadi');
    }

    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      throw KelishuvFailure('Xabar bo\'sh bo\'lmasin');
    }

    var acceptsReset = false;
    final kelishuvRow = await client
        .from('kelishuvlar')
        .select('party_a_id, party_b_id, accept_a, accept_b, status')
        .eq('id', kelishuvId)
        .maybeSingle();

    if (kelishuvRow != null) {
      final partyA = kelishuvRow['party_a_id'] as String;
      final partyB = kelishuvRow['party_b_id'] as String;
      final acceptA = kelishuvRow['accept_a'] as bool? ?? false;
      final acceptB = kelishuvRow['accept_b'] as bool? ?? false;
      final otherHadAccepted =
          (userId == partyA && acceptB) || (userId == partyB && acceptA);

      if (otherHadAccepted) {
        acceptsReset = true;
        await client.from('kelishuvlar').update({
          'accept_a': false,
          'accept_b': false,
          'accept_a_at': null,
          'accept_b_at': null,
          'complete_a': false,
          'complete_b': false,
          'complete_a_at': null,
          'complete_b_at': null,
          'status': 'muzokarada',
          'jarayonda_at': null,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        }).eq('id', kelishuvId);
      }
    }

    final inserted = await client
        .from('kelishuv_messages')
        .insert({
          'kelishuv_id': kelishuvId,
          'sender_id': userId,
          'content': trimmed,
        })
        .select('''
          id,
          kelishuv_id,
          sender_id,
          content,
          created_at,
          profiles!kelishuv_messages_sender_id_fkey ( full_name )
        ''')
        .single();

    final map = Map<String, dynamic>.from(inserted);
    final profile = map['profiles'] as Map<String, dynamic>?;
    final message = KelishuvMessage(
      id: map['id'] as String,
      kelishuvId: map['kelishuv_id'] as String,
      senderId: map['sender_id'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      senderName: profile?['full_name'] as String?,
    );
    return KelishuvSendMessageResult(
      message: message,
      acceptsReset: acceptsReset,
    );
  }

  static const _summarySelect = '''
        id,
        status,
        xizmat_id,
        party_a_id,
        party_b_id,
        initiator_id,
        message,
        price,
        currency,
        duration_minutes,
        accept_a,
        accept_b,
        complete_a,
        complete_b,
        updated_at,
        xizmatlar ( name, owner_id ),
        yordam_kerak_posts ( title ),
        party_a:profiles!kelishuvlar_party_a_id_fkey ( full_name ),
        party_b:profiles!kelishuvlar_party_b_id_fkey ( full_name )
      ''';

  KelishuvSummary _mapSummary(
    Map<String, dynamic> map, {
    required String viewerId,
  }) {
    final partyA = map['party_a_id'] as String;
    final partyB = map['party_b_id'] as String;
    final partyAProfile = map['party_a'] as Map<String, dynamic>?;
    final partyBProfile = map['party_b'] as Map<String, dynamic>?;
    final xizmat = map['xizmatlar'] as Map<String, dynamic>?;
    final post = map['yordam_kerak_posts'] as Map<String, dynamic>?;
    final otherProfile = viewerId == partyA ? partyBProfile : partyAProfile;
    final acceptA = map['accept_a'] as bool? ?? false;
    final acceptB = map['accept_b'] as bool? ?? false;
    final completeA = map['complete_a'] as bool? ?? false;
    final completeB = map['complete_b'] as bool? ?? false;
    final status = _parseStatus(map['status'] as String);
    final needsAccept = status == KelishuvStatus.muzokarada &&
        ((viewerId == partyA && !acceptA) || (viewerId == partyB && !acceptB));
    final needsMyComplete = status == KelishuvStatus.jarayonda &&
        ((viewerId == partyA && !completeA) ||
            (viewerId == partyB && !completeB));
    final xizmatOwnerId = xizmat?['owner_id'] as String?;
    final xizmatId = map['xizmat_id'] as String?;
    final canRepeatBook = xizmatId != null &&
        xizmatOwnerId != null &&
        status == KelishuvStatus.bajarildi &&
        viewerId != xizmatOwnerId;

    return KelishuvSummary(
      id: map['id'] as String,
      status: status,
      xizmatId: xizmatId,
      xizmatName: xizmat?['name'] as String? ?? 'Xizmat',
      otherPartyName: otherProfile?['full_name'] as String? ?? 'Foydalanuvchi',
      updatedAt: DateTime.parse(map['updated_at'] as String),
      message: map['message'] as String?,
      postTitle: post?['title'] as String?,
      price: (map['price'] as num?)?.toDouble(),
      currency: map['currency'] as String?,
      durationMinutes: (map['duration_minutes'] as num?)?.toInt(),
      canRepeatBook: canRepeatBook,
      needsMyAccept: needsAccept,
      needsMyComplete: needsMyComplete,
    );
  }

  Future<Kelishuv?> fetchById(String id) async {
    final client = _client;
    if (client == null) return null;

    final row = await client.from('kelishuvlar').select('''
          *,
          xizmatlar ( name, owner_id ),
          yordam_kerak_posts ( title ),
          party_a:profiles!kelishuvlar_party_a_id_fkey ( full_name ),
          party_b:profiles!kelishuvlar_party_b_id_fkey ( full_name )
        ''').eq('id', id).maybeSingle();

    if (row == null) return null;
    return _mapRow(Map<String, dynamic>.from(row));
  }

  Future<void> _guardOneActive(
    SupabaseClient client, {
    required String xizmatId,
    required String userId,
    required String ownerId,
  }) async {
    final rows = await client
        .from('kelishuvlar')
        .select('party_a_id, party_b_id')
        .eq('xizmat_id', xizmatId)
        .inFilter('status', ['muzokarada', 'jarayonda']);

    for (final raw in rows as List<dynamic>) {
      final row = Map<String, dynamic>.from(raw as Map);
      final a = row['party_a_id'] as String;
      final b = row['party_b_id'] as String;
      final isPair = (a == userId && b == ownerId) || (a == ownerId && b == userId);
      if (isPair) {
        throw KelishuvFailure('Bu xizmat uchun faol kelishuv allaqachon mavjud');
      }
    }
  }

  Kelishuv _mapRow(Map<String, dynamic> map) {
    final xizmat = map['xizmatlar'] as Map<String, dynamic>?;
    final post = map['yordam_kerak_posts'] as Map<String, dynamic>?;
    final partyAProfile = map['party_a'] as Map<String, dynamic>?;
    final partyBProfile = map['party_b'] as Map<String, dynamic>?;
    final startDateRaw = map['start_date'] as String?;
    final createdAtRaw = map['created_at'] as String?;
    final updatedAtRaw = map['updated_at'] as String?;
    final jarayondaAtRaw = map['jarayonda_at'] as String?;

    return Kelishuv(
      id: map['id'] as String,
      status: _parseStatus(map['status'] as String),
      partyAId: map['party_a_id'] as String,
      partyBId: map['party_b_id'] as String,
      initiatorId: map['initiator_id'] as String,
      xizmatId: map['xizmat_id'] as String?,
      yordamKerakPostId: map['yordam_kerak_post_id'] as String?,
      message: map['message'] as String?,
      price: (map['price'] as num?)?.toDouble(),
      currency: map['currency'] as String?,
      startDate: startDateRaw != null ? DateTime.tryParse(startDateRaw) : null,
      durationMinutes: (map['duration_minutes'] as num?)?.toInt(),
      acceptA: map['accept_a'] as bool? ?? false,
      acceptB: map['accept_b'] as bool? ?? false,
      completeA: map['complete_a'] as bool? ?? false,
      completeB: map['complete_b'] as bool? ?? false,
      xizmatName: xizmat?['name'] as String?,
      postTitle: post?['title'] as String?,
      partyAName: partyAProfile?['full_name'] as String?,
      partyBName: partyBProfile?['full_name'] as String?,
      createdAt:
          createdAtRaw != null ? DateTime.tryParse(createdAtRaw) : null,
      updatedAt:
          updatedAtRaw != null ? DateTime.tryParse(updatedAtRaw) : null,
      xizmatOwnerId: xizmat?['owner_id'] as String?,
      jarayondaAt:
          jarayondaAtRaw != null ? DateTime.tryParse(jarayondaAtRaw) : null,
    );
  }

  KelishuvStatus _parseStatus(String raw) => switch (raw) {
        'jarayonda' => KelishuvStatus.jarayonda,
        'bajarildi' => KelishuvStatus.bajarildi,
        'bekor' => KelishuvStatus.bekor,
        'rad' => KelishuvStatus.rad,
        'archived' => KelishuvStatus.archived,
        _ => KelishuvStatus.muzokarada,
      };

}

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/core/utils/demo_ids.dart';
import 'package:yordambor/data/demo/demo_kelishuv_simulator.dart';
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

    if (isDemoFeedId(xizmatId)) {
      return DemoKelishuvSimulator.createFromXizmat(
        xizmatId: xizmatId,
        clientUserId: userId,
        clientDisplayName: _currentUserDisplayName(client),
        input: input,
      );
    }

    final xizmat = await client
        .from('xizmatlar')
        .select('id, owner_id, name')
        .eq('id', xizmatId)
        .maybeSingle();

    if (xizmat == null) throw KelishuvFailure('Xizmat topilmadi');

    final ownerId = xizmat['owner_id'] as String;
    if (ownerId == userId) {
      throw KelishuvFailure('Oʻz xizmatingizga soʻrov yuborib boʻlmaydi');
    }

    await _blockRepository.assertCanInteract(ownerId);

    await _guardOneActive(client, xizmatId: xizmatId, userId: userId, ownerId: ownerId);

    final kelishuvId = await _insertOffer(client, input, {
      'xizmat_id': xizmatId,
      'party_a_id': userId,
      'party_b_id': ownerId,
      'initiator_id': userId,
    });
    await _acceptOwnOffer(kelishuvId, userId);
    final kelishuv = await fetchById(kelishuvId);
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

    if (isDemoFeedId(postId)) {
      final xizmatRow = await client
          .from('xizmatlar')
          .select('name, owner_id')
          .eq('id', xizmatId)
          .maybeSingle();
      if (xizmatRow == null || xizmatRow['owner_id'] != userId) {
        throw KelishuvFailure('Faqat oʻz xizmatingiz orqali taklif yuboring');
      }
      return DemoKelishuvSimulator.createFromPost(
        postId: postId,
        xizmatId: xizmatId,
        providerUserId: userId,
        providerDisplayName: _currentUserDisplayName(client),
        xizmatName: xizmatRow['name'] as String? ?? 'Xizmat',
        input: input,
      );
    }

    final post = await client
        .from('yordam_kerak_posts')
        .select('id, author_id, title')
        .eq('id', postId)
        .maybeSingle();

    if (post == null) throw KelishuvFailure('Eʼlon topilmadi');

    final authorId = post['author_id'] as String;
    if (authorId == userId) {
      throw KelishuvFailure('Oʻz eʼloningizga taklif yuborib boʻlmaydi');
    }

    await _blockRepository.assertCanInteract(authorId);

    final xizmat = await client
        .from('xizmatlar')
        .select('owner_id')
        .eq('id', xizmatId)
        .maybeSingle();

    if (xizmat == null || xizmat['owner_id'] != userId) {
      throw KelishuvFailure('Faqat oʻz xizmatingiz orqali taklif yuboring');
    }

    await _guardOneActive(
      client,
      xizmatId: xizmatId,
      userId: authorId,
      ownerId: userId,
    );

    final kelishuvId = await _insertOffer(client, input, {
      'xizmat_id': xizmatId,
      'yordam_kerak_post_id': postId,
      'party_a_id': authorId,
      'party_b_id': userId,
      'initiator_id': userId,
    });
    await _acceptOwnOffer(kelishuvId, userId);
    final kelishuv = await fetchById(kelishuvId);
    if (kelishuv == null) throw KelishuvFailure('Kelishuv yaratilmadi');
    return kelishuv;
  }

  /// Saves a new offer between [parties] and returns its id. The sender's
  /// card goes in its own columns (migration 021); until the server has
  /// them, the card leads the message, so the other side still gets it.
  Future<String> _insertOffer(
    SupabaseClient client,
    TaklifInput input,
    Map<String, Object?> parties,
  ) async {
    Future<String> insert() async {
      final row = await client
          .from('kelishuvlar')
          .insert(_offerRow(input, parties))
          .select('id')
          .single();
      return row['id'] as String;
    }

    try {
      return await insert();
    } on PostgrestException catch (error) {
      if (_contactColumnsMissing ||
          input.contact == null ||
          !error.message.contains('contact_')) {
        rethrow;
      }
      _contactColumnsMissing = true;
      return insert();
    }
  }

  /// True once the server answers that the card columns do not exist yet.
  static bool _contactColumnsMissing = false;

  Map<String, Object?> _offerRow(
    TaklifInput input,
    Map<String, Object?> parties,
  ) {
    final contact = input.contact;
    final typed = input.message?.trim() ?? '';
    final message = contact != null && _contactColumnsMissing
        ? [contact.line, if (typed.isNotEmpty) typed].join('\n\n')
        : typed;
    return {
      ...parties,
      'message': message.isEmpty ? null : message,
      'price': input.price,
      'currency': input.price != null ? (input.currency ?? 'UZS') : null,
      'start_date': input.startDate?.toIso8601String().split('T').first,
      'duration_minutes': input.durationMinutes,
      'recur_rule': input.recurRule?.name,
      'recur_until': input.recurUntil?.toIso8601String().split('T').first,
      'status': 'muzokarada',
      if (contact != null && !_contactColumnsMissing) ...{
        'contact_first_name': contact.firstName,
        'contact_last_name': contact.lastName,
        'contact_phone': contact.phone,
      },
    };
  }

  /// Sending an offer is the sender's acceptance of it: the deal then waits
  /// for the other side to accept, decline or offer new terms. If this
  /// fails the deal still exists and the sender can accept by hand.
  Future<void> _acceptOwnOffer(String kelishuvId, String userId) async {
    try {
      await accept(kelishuvId, userId);
    } catch (_) {
      // Kept as sent; nothing is lost.
    }
  }

  Future<void> accept(String kelishuvId, String userId) async {
    if (isSimulatedKelishuvId(kelishuvId)) {
      DemoKelishuvSimulator.accept(kelishuvId, userId);
      return;
    }

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
      throw KelishuvFailure('Ruxsat yoʻq');
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
      throw KelishuvFailure('Ruxsat yoʻq');
    }

    final status = _parseStatus(row['status'] as String);
    if (status != KelishuvStatus.muzokarada &&
        status != KelishuvStatus.jarayonda) {
      throw KelishuvFailure('Shartlarni faqat faol kelishuvda oʻzgartirish mumkin');
    }

    if (status == KelishuvStatus.jarayonda) {
      final jarayondaAtRaw = row['jarayonda_at'] as String?;
      final jarayondaAt =
          jarayondaAtRaw != null ? DateTime.tryParse(jarayondaAtRaw) : null;
      if (jarayondaAt != null &&
          DateTime.now().difference(jarayondaAt).inDays > 3) {
        throw KelishuvFailure('3 kundan keyin shartlarni oʻzgartirib boʻlmaydi');
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
      'recur_rule': input.recurRule?.name,
      'recur_until': input.recurUntil?.toIso8601String().split('T').first,
      // New terms are the editor's offer: they accept them, and the other
      // side has a fresh window to answer.
      'accept_a': userId == partyA,
      'accept_b': userId == partyB,
      'accept_a_at': userId == partyA ? now : null,
      'accept_b_at': userId == partyB ? now : null,
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
      throw KelishuvFailure('Ruxsat yoʻq');
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
        'Ishni tugatish jarayon boshlanganidan 3 kun oʻtgach mumkin',
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
      throw KelishuvFailure('Ruxsat yoʻq');
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
    for (final map in await _withoutLapsedOffers(client, rows)) {
      final summary = _mapSummary(map, viewerId: ownerId);
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

    final active = await _withoutLapsedOffers(client, rows);
    return active.map((map) => _mapSummary(map, viewerId: ownerId)).toList();
  }

  Future<List<KelishuvSummary>> fetchMyRequests(String userId) async {
    final client = _client;
    final demo = DemoKelishuvSimulator.summariesForUser(userId);
    if (client == null) return demo;
    final remote = await _fetchMyRequestsRemote(client, userId);
    final seen = remote.map((s) => s.id).toSet();
    return [
      ...demo.where((s) => !seen.contains(s.id)),
      ...remote,
    ];
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
    for (final map in await _withoutLapsedOffers(client, rows)) {
      final xizmat = map['xizmatlar'] as Map<String, dynamic>?;
      final xizmatOwnerId = xizmat?['owner_id'] as String?;
      if (xizmatOwnerId == userId) continue;
      summaries.add(_mapSummary(map, viewerId: userId));
    }
    return summaries;
  }

  Future<List<KelishuvMessage>> fetchMessages(String kelishuvId) async {
    if (isSimulatedKelishuvId(kelishuvId)) {
      return DemoKelishuvSimulator.messages(kelishuvId);
    }

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
    if (userId == null) {
      throw KelishuvFailure('Kirish talab qilinadi');
    }

    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      throw KelishuvFailure('Xabar boʻsh boʻlmasin');
    }

    if (isSimulatedKelishuvId(kelishuvId)) {
      DemoKelishuvSimulator.addMessage(
        kelishuvId: kelishuvId,
        senderId: userId,
        senderName: client != null ? _currentUserDisplayName(client) : 'Siz',
        content: trimmed,
      );
      final sent = DemoKelishuvSimulator.messages(kelishuvId).last;
      return KelishuvSendMessageResult(message: sent, acceptsReset: false);
    }

    if (client == null) {
      throw KelishuvFailure('Supabase sozlanmagan');
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
      // While an offer waits for an answer, a question about it does not
      // withdraw it.
      final negotiating = kelishuvRow['status'] == 'muzokarada';
      final otherHadAccepted = !negotiating &&
          ((userId == partyA && acceptB) || (userId == partyB && acceptA));

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
        accept_a_at,
        accept_b_at,
        complete_a,
        complete_b,
        created_at,
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
      iProvide: xizmatOwnerId != null && xizmatOwnerId == viewerId,
      respondBy: status == KelishuvStatus.muzokarada
          ? _offeredAtOf(map)?.add(KelishuvRules.offerReplyWindow)
          : null,
    );
  }

  Future<Kelishuv?> fetchById(String id) async {
    if (isSimulatedKelishuvId(id)) {
      return DemoKelishuvSimulator.kelishuv(id);
    }

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
    final map = Map<String, dynamic>.from(row);
    if (!_offerLapsed(map)) return _mapRow(map);

    // Nobody answered in time: the offer is cancelled.
    await _cancelLapsedOffers(client, [id]);
    final fresh = await client.from('kelishuvlar').select('''
          *,
          xizmatlar ( name, owner_id ),
          yordam_kerak_posts ( title ),
          party_a:profiles!kelishuvlar_party_a_id_fkey ( full_name ),
          party_b:profiles!kelishuvlar_party_b_id_fkey ( full_name )
        ''').eq('id', id).maybeSingle();
    return _mapRow(Map<String, dynamic>.from(fresh ?? map));
  }

  /// When the terms on the table were offered: the latest acceptance (the
  /// sender's), else the deal's creation.
  static DateTime? _offeredAtOf(Map<String, dynamic> row) {
    DateTime? parse(Object? raw) =>
        raw is String ? DateTime.tryParse(raw) : null;
    final times = [
      if (row['accept_a'] == true) parse(row['accept_a_at']),
      if (row['accept_b'] == true) parse(row['accept_b_at']),
    ].whereType<DateTime>().toList();
    if (times.isEmpty) return parse(row['created_at']);
    return times.reduce((a, b) => a.isAfter(b) ? a : b);
  }

  /// An offer left unanswered past [KelishuvRules.offerReplyWindow].
  static bool _offerLapsed(Map<String, dynamic> row) {
    if (row['status'] != 'muzokarada') return false;
    final offeredAt = _offeredAtOf(row);
    if (offeredAt == null) return false;
    return DateTime.now()
        .isAfter(offeredAt.add(KelishuvRules.offerReplyWindow));
  }

  /// Cancels offers nobody answered in time. The server does the same on
  /// its schedule; this keeps the app right in between.
  Future<void> _cancelLapsedOffers(
    SupabaseClient client,
    List<String> ids,
  ) async {
    if (ids.isEmpty) return;
    try {
      await client
          .from('kelishuvlar')
          .update({
            'status': 'bekor',
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .inFilter('id', ids)
          .eq('status', 'muzokarada');
    } catch (_) {
      // Left as it was; the next load tries again.
    }
  }

  /// Active rows without the lapsed offers, which are cancelled on the way.
  Future<List<Map<String, dynamic>>> _withoutLapsedOffers(
    SupabaseClient client,
    List<dynamic> rows,
  ) async {
    final kept = <Map<String, dynamic>>[];
    final lapsed = <String>[];
    for (final raw in rows) {
      final map = Map<String, dynamic>.from(raw as Map);
      if (_offerLapsed(map)) {
        lapsed.add(map['id'] as String);
      } else {
        kept.add(map);
      }
    }
    await _cancelLapsedOffers(client, lapsed);
    return kept;
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
    final recurUntilRaw = map['recur_until'] as String?;
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
      offeredAt: _offeredAtOf(map),
      contact: DealContact.fromRow(map),
      recurRule: RecurRule.tryParse(map['recur_rule'] as String?),
      recurUntil: recurUntilRaw != null ? DateTime.tryParse(recurUntilRaw) : null,
    );
  }

  String _currentUserDisplayName(SupabaseClient client) {
    final user = client.auth.currentUser;
    final meta = user?.userMetadata?['full_name'] as String?;
    if (meta != null && meta.trim().isNotEmpty) return meta.trim();
    final email = user?.email;
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }
    return 'Siz';
  }

  /// Fetches deals that have a scheduled date — used by the calendar view.
  /// Stub: returns all active deals for the user; full implementation pending.
  Future<List<Kelishuv>> fetchAppointments(String userId) async {
    // TODO: filter by status and startDate IS NOT NULL server-side
    return const [];
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

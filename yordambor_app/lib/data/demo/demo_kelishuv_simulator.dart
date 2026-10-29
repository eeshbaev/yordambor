import 'package:yordambor/data/demo/demo_xizmat_feed.dart';
import 'package:yordambor/data/demo/demo_yordam_kerak_feed.dart';
import 'package:yordambor/data/kelishuv/kelishuv_exceptions.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/domain/entities/kelishuv_message.dart';
import 'package:yordambor/domain/entities/kelishuv_summary.dart';
import 'package:yordambor/core/l10n/current_strings.dart';

/// In-memory kelishuv for demo listings/posts (never sent to Supabase).
abstract final class DemoKelishuvSimulator {
  static final Map<String, Kelishuv> _kelishuvlar = {};
  static final Map<String, List<KelishuvMessage>> _messages = {};

  static Kelishuv? kelishuv(String id) => _kelishuvlar[id];

  static List<KelishuvSummary> summariesForUser(String userId) {
    final out = <KelishuvSummary>[];
    for (final k in _kelishuvlar.values) {
      if (!_involvesUser(k, userId)) continue;
      out.add(_toSummary(k, userId));
    }
    out.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return out;
  }

  static List<KelishuvMessage> messages(String kelishuvId) =>
      List.unmodifiable(_messages[kelishuvId] ?? const []);

  static void accept(String kelishuvId, String userId) {
    final current = _kelishuvlar[kelishuvId];
    if (current == null) throw KelishuvFailure(CurrentStrings.value.errDealNotFound);
    if (!current.isParty(userId)) {
      throw KelishuvFailure(CurrentStrings.value.errNoPermission);
    }

    var acceptA = current.acceptA;
    var acceptB = current.acceptB;
    if (userId == current.partyAId) acceptA = true;
    if (userId == current.partyBId) acceptB = true;

    final now = DateTime.now();
    final jarayonda = acceptA && acceptB;

    _kelishuvlar[kelishuvId] = Kelishuv(
      id: current.id,
      status: jarayonda ? KelishuvStatus.jarayonda : KelishuvStatus.muzokarada,
      partyAId: current.partyAId,
      partyBId: current.partyBId,
      initiatorId: current.initiatorId,
      xizmatId: current.xizmatId,
      yordamKerakPostId: current.yordamKerakPostId,
      message: current.message,
      price: current.price,
      currency: current.currency,
      startDate: current.startDate,
      durationMinutes: current.durationMinutes,
      acceptA: acceptA,
      acceptB: acceptB,
      completeA: current.completeA,
      completeB: current.completeB,
      otherPartyName: current.otherPartyName,
      partyAName: current.partyAName,
      partyBName: current.partyBName,
      xizmatName: current.xizmatName,
      postTitle: current.postTitle,
      createdAt: current.createdAt,
      updatedAt: now,
      xizmatOwnerId: current.xizmatOwnerId,
      jarayondaAt: jarayonda ? now : current.jarayondaAt,
      offeredAt: current.offeredAt,
      contact: current.contact,
    );
  }

  static void addMessage({
    required String kelishuvId,
    required String senderId,
    required String senderName,
    required String content,
  }) {
    if (_kelishuvlar[kelishuvId] == null) {
      throw KelishuvFailure(CurrentStrings.value.errDealNotFound);
    }
    final list = _messages.putIfAbsent(kelishuvId, () => []);
    list.add(
      KelishuvMessage(
        id: '$kelishuvId-msg-${list.length + 1}',
        kelishuvId: kelishuvId,
        senderId: senderId,
        content: content,
        createdAt: DateTime.now(),
        senderName: senderName,
      ),
    );
  }

  static Kelishuv createFromXizmat({
    required String xizmatId,
    required String clientUserId,
    required String clientDisplayName,
    required TaklifInput input,
  }) {
    final xizmat = DemoXizmatFeed.findById(xizmatId);
    if (xizmat == null) {
      throw KelishuvFailure(CurrentStrings.value.errServiceNotFound);
    }

    final ownerId = xizmat.ownerId ?? 'demo-user-unknown';
    if (ownerId == clientUserId) {
      throw KelishuvFailure(CurrentStrings.value.errOwnService);
    }

    final now = DateTime.now();
    final id = 'demo-kelishuv-${now.microsecondsSinceEpoch}';
    final ownerName = xizmat.displayOwnerName;

    final kelishuv = Kelishuv(
      id: id,
      status: KelishuvStatus.muzokarada,
      partyAId: clientUserId,
      partyBId: ownerId,
      initiatorId: clientUserId,
      xizmatId: xizmatId,
      message: _trimMessage(input.message),
      price: input.price,
      currency: input.price != null ? (input.currency ?? 'UZS') : null,
      startDate: input.startDate,
      durationMinutes: input.durationMinutes,
      // Sending the offer is the sender's acceptance; the other side
      // answers.
      acceptA: true,
      acceptB: false,
      partyAName: clientDisplayName,
      partyBName: ownerName,
      xizmatName: xizmat.serviceDisplayName,
      createdAt: now,
      updatedAt: now,
      xizmatOwnerId: ownerId,
      offeredAt: now,
      contact: input.contact,
    );

    _save(kelishuv, openingSenderId: clientUserId, openingSenderName: clientDisplayName);
    return kelishuv;
  }

  static Kelishuv createFromPost({
    required String postId,
    required String xizmatId,
    required String providerUserId,
    required String providerDisplayName,
    required String xizmatName,
    required TaklifInput input,
  }) {
    final post = DemoYordamKerakFeed.findById(postId);
    if (post == null) {
      throw KelishuvFailure(CurrentStrings.value.errRequestNotFound);
    }

    final authorId = post.authorId ?? 'demo-user-unknown';
    if (authorId == providerUserId) {
      throw KelishuvFailure(CurrentStrings.value.errOwnRequest);
    }

    final now = DateTime.now();
    final id = 'demo-kelishuv-${now.microsecondsSinceEpoch}';

    final kelishuv = Kelishuv(
      id: id,
      status: KelishuvStatus.muzokarada,
      partyAId: authorId,
      partyBId: providerUserId,
      initiatorId: providerUserId,
      xizmatId: xizmatId,
      yordamKerakPostId: postId,
      message: _trimMessage(input.message),
      price: input.price,
      currency: input.price != null ? (input.currency ?? 'UZS') : null,
      startDate: input.startDate,
      durationMinutes: input.durationMinutes,
      acceptA: false,
      acceptB: true,
      partyAName: post.authorName,
      partyBName: providerDisplayName,
      xizmatName: xizmatName,
      postTitle: post.title,
      createdAt: now,
      updatedAt: now,
      xizmatOwnerId: providerUserId,
      offeredAt: now,
      contact: input.contact,
    );

    _save(
      kelishuv,
      openingSenderId: providerUserId,
      openingSenderName: providerDisplayName,
    );
    return kelishuv;
  }

  static void _save(
    Kelishuv kelishuv, {
    required String openingSenderId,
    required String openingSenderName,
  }) {
    _kelishuvlar[kelishuv.id] = kelishuv;
    final content = kelishuv.message?.trim();
    if (content != null && content.isNotEmpty) {
      _messages[kelishuv.id] = [
        KelishuvMessage(
          id: '${kelishuv.id}-msg-1',
          kelishuvId: kelishuv.id,
          senderId: openingSenderId,
          content: content,
          createdAt: kelishuv.createdAt ?? DateTime.now(),
          senderName: openingSenderName,
        ),
      ];
    } else {
      _messages[kelishuv.id] = [];
    }
  }

  static String? _trimMessage(String? message) {
    final trimmed = message?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  static bool _involvesUser(Kelishuv k, String userId) =>
      k.partyAId == userId ||
      k.partyBId == userId ||
      k.initiatorId == userId;

  static KelishuvSummary _toSummary(Kelishuv k, String viewerId) {
    final isA = k.partyAId == viewerId;
    final otherName = isA ? (k.partyBName ?? 'Demo') : (k.partyAName ?? 'Demo');
    final needsMyAccept = isA ? !k.acceptA : !k.acceptB;

    return KelishuvSummary(
      id: k.id,
      status: k.status,
      xizmatId: k.xizmatId,
      xizmatName: k.xizmatName ?? 'Xizmat',
      otherPartyName: otherName,
      updatedAt: k.updatedAt ?? k.createdAt ?? DateTime.now(),
      message: k.message,
      postTitle: k.postTitle,
      price: k.price,
      currency: k.currency,
      durationMinutes: k.durationMinutes,
      needsMyAccept: needsMyAccept && k.status == KelishuvStatus.muzokarada,
      iProvide: k.xizmatOwnerId == viewerId,
      respondBy: k.respondBy,
    );
  }
}

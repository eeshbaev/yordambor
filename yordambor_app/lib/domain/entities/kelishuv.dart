import 'package:yordambor/core/l10n/current_strings.dart';

/// Rules of a deal that both the app and the server keep.
abstract final class KelishuvRules {
  /// An offer that gets no answer (accept, decline or new terms) in this
  /// time is cancelled.
  static const offerReplyWindow = Duration(days: 10);
}

enum KelishuvStatus {
  muzokarada,
  jarayonda,
  bajarildi,
  bekor,
  rad,
  archived,
}


/// How often a recurring appointment repeats.
enum RecurRule {
  /// Every 7 days.
  weekly,

  /// Every 14 days (fortnightly).
  biweekly,

  /// Same day of month, next calendar month.
  monthly;

  /// Converts a DB string to a [RecurRule], or null if unrecognised.
  static RecurRule? tryParse(String? raw) => switch (raw) {
        'weekly' => RecurRule.weekly,
        'biweekly' => RecurRule.biweekly,
        'monthly' => RecurRule.monthly,
        _ => null,
      };
}
class Kelishuv {
  const Kelishuv({
    required this.id,
    required this.status,
    required this.partyAId,
    required this.partyBId,
    required this.initiatorId,
    this.xizmatId,
    this.yordamKerakPostId,
    this.message,
    this.price,
    this.currency,
    this.startDate,
    this.startHasTime = false,
    this.durationMinutes,
    this.acceptA = false,
    this.acceptB = false,
    this.completeA = false,
    this.completeB = false,
    this.otherPartyName,
    this.partyAName,
    this.partyBName,
    this.partyAAvatarUrl,
    this.partyBAvatarUrl,
    this.xizmatName,
    this.postTitle,
    this.createdAt,
    this.updatedAt,
    this.xizmatOwnerId,
    this.jarayondaAt,
    this.offeredAt,
    this.contact,
    this.serviceCategoryId,
    this.serviceSubcategoryId,
    this.recurRule,
    this.recurUntil,
  });

  final String id;
  final KelishuvStatus status;
  final String partyAId;
  final String partyBId;
  final String initiatorId;
  final String? xizmatId;
  final String? yordamKerakPostId;
  final String? message;
  final double? price;
  final String? currency;
  /// The agreed day, with its time of day when [startHasTime].
  final DateTime? startDate;

  /// A time of day was agreed (`start_time`), not only the day.
  final bool startHasTime;
  final int? durationMinutes;
  final bool acceptA;
  final bool acceptB;
  final bool completeA;
  final bool completeB;
  final String? otherPartyName;
  final String? partyAName;
  final String? partyBName;
  final String? partyAAvatarUrl;
  final String? partyBAvatarUrl;
  final String? xizmatName;
  final String? postTitle;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? xizmatOwnerId;
  final DateTime? jarayondaAt;

  /// When the terms on the table were offered: the sender's acceptance, or
  /// the deal's creation.
  final DateTime? offeredAt;

  /// The card the person who started the deal sent with it: their name and
  /// phone, for the other side to reach them.
  final DealContact? contact;

  /// The trade of the service or help request, for its icon.
  final String? serviceCategoryId;
  final String? serviceSubcategoryId;

  /// If set the appointment repeats on this cadence until [recurUntil].
  final RecurRule? recurRule;

  /// The last date (inclusive) an occurrence may start on. Null means open-ended.
  final DateTime? recurUntil;

  /// While terms wait for an answer: the moment they lapse.
  DateTime? get respondBy {
    if (status != KelishuvStatus.muzokarada) return null;
    final from = offeredAt ?? createdAt;
    return from?.add(KelishuvRules.offerReplyWindow);
  }

  /// The offer lapsed without an answer.
  bool offerExpiredAt(DateTime now) {
    final deadline = respondBy;
    return deadline != null && now.isAfter(deadline);
  }

  /// Whole days left to answer, at least 1 while the offer stands.
  int? daysLeftToRespond(DateTime now) {
    final deadline = respondBy;
    if (deadline == null || now.isAfter(deadline)) return null;
    final days = (deadline.difference(now).inHours / 24).ceil();
    return days < 1 ? 1 : days;
  }

  bool canRepeatBook(String userId) {
    if (xizmatId == null || xizmatOwnerId == null) return false;
    if (status != KelishuvStatus.bajarildi) return false;
    return isClient(userId);
  }

  bool isProvider(String userId) => xizmatOwnerId == userId;

  bool isClient(String userId) =>
      xizmatOwnerId != null && xizmatOwnerId != userId && isParty(userId);

  bool get isActive =>
      status == KelishuvStatus.muzokarada ||
      status == KelishuvStatus.jarayonda;

  bool get isClosed =>
      status == KelishuvStatus.bajarildi ||
      status == KelishuvStatus.bekor ||
      status == KelishuvStatus.rad ||
      status == KelishuvStatus.archived;

  String otherPartyNameFor(String userId) {
    if (userId == partyAId) {
      return partyBName ?? CurrentStrings.value.fallbackUserName;
    }
    if (userId == partyBId) {
      return partyAName ?? CurrentStrings.value.fallbackUserName;
    }
    return otherPartyName ?? CurrentStrings.value.fallbackUserName;
  }

  /// The other side of the deal for [userId].
  String otherPartyIdFor(String userId) =>
      userId == partyAId ? partyBId : partyAId;

  String? otherPartyAvatarFor(String userId) =>
      userId == partyAId ? partyBAvatarUrl : partyAAvatarUrl;

  /// The card the other side sent with the deal, when they started it.
  DealContact? otherPartyContactFor(String userId) =>
      initiatorId != userId ? contact : null;

  bool isParty(String userId) => userId == partyAId || userId == partyBId;

  bool hasAccepted(String userId) {
    if (userId == partyAId) return acceptA;
    if (userId == partyBId) return acceptB;
    return false;
  }

  bool hasMarkedComplete(String userId) {
    if (userId == partyAId) return completeA;
    if (userId == partyBId) return completeB;
    return false;
  }

  bool get isDualAccepted => acceptA && acceptB;

  bool get isDualComplete => completeA && completeB;

  bool awaitingMyComplete(String userId) {
    if (status != KelishuvStatus.jarayonda || !isParty(userId)) return false;
    if (hasMarkedComplete(userId)) return false;
    return completeA || completeB;
  }

  bool canMarkComplete(String userId) {
    if (status != KelishuvStatus.jarayonda || !isParty(userId)) return false;
    if (hasMarkedComplete(userId)) return false;
    if (jarayondaAt == null) return true;
    return DateTime.now().difference(jarayondaAt!).inDays >= 3;
  }

  int? daysUntilCanComplete(String userId) {
    if (status != KelishuvStatus.jarayonda || !isParty(userId)) return null;
    if (hasMarkedComplete(userId) || jarayondaAt == null) return null;
    final remaining = 3 - DateTime.now().difference(jarayondaAt!).inDays;
    return remaining > 0 ? remaining : null;
  }

  bool canEditTerms(String userId) {
    if (!isParty(userId) || !isActive) return false;
    if (status == KelishuvStatus.muzokarada) return true;
    if (status == KelishuvStatus.jarayonda) {
      if (jarayondaAt == null) return true;
      return DateTime.now().difference(jarayondaAt!).inDays <= 3;
    }
    return false;
  }

  // ── Recurrence helpers ──────────────────────────────────────────
  /// Returns every occurrence start-time within [from..to] (inclusive).
  /// The base [startDate] is always the first item when it falls in range.
  /// Returns an empty list when [recurRule] is null or [startDate] is null.
  List<DateTime> expandOccurrences(DateTime from, DateTime to) {
    final base = startDate;
    final rule = recurRule;
    if (base == null || rule == null) return base != null && !base.isBefore(from) && !base.isAfter(to) ? [base] : [];

    final results = <DateTime>[];
    var current = base;
    final until = recurUntil;

    while (!current.isAfter(to)) {
      final effectiveTo = until != null && until.isBefore(to) ? until : to;
      if (current.isAfter(effectiveTo)) break;
      if (!current.isBefore(from)) results.add(current);
      current = switch (rule) {
        RecurRule.weekly => current.add(const Duration(days: 7)),
        RecurRule.biweekly => current.add(const Duration(days: 14)),
        RecurRule.monthly => _addMonth(current),
      };
    }
    return results;
  }

  static DateTime _addMonth(DateTime dt) {
    final month = dt.month == 12 ? 1 : dt.month + 1;
    final year = dt.month == 12 ? dt.year + 1 : dt.year;
    // Clamp the day to the last day of the new month.
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = dt.day > lastDay ? lastDay : dt.day;
    return DateTime(year, month, day, dt.hour, dt.minute, dt.second);
  }
}

class TaklifInput {
  const TaklifInput({
    this.message,
    this.price,
    this.currency,
    this.startDate,
    this.durationMinutes,
    this.contact,
    this.recurRule,
    this.recurUntil,
  });

  final String? message;
  final double? price;
  final String? currency;
  final DateTime? startDate;
  final int? durationMinutes;

  /// The sender's card, prefilled from their profile.
  final DealContact? contact;

  /// Recurrence cadence for this appointment (optional).
  final RecurRule? recurRule;

  /// Last date an occurrence may start on (optional, requires [recurRule]).
  final DateTime? recurUntil;
}

/// Who sent a request and how to reach them.
class DealContact {
  const DealContact({
    required this.firstName,
    required this.phone,
    this.lastName,
  });

  final String firstName;
  final String? lastName;
  final String phone;

  /// "Erkin Eshbaev".
  String get fullName => [firstName, lastName ?? '']
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .join(' ');

  /// "Erkin Eshbaev · +998 90 123 45 67".
  String get line => '$fullName · $phone';

  /// The card stored with a deal, or null when it is incomplete.
  static DealContact? fromRow(Map<String, dynamic> row) {
    final first = (row['contact_first_name'] as String?)?.trim() ?? '';
    final phone = (row['contact_phone'] as String?)?.trim() ?? '';
    if (first.isEmpty || phone.isEmpty) return null;
    final last = (row['contact_last_name'] as String?)?.trim();
    return DealContact(
      firstName: first,
      lastName: last == null || last.isEmpty ? null : last,
      phone: phone,
    );
  }
}

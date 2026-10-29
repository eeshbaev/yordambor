import 'package:yordambor/core/utils/money_format.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';

class KelishuvSummary {
  const KelishuvSummary({
    required this.id,
    required this.status,
    required this.xizmatId,
    required this.xizmatName,
    required this.otherPartyName,
    required this.updatedAt,
    this.message,
    this.postTitle,
    this.price,
    this.currency,
    this.durationMinutes,
    this.canRepeatBook = false,
    this.needsMyAccept = false,
    this.needsMyComplete = false,
    this.iProvide = false,
    this.respondBy,
  });

  final String id;
  final KelishuvStatus status;
  final String? xizmatId;
  final String xizmatName;
  final String otherPartyName;
  final DateTime updatedAt;
  final String? message;
  final String? postTitle;
  final double? price;
  final String? currency;
  final int? durationMinutes;
  final bool canRepeatBook;
  final bool needsMyAccept;
  final bool needsMyComplete;

  /// The viewer gives the service in this deal (else they asked for it).
  final bool iProvide;

  /// While an offer waits for an answer: when it lapses.
  final DateTime? respondBy;

  /// Whole days left before an unanswered offer is cancelled.
  int? daysLeftToRespond(DateTime now) {
    final deadline = respondBy;
    if (deadline == null || now.isAfter(deadline)) return null;
    final days = (deadline.difference(now).inHours / 24).ceil();
    return days < 1 ? 1 : days;
  }

  /// "120 000 soʻm".
  String get priceLabel {
    if (price == null) return '';
    return formatMoney(price!, currency);
  }
}

class KelishuvInboxGroup {
  const KelishuvInboxGroup({
    required this.xizmatId,
    required this.xizmatName,
    required this.items,
  });

  final String xizmatId;
  final String xizmatName;
  final List<KelishuvSummary> items;

  int get activeCount => items.length;
}

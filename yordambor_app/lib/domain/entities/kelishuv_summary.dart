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

  String get priceLabel {
    if (price == null) return '';
    return '${price!.toStringAsFixed(0)} ${currency ?? 'UZS'}';
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

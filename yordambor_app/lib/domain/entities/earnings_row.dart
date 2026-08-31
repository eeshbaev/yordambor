class EarningsRow {
  const EarningsRow({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    required this.recordedAt,
    this.xizmatId,
    this.xizmatName,
    this.kelishuvId,
    this.bookingId,
    this.note,
  });

  final String id;
  final double amount;
  final String currency;
  final String status;
  final DateTime recordedAt;
  final String? xizmatId;
  final String? xizmatName;
  final String? kelishuvId;
  final String? bookingId;
  final String? note;

  Map<String, dynamic> toMap() => {
        'id': id,
        'amount': amount,
        'currency': currency,
        'status': status,
        'recordedAt': recordedAt.toIso8601String(),
        'xizmatId': xizmatId,
        'xizmatName': xizmatName,
        'kelishuvId': kelishuvId,
        'bookingId': bookingId,
        'note': note,
      };

  factory EarningsRow.fromMap(Map<dynamic, dynamic> map) {
    return EarningsRow(
      id: map['id'] as String,
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] as String? ?? 'UZS',
      status: map['status'] as String? ?? 'e_lon_qilingan',
      recordedAt: DateTime.parse(map['recordedAt'] as String),
      xizmatId: map['xizmatId'] as String?,
      xizmatName: map['xizmatName'] as String?,
      kelishuvId: map['kelishuvId'] as String?,
      bookingId: map['bookingId'] as String?,
      note: map['note'] as String?,
    );
  }

  EarningsRow copyWith({
    double? amount,
    String? currency,
    String? note,
    DateTime? recordedAt,
  }) {
    return EarningsRow(
      id: id,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status,
      recordedAt: recordedAt ?? this.recordedAt,
      xizmatId: xizmatId,
      xizmatName: xizmatName,
      kelishuvId: kelishuvId,
      bookingId: bookingId,
      note: note ?? this.note,
    );
  }
}

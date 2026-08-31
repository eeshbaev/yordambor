import 'package:yordambor/domain/entities/booking_delivery_status.dart';

class ClientBookEntry {
  const ClientBookEntry({
    required this.id,
    required this.clientName,
    required this.createdAt,
    this.xizmatId,
    this.xizmatName,
    this.kelishuvId,
    this.slotStart,
    this.phone,
    this.note,
    this.deliveryStatus,
    this.amount,
  });

  final String id;
  final String clientName;
  final String? xizmatId;
  final String? xizmatName;
  final String? kelishuvId;
  final DateTime? slotStart;
  final String? phone;
  final String? note;
  final BookingDeliveryStatus? deliveryStatus;
  final double? amount;
  final DateTime createdAt;

  bool get isBooking => slotStart != null;
  bool get isDelivered => deliveryStatus == BookingDeliveryStatus.completed;

  Map<String, dynamic> toMap() => {
        'id': id,
        'clientName': clientName,
        'xizmatId': xizmatId,
        'xizmatName': xizmatName,
        'kelishuvId': kelishuvId,
        'slotStart': slotStart?.toIso8601String(),
        'phone': phone,
        'note': note,
        'deliveryStatus': deliveryStatus?.storageValue,
        'amount': amount,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ClientBookEntry.fromMap(Map<dynamic, dynamic> map) {
    return ClientBookEntry(
      id: map['id'] as String,
      clientName: map['clientName'] as String,
      xizmatId: map['xizmatId'] as String?,
      xizmatName: map['xizmatName'] as String?,
      kelishuvId: map['kelishuvId'] as String?,
      slotStart: map['slotStart'] != null
          ? DateTime.tryParse(map['slotStart'] as String)
          : null,
      phone: map['phone'] as String?,
      note: map['note'] as String?,
      deliveryStatus:
          BookingDeliveryStatus.fromStorage(map['deliveryStatus'] as String?),
      amount: map['amount'] != null ? (map['amount'] as num).toDouble() : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  ClientBookEntry copyWith({
    String? clientName,
    String? phone,
    String? note,
    String? xizmatId,
    String? xizmatName,
    String? kelishuvId,
    DateTime? slotStart,
    bool clearSlotStart = false,
    BookingDeliveryStatus? deliveryStatus,
    bool clearDeliveryStatus = false,
    double? amount,
    bool clearAmount = false,
  }) {
    return ClientBookEntry(
      id: id,
      clientName: clientName ?? this.clientName,
      xizmatId: xizmatId ?? this.xizmatId,
      xizmatName: xizmatName ?? this.xizmatName,
      kelishuvId: kelishuvId ?? this.kelishuvId,
      slotStart: clearSlotStart ? null : (slotStart ?? this.slotStart),
      phone: phone ?? this.phone,
      note: note ?? this.note,
      deliveryStatus: clearDeliveryStatus
          ? null
          : (deliveryStatus ?? this.deliveryStatus),
      amount: clearAmount ? null : (amount ?? this.amount),
      createdAt: createdAt,
    );
  }
}

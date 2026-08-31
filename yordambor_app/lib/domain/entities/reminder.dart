import 'package:yordambor/domain/entities/appointment_status.dart';

class Reminder {
  const Reminder({
    required this.id,
    required this.title,
    required this.scheduledAt,
    required this.status,
    this.body,
    this.kelishuvId,
    this.bookingId,
    this.clientId,
    this.isAuto = false,
    this.createdAt,
  });

  final String id;
  final String title;
  final String? body;
  final DateTime scheduledAt;
  final AppointmentStatus status;
  final String? kelishuvId;
  final String? bookingId;
  final String? clientId;
  final bool isAuto;
  final DateTime? createdAt;

  bool get isPast => scheduledAt.isBefore(DateTime.now());
  bool get isLinkedToBooking => bookingId != null;
  bool get isActive => status.isActive;

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'scheduledAt': scheduledAt.toIso8601String(),
        'status': status.storageValue,
        'kelishuvId': kelishuvId,
        'bookingId': bookingId,
        'clientId': clientId,
        'isAuto': isAuto,
        'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
      };

  factory Reminder.fromMap(Map<dynamic, dynamic> map) {
    return Reminder(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String?,
      scheduledAt: DateTime.parse(map['scheduledAt'] as String),
      status: AppointmentStatus.fromStorage(map['status'] as String?),
      kelishuvId: map['kelishuvId'] as String?,
      bookingId: map['bookingId'] as String?,
      clientId: map['clientId'] as String?,
      isAuto: map['isAuto'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
    );
  }

  Reminder copyWith({
    String? title,
    String? body,
    DateTime? scheduledAt,
    AppointmentStatus? status,
    String? bookingId,
    String? clientId,
  }) {
    return Reminder(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      kelishuvId: kelishuvId,
      bookingId: bookingId ?? this.bookingId,
      clientId: clientId ?? this.clientId,
      isAuto: isAuto,
      createdAt: createdAt,
    );
  }
}

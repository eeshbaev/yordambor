class ClientRegistryEntry {
  const ClientRegistryEntry({
    required this.id,
    required this.clientName,
    required this.createdAt,
    this.phone,
    this.note,
    this.yordamBorUserId,
    this.isDeleted = false,
  });

  final String id;
  final String clientName;
  final String? phone;
  final String? note;
  final String? yordamBorUserId;
  final bool isDeleted;
  final DateTime createdAt;

  Map<String, dynamic> toMap() => {
        'id': id,
        'clientName': clientName,
        'phone': phone,
        'note': note,
        'yordamBorUserId': yordamBorUserId,
        'isDeleted': isDeleted,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ClientRegistryEntry.fromMap(Map<dynamic, dynamic> map) {
    return ClientRegistryEntry(
      id: map['id'] as String,
      clientName: map['clientName'] as String,
      phone: map['phone'] as String?,
      note: map['note'] as String?,
      yordamBorUserId: map['yordamBorUserId'] as String?,
      isDeleted: map['isDeleted'] as bool? ?? false,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  ClientRegistryEntry copyWith({
    String? clientName,
    String? phone,
    String? note,
    String? yordamBorUserId,
    bool? isDeleted,
  }) {
    return ClientRegistryEntry(
      id: id,
      clientName: clientName ?? this.clientName,
      phone: phone ?? this.phone,
      note: note ?? this.note,
      yordamBorUserId: yordamBorUserId ?? this.yordamBorUserId,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt,
    );
  }
}

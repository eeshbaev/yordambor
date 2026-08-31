class Booking {
  const Booking({
    required this.id,
    required this.clientId,
    required this.slotStart,
    required this.createdAt,
    this.xizmatId,
    this.xizmatName,
    this.kelishuvId,
    this.note,
    this.appointmentNotes,
    this.photoPaths = const [],
    this.isReceiverSide = false,
  });

  final String id;
  final String clientId;
  final DateTime slotStart;
  final String? xizmatId;
  final String? xizmatName;
  final String? kelishuvId;
  final String? note;
  final String? appointmentNotes;
  final List<String> photoPaths;
  final bool isReceiverSide;
  final DateTime createdAt;

  Map<String, dynamic> toMap() => {
        'id': id,
        'clientId': clientId,
        'slotStart': slotStart.toIso8601String(),
        'xizmatId': xizmatId,
        'xizmatName': xizmatName,
        'kelishuvId': kelishuvId,
        'note': note,
        'appointmentNotes': appointmentNotes,
        'photoPaths': photoPaths,
        'isReceiverSide': isReceiverSide,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Booking.fromMap(Map<dynamic, dynamic> map) {
    final rawPhotos = map['photoPaths'];
    return Booking(
      id: map['id'] as String,
      clientId: map['clientId'] as String,
      slotStart: DateTime.parse(map['slotStart'] as String),
      xizmatId: map['xizmatId'] as String?,
      xizmatName: map['xizmatName'] as String?,
      kelishuvId: map['kelishuvId'] as String?,
      note: map['note'] as String?,
      appointmentNotes: map['appointmentNotes'] as String?,
      photoPaths: rawPhotos is List
          ? rawPhotos.map((path) => path.toString()).toList()
          : const [],
      isReceiverSide: map['isReceiverSide'] as bool? ?? false,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Booking copyWith({
    String? clientId,
    DateTime? slotStart,
    String? xizmatName,
    String? note,
    String? appointmentNotes,
    List<String>? photoPaths,
  }) {
    return Booking(
      id: id,
      clientId: clientId ?? this.clientId,
      slotStart: slotStart ?? this.slotStart,
      xizmatId: xizmatId,
      xizmatName: xizmatName ?? this.xizmatName,
      kelishuvId: kelishuvId,
      note: note ?? this.note,
      appointmentNotes: appointmentNotes ?? this.appointmentNotes,
      photoPaths: photoPaths ?? this.photoPaths,
      isReceiverSide: isReceiverSide,
      createdAt: createdAt,
    );
  }
}

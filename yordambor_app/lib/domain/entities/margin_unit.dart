class MarginUnit {
  const MarginUnit({
    required this.id,
    required this.name,
    required this.unitCostUzs,
    this.basisLabel,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final double unitCostUzs;
  final String? basisLabel;
  final DateTime updatedAt;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'unitCostUzs': unitCostUzs,
        'basisLabel': basisLabel,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory MarginUnit.fromMap(Map<dynamic, dynamic> map) {
    return MarginUnit(
      id: map['id'] as String,
      name: map['name'] as String,
      unitCostUzs: (map['unitCostUzs'] as num).toDouble(),
      basisLabel: map['basisLabel'] as String?,
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  MarginUnit copyWith({
    String? name,
    double? unitCostUzs,
    String? basisLabel,
    DateTime? updatedAt,
  }) {
    return MarginUnit(
      id: id,
      name: name ?? this.name,
      unitCostUzs: unitCostUzs ?? this.unitCostUzs,
      basisLabel: basisLabel ?? this.basisLabel,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

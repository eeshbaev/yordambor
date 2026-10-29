class MarginProductLine {
  const MarginProductLine({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitCostUzs,
    this.unitId,
    this.quantityLabel,
  });

  final String id;
  final String name;
  final double quantity;
  final double unitCostUzs;
  final String? unitId;
  final String? quantityLabel;

  double get lineCostUzs => quantity * unitCostUzs;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'quantity': quantity,
        'unitCostUzs': unitCostUzs,
        'unitId': unitId,
        'quantityLabel': quantityLabel,
      };

  factory MarginProductLine.fromMap(Map<dynamic, dynamic> map) {
    return MarginProductLine(
      id: map['id'] as String,
      name: map['name'] as String,
      quantity: (map['quantity'] as num).toDouble(),
      unitCostUzs: (map['unitCostUzs'] as num).toDouble(),
      unitId: map['unitId'] as String?,
      quantityLabel: map['quantityLabel'] as String?,
    );
  }

  MarginProductLine copyWith({
    String? name,
    double? quantity,
    double? unitCostUzs,
    String? unitId,
    String? quantityLabel,
  }) {
    return MarginProductLine(
      id: id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unitCostUzs: unitCostUzs ?? this.unitCostUzs,
      unitId: unitId ?? this.unitId,
      quantityLabel: quantityLabel ?? this.quantityLabel,
    );
  }
}

class MarginProduct {
  const MarginProduct({
    required this.id,
    required this.name,
    required this.salePriceUzs,
    required this.lines,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final double salePriceUzs;
  final List<MarginProductLine> lines;
  final DateTime updatedAt;

  double get totalCostUzs =>
      lines.fold<double>(0, (sum, line) => sum + line.lineCostUzs);

  double get profitUzs => salePriceUzs - totalCostUzs;

  double get marginPercent =>
      salePriceUzs > 0 ? (profitUzs / salePriceUzs) * 100 : 0;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'salePriceUzs': salePriceUzs,
        'lines': lines.map((e) => e.toMap()).toList(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory MarginProduct.fromMap(Map<dynamic, dynamic> map) {
    final rawLines = map['lines'] as List<dynamic>? ?? [];
    return MarginProduct(
      id: map['id'] as String,
      name: map['name'] as String,
      salePriceUzs: (map['salePriceUzs'] as num).toDouble(),
      lines: rawLines
          .map((e) => MarginProductLine.fromMap(Map<dynamic, dynamic>.from(e)))
          .toList(),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  MarginProduct copyWith({
    String? name,
    double? salePriceUzs,
    List<MarginProductLine>? lines,
    DateTime? updatedAt,
  }) {
    return MarginProduct(
      id: id,
      name: name ?? this.name,
      salePriceUzs: salePriceUzs ?? this.salePriceUzs,
      lines: lines ?? this.lines,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

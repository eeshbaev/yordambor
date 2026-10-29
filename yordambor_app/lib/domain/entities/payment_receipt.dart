enum ReceiptCurrency { uzs, usd }

class ReceiptLine {
  const ReceiptLine({
    required this.id,
    required this.title,
    required this.quantity,
    required this.unitPrice,
  });

  final String id;
  final String title;
  final double quantity;
  final double unitPrice;

  double get lineTotal => quantity * unitPrice;

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'quantity': quantity,
        'unitPrice': unitPrice,
      };

  factory ReceiptLine.fromMap(Map<dynamic, dynamic> map) {
    return ReceiptLine(
      id: map['id'] as String,
      title: map['title'] as String,
      quantity: (map['quantity'] as num).toDouble(),
      unitPrice: (map['unitPrice'] as num).toDouble(),
    );
  }

  ReceiptLine copyWith({
    String? title,
    double? quantity,
    double? unitPrice,
  }) {
    return ReceiptLine(
      id: id,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}

class PaymentReceipt {
  const PaymentReceipt({
    required this.id,
    required this.number,
    required this.createdAt,
    required this.sellerName,
    required this.sellerPhone,
    required this.buyerName,
    required this.buyerPhone,
    required this.xizmatId,
    required this.xizmatName,
    required this.currency,
    required this.lines,
    required this.discount,
    required this.taxEnabled,
    required this.taxRate,
    required this.taxLabel,
    required this.subtotal,
    required this.taxAmount,
    required this.total,
    this.clientId,
    this.note,
    this.dueDate,
  });

  final String id;
  final String number;
  final DateTime createdAt;
  final String sellerName;
  final String sellerPhone;
  final String buyerName;
  final String buyerPhone;
  final String? clientId;
  final String xizmatId;
  final String xizmatName;
  final ReceiptCurrency currency;
  final List<ReceiptLine> lines;
  final double discount;
  final bool taxEnabled;
  final double taxRate;
  final String taxLabel;
  final double subtotal;
  final double taxAmount;
  final double total;
  final String? note;
  final DateTime? dueDate;

  Map<String, dynamic> toMap() => {
        'id': id,
        'number': number,
        'createdAt': createdAt.toIso8601String(),
        'sellerName': sellerName,
        'sellerPhone': sellerPhone,
        'buyerName': buyerName,
        'buyerPhone': buyerPhone,
        'clientId': clientId,
        'xizmatId': xizmatId,
        'xizmatName': xizmatName,
        'currency': currency.name,
        'lines': lines.map((l) => l.toMap()).toList(),
        'discount': discount,
        'taxEnabled': taxEnabled,
        'taxRate': taxRate,
        'taxLabel': taxLabel,
        'subtotal': subtotal,
        'taxAmount': taxAmount,
        'total': total,
        'note': note,
        'dueDate': dueDate?.toIso8601String(),
      };

  factory PaymentReceipt.fromMap(Map<dynamic, dynamic> map) {
    final linesRaw = map['lines'] as List<dynamic>? ?? [];
    return PaymentReceipt(
      id: map['id'] as String,
      number: map['number'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      sellerName: map['sellerName'] as String,
      sellerPhone: map['sellerPhone'] as String,
      buyerName: map['buyerName'] as String,
      buyerPhone: map['buyerPhone'] as String,
      clientId: map['clientId'] as String?,
      xizmatId: map['xizmatId'] as String,
      xizmatName: map['xizmatName'] as String,
      currency: ReceiptCurrency.values.byName(map['currency'] as String),
      lines: linesRaw
          .map((e) => ReceiptLine.fromMap(Map<dynamic, dynamic>.from(e as Map)))
          .toList(),
      discount: (map['discount'] as num?)?.toDouble() ?? 0,
      taxEnabled: map['taxEnabled'] as bool? ?? false,
      taxRate: (map['taxRate'] as num?)?.toDouble() ?? 0,
      taxLabel: map['taxLabel'] as String? ?? '',
      subtotal: (map['subtotal'] as num).toDouble(),
      taxAmount: (map['taxAmount'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
      note: map['note'] as String?,
      dueDate: map['dueDate'] != null
          ? DateTime.parse(map['dueDate'] as String)
          : null,
    );
  }
}

ReceiptTotals computeReceiptTotals({
  required List<ReceiptLine> lines,
  required double discount,
  required bool taxEnabled,
  required double taxRate,
}) {
  final subtotal =
      lines.fold<double>(0, (sum, line) => sum + line.lineTotal);
  final afterDiscount =
      (subtotal - discount).clamp(0.0, double.infinity).toDouble();
  final taxAmount =
      taxEnabled ? afterDiscount * (taxRate / 100) : 0.0;
  return ReceiptTotals(
    subtotal: subtotal,
    afterDiscount: afterDiscount,
    taxAmount: taxAmount,
    total: afterDiscount + taxAmount,
  );
}

class ReceiptTotals {
  const ReceiptTotals({
    required this.subtotal,
    required this.afterDiscount,
    required this.taxAmount,
    required this.total,
  });

  final double subtotal;
  final double afterDiscount;
  final double taxAmount;
  final double total;
}

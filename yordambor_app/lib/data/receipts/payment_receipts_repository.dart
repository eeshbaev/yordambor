import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:yordambor/domain/entities/payment_receipt.dart';

class PaymentReceiptsRepository {
  static const boxName = 'payment_receipts';
  static const metaBoxName = 'payment_receipts_meta';

  Future<Box<Map>> _box() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Map>(boxName);
    }
    return Hive.openBox<Map>(boxName);
  }

  Future<Box> _metaBox() async {
    if (Hive.isBoxOpen(metaBoxName)) {
      return Hive.box(metaBoxName);
    }
    return Hive.openBox(metaBoxName);
  }

  Future<String> nextReceiptNumber() async {
    final meta = await _metaBox();
    final year = DateTime.now().year;
    final key = 'seq_$year';
    final next = (meta.get(key) as int? ?? 0) + 1;
    await meta.put(key, next);
    return 'YB-$year-${next.toString().padLeft(4, '0')}';
  }

  Future<List<PaymentReceipt>> fetchAll() async {
    final box = await _box();
    return box.values
        .map((raw) => PaymentReceipt.fromMap(Map<dynamic, dynamic>.from(raw)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<PaymentReceipt?> fetchById(String id) async {
    final box = await _box();
    final raw = box.get(id);
    if (raw == null) return null;
    return PaymentReceipt.fromMap(Map<dynamic, dynamic>.from(raw));
  }

  Future<PaymentReceipt> save(PaymentReceipt receipt) async {
    final box = await _box();
    await box.put(receipt.id, receipt.toMap());
    return receipt;
  }

  Future<PaymentReceipt> create({
    required String sellerName,
    required String sellerPhone,
    required String buyerName,
    required String buyerPhone,
    String? clientId,
    required String xizmatId,
    required String xizmatName,
    required ReceiptCurrency currency,
    required List<ReceiptLine> lines,
    required double discount,
    required bool taxEnabled,
    required double taxRate,
    required String taxLabel,
    String? note,
    DateTime? dueDate,
  }) async {
    final totals = computeReceiptTotals(
      lines: lines,
      discount: discount,
      taxEnabled: taxEnabled,
      taxRate: taxRate,
    );
    final receipt = PaymentReceipt(
      id: const Uuid().v4(),
      number: await nextReceiptNumber(),
      createdAt: DateTime.now(),
      sellerName: sellerName,
      sellerPhone: sellerPhone,
      buyerName: buyerName.trim(),
      buyerPhone: buyerPhone.trim(),
      clientId: clientId,
      xizmatId: xizmatId,
      xizmatName: xizmatName,
      currency: currency,
      lines: lines,
      discount: discount,
      taxEnabled: taxEnabled,
      taxRate: taxRate,
      taxLabel: taxLabel.trim(),
      subtotal: totals.subtotal,
      taxAmount: totals.taxAmount,
      total: totals.total,
      note: note?.trim().isEmpty == true ? null : note?.trim(),
      dueDate: dueDate,
    );
    return save(receipt);
  }

  Future<void> delete(String id) async {
    final box = await _box();
    await box.delete(id);
  }
}

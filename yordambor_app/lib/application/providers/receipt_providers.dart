import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/data/receipts/payment_receipts_repository.dart';
import 'package:yordambor/domain/entities/payment_receipt.dart';

final paymentReceiptsRepositoryProvider =
    Provider<PaymentReceiptsRepository>((ref) {
  return PaymentReceiptsRepository();
});

final paymentReceiptsProvider = FutureProvider<List<PaymentReceipt>>((ref) {
  return ref.watch(paymentReceiptsRepositoryProvider).fetchAll();
});

final paymentReceiptProvider =
    FutureProvider.family<PaymentReceipt?, String>((ref, id) {
  return ref.watch(paymentReceiptsRepositoryProvider).fetchById(id);
});

/// Profile tile subtitle: primary service name or count summary.
final receiptToolSubtitleProvider = Provider<String>((ref) {
  final strings = ref.watch(appStringsProvider);
  final async = ref.watch(myXizmatlarProvider);
  return async.maybeWhen(
    data: (items) {
      if (items.isEmpty) return strings.createXizmatFirst;
      if (items.length == 1) return items.first.serviceDisplayName;
      return '${items.first.serviceDisplayName} · ${items.length}';
    },
    orElse: () => strings.profilePaymentReceiptSub,
  );
});

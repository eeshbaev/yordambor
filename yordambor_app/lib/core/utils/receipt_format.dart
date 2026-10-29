import 'package:intl/intl.dart';
import 'package:yordambor/core/utils/money_format.dart';
import 'package:yordambor/domain/entities/payment_receipt.dart';

String formatReceiptMoney(double amount, ReceiptCurrency currency) {
  switch (currency) {
    case ReceiptCurrency.usd:
      return NumberFormat.currency(symbol: r'$', decimalDigits: 2)
          .format(amount);
    case ReceiptCurrency.uzs:
      return formatSom(amount);
  }
}

String formatReceiptDate(DateTime date) {
  return DateFormat('dd.MM.yyyy').format(date);
}

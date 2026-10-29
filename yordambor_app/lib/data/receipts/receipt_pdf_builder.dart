import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/receipt_format.dart';
import 'package:yordambor/domain/entities/payment_receipt.dart';

class ReceiptPdfBuilder {
  static const _logoAsset = 'assets/logo/yordambor-logo.png';
  static const _fontAsset = 'assets/fonts/Onest-Regular.ttf';
  static const _boldFontAsset = 'assets/fonts/Onest-Bold.ttf';

  static Future<Uint8List> build(
    PaymentReceipt receipt,
    AppStrings strings,
  ) async {
    final logoBytes = (await rootBundle.load(_logoAsset)).buffer.asUint8List();
    final font = pw.Font.ttf(await rootBundle.load(_fontAsset));
    final bold = pw.Font.ttf(await rootBundle.load(_boldFontAsset));

    final theme = pw.ThemeData.withFont(base: font, bold: bold);
    final doc = pw.Document(theme: theme);
    final currency = receipt.currency;

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(pw.MemoryImage(logoBytes), height: 44),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    strings.receiptDocumentTitle,
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    '${strings.receiptNumber}: ${receipt.number}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                  pw.Text(
                    '${strings.receiptDate}: ${formatReceiptDate(receipt.createdAt)}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 24),
          pw.Text(
            '${strings.receiptSeller}: ${receipt.sellerName}'
            '${receipt.sellerPhone.isNotEmpty ? ' · ${receipt.sellerPhone}' : ''}',
            style: const pw.TextStyle(fontSize: 11),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            '${strings.receiptBuyer}: ${receipt.buyerName}'
            '${receipt.buyerPhone.isNotEmpty ? ' · ${receipt.buyerPhone}' : ''}',
            style: const pw.TextStyle(fontSize: 11),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            '${strings.receiptXizmat}: ${receipt.xizmatName}',
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: [
              strings.receiptLineTitle,
              strings.receiptQuantity,
              strings.receiptUnitPrice,
              strings.receiptLineTotal,
            ],
            data: receipt.lines
                .map(
                  (line) => [
                    line.title,
                    _qty(line.quantity),
                    formatReceiptMoney(line.unitPrice, currency),
                    formatReceiptMoney(line.lineTotal, currency),
                  ],
                )
                .toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            cellHeight: 28,
          ),
          pw.SizedBox(height: 16),
          _totalRow(strings.receiptSubtotal,
              formatReceiptMoney(receipt.subtotal, currency)),
          if (receipt.discount > 0)
            _totalRow(
              strings.receiptDiscount,
              '- ${formatReceiptMoney(receipt.discount, currency)}',
            ),
          if (receipt.taxEnabled)
            _totalRow(
              '${receipt.taxLabel} (${_qty(receipt.taxRate)}%)',
              formatReceiptMoney(receipt.taxAmount, currency),
            ),
          pw.Divider(),
          _totalRow(
            strings.receiptTotal,
            formatReceiptMoney(receipt.total, currency),
            bold: true,
          ),
          if (receipt.note != null && receipt.note!.isNotEmpty) ...[
            pw.SizedBox(height: 16),
            pw.Text(
              '${strings.receiptNote}: ${receipt.note}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
          if (receipt.dueDate != null) ...[
            pw.SizedBox(height: 8),
            pw.Text(
              '${strings.receiptDueDate}: ${formatReceiptDate(receipt.dueDate!)}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
          pw.SizedBox(height: 32),
          pw.Center(
            child: pw.Text(
              strings.receiptFooterBranding,
              style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
          ),
        ],
      ),
    );

    return doc.save();
  }

  static String _qty(double value) {
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }

  static pw.Widget _totalRow(String label, String value, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

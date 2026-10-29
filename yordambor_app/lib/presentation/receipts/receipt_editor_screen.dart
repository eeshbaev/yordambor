import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:uuid/uuid.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/auth_welcome_provider.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/receipt_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_picker_sheet.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/utils/receipt_format.dart';
import 'package:yordambor/data/receipts/receipt_pdf_builder.dart';
import 'package:yordambor/domain/entities/client_registry_entry.dart';
import 'package:yordambor/domain/entities/payment_receipt.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';

class ReceiptEditorScreen extends ConsumerStatefulWidget {
  const ReceiptEditorScreen({super.key});

  @override
  ConsumerState<ReceiptEditorScreen> createState() =>
      _ReceiptEditorScreenState();
}

class _ReceiptEditorScreenState extends ConsumerState<ReceiptEditorScreen> {
  final _buyerName = TextEditingController();
  final _buyerPhone = TextEditingController();
  final _discount = TextEditingController();
  final _taxLabel = TextEditingController(text: 'QQS');
  final _taxRateCustom = TextEditingController(text: '12');
  final _note = TextEditingController();

  ReceiptCurrency _currency = ReceiptCurrency.uzs;
  bool _taxEnabled = false;
  int _taxPreset = 12;
  bool _taxCustom = false;
  String? _xizmatId;
  bool _saving = false;
  String? _error;

  final List<_LineDraft> _lines = [];

  @override
  void dispose() {
    _buyerName.dispose();
    _buyerPhone.dispose();
    _discount.dispose();
    _taxLabel.dispose();
    _taxRateCustom.dispose();
    _note.dispose();
    for (final line in _lines) {
      line.dispose();
    }
    super.dispose();
  }

  void _initFromServices(List<XizmatFeedItem> items) {
    if (_xizmatId != null || items.isEmpty) return;
    final first = items.first;
    _xizmatId = first.id;
    _lines.add(
      _LineDraft(
        title: TextEditingController(text: first.serviceDisplayName),
        qty: TextEditingController(text: '1'),
        price: TextEditingController(),
      ),
    );
  }

  double get _taxRate {
    if (!_taxEnabled) return 0;
    if (_taxCustom) return double.tryParse(_taxRateCustom.text) ?? 0;
    return _taxPreset.toDouble();
  }

  ReceiptTotals get _totals {
    final lines = _buildLines();
    return computeReceiptTotals(
      lines: lines,
      discount: double.tryParse(_discount.text) ?? 0,
      taxEnabled: _taxEnabled,
      taxRate: _taxRate,
    );
  }

  List<ReceiptLine> _buildLines() {
    return _lines
        .map(
          (d) => ReceiptLine(
            id: d.id,
            title: d.title.text.trim(),
            quantity: double.tryParse(d.qty.text) ?? 0,
            unitPrice: double.tryParse(d.price.text) ?? 0,
          ),
        )
        .where((l) => l.title.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final session = ref.watch(sessionProvider);
    final mineAsync = ref.watch(myXizmatlarProvider);
    final colors = context.ybColors;

    mineAsync.whenData(_initFromServices);

    final xizmatItems = mineAsync.valueOrNull ?? [];
    XizmatFeedItem? selectedXizmat;
    for (final item in xizmatItems) {
      if (item.id == _xizmatId) {
        selectedXizmat = item;
        break;
      }
    }
    selectedXizmat ??= xizmatItems.isNotEmpty ? xizmatItems.first : null;

    return Scaffold(
      appBar: AppBar(title: Text(strings.receiptNew)),
      body: AppLayout.page(
        context: context,
        child: ListView(
          padding: EdgeInsets.only(
            bottom: AppShell.scrollBottomPadding(context),
          ),
          children: [
            if (_error != null) ...[
              Text(_error!, style: TextStyle(color: context.ybColors.error)),
              const SizedBox(height: AppSpacing.md),
            ],
            YbSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    strings.receiptSeller,
                    style: AppTypography.label.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    sessionDisplayFullName(session, fallback: strings.appName),
                    style: AppTypography.body.copyWith(color: context.ybColors.textPrimary),
                  ),
                  if (session.profile?.phone.isNotEmpty ?? false)
                    Text(
                      session.profile!.phone,
                      style: AppTypography.caption.copyWith(color: context.ybColors.textSecondary),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SegmentedButton<ReceiptCurrency>(
              segments: [
                ButtonSegment(
                  value: ReceiptCurrency.uzs,
                  label: Text(strings.receiptCurrencyUzs),
                ),
                ButtonSegment(
                  value: ReceiptCurrency.usd,
                  label: Text(strings.receiptCurrencyUsd),
                ),
              ],
              selected: {_currency},
              onSelectionChanged: (v) =>
                  setState(() => _currency = v.first),
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(strings.receiptXizmat),
              subtitle: Text(
                selectedXizmat?.serviceDisplayName ?? strings.actionPick,
              ),
              trailing: const Icon(YbIcons.expandMoreFilled),
              onTap: xizmatItems.isEmpty
                  ? null
                  : () => _pickXizmat(context, strings, xizmatItems),
            ),
            TextButton.icon(
              onPressed: () => _pickClient(context, strings),
              icon: const Icon(YbIcons.menuBook),
              label: Text(strings.receiptPickClient),
            ),
            TextField(
              controller: _buyerName,
              decoration: InputDecoration(labelText: strings.receiptBuyerName),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _buyerPhone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: strings.receiptBuyerPhone),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(strings.receiptLines, style: AppTypography.headline.copyWith(color: context.ybColors.textPrimary)),
            const SizedBox(height: AppSpacing.sm),
            for (var i = 0; i < _lines.length; i++)
              _LineEditor(
                draft: _lines[i],
                strings: strings,
                currency: _currency,
                onRemove: _lines.length > 1
                    ? () => setState(() {
                          _lines[i].dispose();
                          _lines.removeAt(i);
                        })
                    : null,
              ),
            TextButton.icon(
              onPressed: () => setState(
                () => _lines.add(
                  _LineDraft(
                    title: TextEditingController(),
                    qty: TextEditingController(text: '1'),
                    price: TextEditingController(),
                  ),
                ),
              ),
              icon: const Icon(YbIcons.addFilled),
              label: Text(strings.receiptAddLine),
            ),
            TextField(
              controller: _discount,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: strings.receiptDiscount),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(strings.receiptTaxEnable),
              subtitle: Text(strings.receiptTaxDisclaimer),
              value: _taxEnabled,
              onChanged: (v) => setState(() => _taxEnabled = v),
            ),
            if (_taxEnabled) ...[
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  for (final rate in [0, 12])
                    ChoiceChip(
                      label: Text('$rate%'),
                      selected: !_taxCustom && _taxPreset == rate,
                      onSelected: (_) => setState(() {
                        _taxCustom = false;
                        _taxPreset = rate;
                      }),
                    ),
                  ChoiceChip(
                    label: Text(strings.receiptTaxPresetCustom),
                    selected: _taxCustom,
                    onSelected: (_) => setState(() => _taxCustom = true),
                  ),
                ],
              ),
              if (_taxCustom)
                TextField(
                  controller: _taxRateCustom,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: strings.receiptTaxRate),
                ),
              TextField(
                controller: _taxLabel,
                decoration: InputDecoration(labelText: strings.receiptTaxLabel),
              ),
            ],
            TextField(
              controller: _note,
              maxLines: 2,
              decoration: InputDecoration(labelText: strings.receiptNote),
            ),
            const SizedBox(height: AppSpacing.lg),
            _row(
              strings.receiptSubtotal,
              formatReceiptMoney(_totals.subtotal, _currency),
            ),
            if (_taxEnabled)
              _row(
                _taxLabel.text,
                formatReceiptMoney(_totals.taxAmount, _currency),
              ),
            _row(
              strings.receiptTotal,
              formatReceiptMoney(_totals.total, _currency),
              bold: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            YbPrimaryButton(
              label: strings.receiptSharePdf,
              isLoading: _saving,
              onPressed:
                  _saving ? null : () => _saveAndShare(session, strings),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w700 : null)),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w700 : null)),
        ],
      ),
    );
  }

  Future<void> _pickXizmat(
    BuildContext context,
    strings,
    List<XizmatFeedItem> items,
  ) async {
    await showYbPickerSheet<void>(
      context: context,
      child: YbCompactPickerSheet(
        title: strings.receiptXizmat,
        subtitle: strings.receiptValidationXizmat,
        headerIcon: YbIcons.designServices,
        selectedId: _xizmatId ?? '',
        options: [
          for (final item in items)
            YbPickerOption(
              id: item.id,
              label: item.serviceDisplayName,
              subtitle: item.subcategoryLabel,
            ),
        ],
        onSelected: (option) {
          setState(() => _xizmatId = option.id);
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _pickClient(BuildContext context, strings) async {
    final clients = await ref.read(clientRegistryProvider.future);
    if (!context.mounted || clients.isEmpty) return;
    await showYbPickerSheet<void>(
      context: context,
      child: YbCompactPickerSheet(
        title: strings.receiptPickClient,
        subtitle: strings.receiptBuyerName,
        headerIcon: YbIcons.person,
        selectedId: '',
        options: [
          for (final c in clients)
            YbPickerOption(
              id: c.id,
              label: c.clientName,
              subtitle: c.phone ?? '',
            ),
        ],
        onSelected: (option) {
          final client = clients.firstWhere((c) => c.id == option.id);
          _applyClient(client);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _applyClient(ClientRegistryEntry client) {
    setState(() {
      _buyerName.text = client.clientName;
      if (client.phone != null) _buyerPhone.text = client.phone!;
    });
  }

  Future<void> _saveAndShare(
    SessionState session,
    AppStrings strings,
  ) async {
    final xizmatId = _xizmatId;
    final xizmatList = ref.read(myXizmatlarProvider).valueOrNull ?? [];
    XizmatFeedItem? xizmat;
    for (final item in xizmatList) {
      if (item.id == xizmatId) {
        xizmat = item;
        break;
      }
    }

    if (xizmat == null) {
      setState(() => _error = strings.receiptValidationXizmat);
      return;
    }
    if (_buyerName.text.trim().isEmpty) {
      setState(() => _error = strings.receiptValidationBuyer);
      return;
    }
    final lines = _buildLines();
    if (lines.isEmpty ||
        lines.every((l) => l.unitPrice <= 0 || l.quantity <= 0)) {
      setState(() => _error = strings.receiptValidationLines);
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final receipt = await ref.read(paymentReceiptsRepositoryProvider).create(
            sellerName: sessionDisplayFullName(
              session,
              fallback: strings.appName,
            ),
            sellerPhone: session.profile?.phone ?? '',
            buyerName: _buyerName.text,
            buyerPhone: _buyerPhone.text,
            xizmatId: xizmat.id,
            xizmatName: xizmat.serviceDisplayName,
            currency: _currency,
            lines: lines,
            discount: double.tryParse(_discount.text) ?? 0,
            taxEnabled: _taxEnabled,
            taxRate: _taxRate,
            taxLabel: _taxLabel.text,
            note: _note.text,
          );
      ref.invalidate(paymentReceiptsProvider);
      final bytes = await ReceiptPdfBuilder.build(receipt, strings);
      await Printing.sharePdf(
        bytes: bytes,
        filename: '${receipt.number}.pdf',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.receiptSaved)),
        );
        context.go('/receipts/${receipt.id}');
      }
    } catch (_) {
      setState(() => _error = ref.read(appStringsProvider).stateErrorBody);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _LineDraft {
  _LineDraft({
    required this.title,
    required this.qty,
    required this.price,
  }) : id = const Uuid().v4();

  final String id;
  final TextEditingController title;
  final TextEditingController qty;
  final TextEditingController price;

  void dispose() {
    title.dispose();
    qty.dispose();
    price.dispose();
  }
}

class _LineEditor extends StatelessWidget {
  const _LineEditor({
    required this.draft,
    required this.strings,
    required this.currency,
    this.onRemove,
  });

  final _LineDraft draft;
  final AppStrings strings;
  final ReceiptCurrency currency;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        children: [
          TextField(
            controller: draft.title,
            decoration: InputDecoration(labelText: strings.receiptLineTitle),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: draft.qty,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: strings.receiptQuantity),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: draft.price,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: strings.receiptUnitPrice),
                ),
              ),
              if (onRemove != null)
                IconButton(
                  tooltip: strings.actionDelete,
                  onPressed: onRemove,
                  icon: const Icon(YbIcons.removeCircle),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

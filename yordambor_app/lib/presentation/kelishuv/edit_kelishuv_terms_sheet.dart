import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/design_system/widgets/yb_confirm_dialog.dart';
import 'package:yordambor/data/kelishuv/kelishuv_repository.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';

Future<bool?> showEditKelishuvTermsSheet(
  BuildContext context, {
  required Kelishuv kelishuv,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => EditKelishuvTermsSheet(kelishuv: kelishuv),
  );
}

class EditKelishuvTermsSheet extends ConsumerStatefulWidget {
  const EditKelishuvTermsSheet({super.key, required this.kelishuv});

  final Kelishuv kelishuv;

  @override
  ConsumerState<EditKelishuvTermsSheet> createState() =>
      _EditKelishuvTermsSheetState();
}

class _EditKelishuvTermsSheetState extends ConsumerState<EditKelishuvTermsSheet> {
  late final TextEditingController _messageController;
  late final TextEditingController _priceController;
  late final TextEditingController _durationController;
  DateTime? _startDate;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final kelishuv = widget.kelishuv;
    _messageController = TextEditingController(text: kelishuv.message ?? '');
    _priceController = TextEditingController(
      text: kelishuv.price?.toStringAsFixed(0) ?? '',
    );
    _durationController = TextEditingController(
      text: kelishuv.durationMinutes?.toString() ?? '',
    );
    _startDate = kelishuv.startDate;
  }

  @override
  void dispose() {
    _messageController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _submit() async {
    if (widget.kelishuv.status == KelishuvStatus.jarayonda) {
      final ok = await showYbConfirmDialog(
        context,
        title: 'Shartlarni o\'zgartirasizmi?',
        message:
            'O\'zgarishdan keyin ikkala tomon ham qayta tasdiqlashi kerak bo\'ladi.',
        confirmLabel: 'Davom etish',
      );
      if (!ok || !mounted) return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final priceText = _priceController.text.trim();
    final durationText = _durationController.text.trim();
    final input = TaklifInput(
      message: _messageController.text,
      price: priceText.isEmpty ? null : double.tryParse(priceText),
      startDate: _startDate,
      durationMinutes:
          durationText.isEmpty ? null : int.tryParse(durationText),
    );

    try {
      final userId = ref.read(sessionProvider).user?.id;
      if (userId == null) throw KelishuvFailure('Kirish talab qilinadi');

      await ref.read(kelishuvRepositoryProvider).updateTerms(
            widget.kelishuv.id,
            userId,
            input,
          );
      if (mounted) Navigator.of(context).pop(true);
    } on KelishuvFailure catch (error) {
      setState(() {
        _errorMessage = error.message;
        _isSubmitting = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final priceText = _priceController.text.trim();
    final durationText = _durationController.text.trim();
    final priceInvalid =
        priceText.isNotEmpty && double.tryParse(priceText) == null;
    final durationInvalid =
        durationText.isNotEmpty && int.tryParse(durationText) == null;

    return YbSheetBody(
      title: strings.kelishuvEditTerms,
      subtitle: strings.kelishuvTermsChanged,
      children: [
        TextField(
          controller: _messageController,
          enabled: !_isSubmitting,
          decoration: InputDecoration(
            labelText: strings.kelishuvTermsMessageLabel,
          ),
          maxLines: 3,
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _priceController,
          enabled: !_isSubmitting,
          decoration: InputDecoration(
            labelText: strings.kelishuvTermsPriceLabel,
            errorText: priceInvalid ? strings.invalidNumber : null,
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.lg),
        YbSecondaryButton(
          label: _startDate == null
              ? strings.kelishuvTermsDateLabel
              : _formatDate(_startDate!),
          icon: Icons.calendar_today_outlined,
          onPressed: _isSubmitting ? null : _pickDate,
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _durationController,
          enabled: !_isSubmitting,
          decoration: InputDecoration(
            labelText: strings.yordamKerakDurationLabel,
            errorText: durationInvalid ? strings.invalidMinutes : null,
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => setState(() {}),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: AppSpacing.md),
          YbInlineMessage(message: _errorMessage!),
        ],
        const SizedBox(height: AppSpacing.xl),
        YbPrimaryButton(
          label: strings.actionSave,
          isLoading: _isSubmitting,
          onPressed:
              _isSubmitting || priceInvalid || durationInvalid ? null : _submit,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

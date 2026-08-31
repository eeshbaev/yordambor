import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/data/client_book/provider_tools_service.dart';
import 'package:yordambor/data/kelishuv/kelishuv_repository.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/core/utils/xizmat_pricing_display.dart';
import 'package:yordambor/presentation/shared/busy_slot_confirm.dart';
import 'package:yordambor/presentation/shared/yb_safety_banner.dart';

class TaklifTarget {
  const TaklifTarget.xizmat({required this.xizmatId}) : postId = null;

  const TaklifTarget.post({
    required this.postId,
    required this.xizmatId,
  });

  final String? postId;
  final String xizmatId;
}

Future<String?> showTaklifSheet(
  BuildContext context, {
  required TaklifTarget target,
  String? title,
  TaklifPricingPrefill? prefill,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => TaklifSheet(
      target: target,
      title: title,
      prefill: prefill,
    ),
  );
}

class TaklifSheet extends ConsumerStatefulWidget {
  const TaklifSheet({
    super.key,
    required this.target,
    this.title,
    this.prefill,
  });

  final TaklifTarget target;
  final String? title;
  final TaklifPricingPrefill? prefill;

  @override
  ConsumerState<TaklifSheet> createState() => _TaklifSheetState();
}

class _TaklifSheetState extends ConsumerState<TaklifSheet> {
  final _messageController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  DateTime? _startDate;
  bool _isSubmitting = false;
  String? _errorMessage;
  bool _prefillApplied = false;

  @override
  void initState() {
    super.initState();
    _applyPrefill(widget.prefill);
  }

  void _applyPrefill(TaklifPricingPrefill? prefill) {
    if (_prefillApplied || prefill == null) return;
    _prefillApplied = true;
    if (prefill.message != null && prefill.message!.trim().isNotEmpty) {
      _messageController.text = prefill.message!.trim();
    }
    if (prefill.price != null) {
      final price = prefill.price!;
      _priceController.text =
          price % 1 == 0 ? price.toInt().toString() : price.toString();
    }
    if (prefill.durationMinutes != null) {
      _durationController.text = prefill.durationMinutes.toString();
    }
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

  Future<bool> _confirmBusySlotConflicts(
    List<BookingWithClient> conflicts,
  ) async {
    return confirmBusySlotConflicts(
      context,
      ref.read(appStringsProvider),
      conflicts,
    );
  }

  Future<void> _submit() async {
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

    if (_startDate != null) {
      final conflicts = await ref
          .read(providerToolsServiceProvider)
          .findSlotConflicts(slotStart: _startDate!);
      if (!mounted) return;
      final proceed = await _confirmBusySlotConflicts(conflicts);
      if (!proceed) {
        setState(() => _isSubmitting = false);
        return;
      }
    }

    try {
      final repo = ref.read(kelishuvRepositoryProvider);
      final Kelishuv kelishuv;
      if (widget.target.postId != null) {
        kelishuv = await repo.createFromPost(
          postId: widget.target.postId!,
          xizmatId: widget.target.xizmatId,
          input: input,
        );
      } else {
        kelishuv = await repo.createFromXizmat(
          xizmatId: widget.target.xizmatId,
          input: input,
        );
      }

      if (mounted) Navigator.of(context).pop(kelishuv.id);
      ref.invalidate(incomingKelishuvProvider);
      ref.invalidate(myKelishuvRequestsProvider);
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
      title: widget.title ?? strings.taklifTitle,
      subtitle: strings.taklifSubtitle,
      children: [
        YbSafetyBanner(strings: strings),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _messageController,
          enabled: !_isSubmitting,
          decoration: InputDecoration(
            labelText: strings.taklifMessageLabel,
            hintText: strings.taklifMessageHint,
          ),
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _priceController,
          enabled: !_isSubmitting,
          decoration: InputDecoration(
            labelText: strings.taklifPriceLabel,
            errorText: priceInvalid ? strings.invalidNumber : null,
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.lg),
        YbSecondaryButton(
          label: _startDate == null
              ? strings.taklifDateLabel
              : _formatDate(_startDate!),
          icon: Icons.calendar_today_outlined,
          onPressed: _isSubmitting ? null : _pickDate,
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _durationController,
          enabled: !_isSubmitting,
          decoration: InputDecoration(
            labelText: strings.taklifDurationLabel,
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
          label: strings.taklifSubmit,
          isLoading: _isSubmitting,
          onPressed: _isSubmitting || priceInvalid || durationInvalid
              ? null
              : _submit,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

Future<void> openTaklifFlow(
  BuildContext context,
  WidgetRef ref, {
  required TaklifTarget target,
  String? title,
}) async {
  final xizmat =
      await ref.read(xizmatDetailProvider(target.xizmatId).future);
  if (!context.mounted) return;

  if (target.postId == null) {
    final userId = ref.read(sessionProvider).user?.id;
    if (userId != null && xizmat?.ownerId == userId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ref.read(appStringsProvider).cannotRequestOwnXizmat),
        ),
      );
      return;
    }
  }

  final prefill =
      xizmat == null ? null : taklifPrefillFromXizmat(xizmat);

  if (!context.mounted) return;

  final kelishuvId = await showTaklifSheet(
    context,
    target: target,
    title: title,
    prefill: prefill,
  );

  if (kelishuvId != null && context.mounted) {
    context.push('/kelishuv/$kelishuvId');
  }
}

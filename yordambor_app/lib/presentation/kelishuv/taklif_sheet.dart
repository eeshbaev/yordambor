import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/application/providers/yordam_kerak_provider.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/data/client_book/provider_tools_service.dart';
import 'package:yordambor/data/kelishuv/kelishuv_repository.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/core/utils/demo_ids.dart';
import 'package:yordambor/core/utils/phone_validation.dart';
import 'package:yordambor/core/utils/xizmat_pricing_display.dart';
import 'package:yordambor/presentation/shared/busy_slot_confirm.dart';
import 'package:yordambor/presentation/shared/sample_listing_actions.dart';
import 'package:yordambor/presentation/shared/yb_safety_banner.dart';

class TaklifTarget {
  /// A client asks a provider's service for help.
  const TaklifTarget.xizmat({required this.xizmatId}) : postId = null;

  /// A provider answers a request for help ("Yordam bor").
  const TaklifTarget.post({
    required this.postId,
    required this.xizmatId,
  });

  final String? postId;
  final String xizmatId;

  /// True when the person sending is the one who needs the help.
  bool get asksForHelp => postId == null;
}

Future<String?> showTaklifSheet(
  BuildContext context, {
  required TaklifTarget target,
  String? title,
  TaklifPricingPrefill? prefill,
}) {
  return showModalBottomSheet<String>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
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

  /// The sender's card, prefilled from their profile.
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  /// The card shows as one line until the person edits it, or while
  /// something in it is missing.
  bool _editingContact = false;
  String? _firstNameError;
  String? _phoneError;

  DateTime? _startDate;
  bool _isSubmitting = false;

  /// Sent: the button closes into a checkmark before the sheet leaves.
  bool _sent = false;
  String? _errorMessage;
  bool _prefillApplied = false;

  @override
  void initState() {
    super.initState();
    _applyPrefill(widget.prefill);
    _prefillContact();
  }

  /// Name and phone from the profile: the first word of the full name is
  /// the first name, the rest the family name.
  void _prefillContact() {
    final profile = ref.read(sessionProvider).profile;
    final parts = (profile?.fullName ?? '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isNotEmpty) {
      _firstNameController.text = parts.first;
      _lastNameController.text = parts.skip(1).join(' ');
    }
    _phoneController.text = profile?.phone.trim() ?? '';
    _editingContact = !_contactComplete;
  }

  bool get _contactComplete =>
      _firstNameController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty &&
      isValidOptionalContactPhone(_phoneController.text);

  /// Checks the card; shows what is missing and opens it when needed.
  DealContact? _validContact() {
    final strings = ref.read(appStringsProvider);
    final first = _firstNameController.text.trim();
    final phoneText = _phoneController.text.trim();
    final phone = normalizeOptionalContactPhone(phoneText);
    final firstError = first.isEmpty ? strings.taklifFirstNameRequired : null;
    final phoneError = phoneText.isEmpty
        ? strings.taklifPhoneRequired
        : !isValidOptionalContactPhone(phoneText) || phone == null
            ? strings.invalidPhone
            : null;
    setState(() {
      _firstNameError = firstError;
      _phoneError = phoneError;
      if (firstError != null || phoneError != null) _editingContact = true;
    });
    if (firstError != null || phoneError != null || phone == null) {
      return null;
    }
    final last = _lastNameController.text.trim();
    return DealContact(
      firstName: first,
      lastName: last.isEmpty ? null : last,
      phone: phone,
    );
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
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
    final contact = _validContact();
    if (contact == null) {
      AppHaptics.error();
      return;
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
      contact: contact,
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

      ref.invalidate(incomingKelishuvProvider);
      ref.invalidate(myKelishuvRequestsProvider);
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _sent = true;
      });
      await Future<void>.delayed(const Duration(milliseconds: 650));
      if (mounted) Navigator.of(context).pop(kelishuv.id);
    } on KelishuvFailure catch (error) {
      setState(() {
        _errorMessage = error.message;
        _isSubmitting = false;
      });
    } catch (_) {
      setState(() {
        _errorMessage = ref.read(appStringsProvider).stateErrorBody;
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
    // The client says what they need; the provider says how they can help.
    final asks = widget.target.asksForHelp;

    return YbSheetBody(
      title: widget.title ?? strings.taklifTitle,
      subtitle: asks ? strings.taklifAskSubtitle : strings.taklifSubtitle,
      children: [
        // A sample listing: say so before anything is filled in.
        if (isDemoFeedId(widget.target.postId ?? widget.target.xizmatId)) ...[
          YbInlineMessage(
            message: strings.demoDealNote,
            tone: YbInlineMessageTone.info,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        YbSafetyBanner(strings: strings),
        const SizedBox(height: AppSpacing.lg),
        _ContactCard(
          title: strings.taklifContactTitle,
          note: strings.taklifContactNote,
          editLabel: strings.actionEdit,
          firstNameLabel: strings.taklifFirstNameLabel,
          lastNameLabel: strings.taklifLastNameLabel,
          phoneLabel: strings.postContactPhoneLabel,
          firstName: _firstNameController,
          lastName: _lastNameController,
          phone: _phoneController,
          firstNameError: _firstNameError,
          phoneError: _phoneError,
          editing: _editingContact,
          enabled: !_isSubmitting,
          onEdit: () => setState(() => _editingContact = true),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _messageController,
          enabled: !_isSubmitting,
          decoration: InputDecoration(
            labelText: strings.taklifMessageOptionalLabel,
            hintText: asks ? strings.taklifAskHint : strings.taklifMessageHint,
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
          icon: YbIcons.calendarToday,
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
          label: asks ? strings.taklifAskSubmit : strings.taklifSubmit,
          isLoading: _isSubmitting,
          isSuccess: _sent,
          onPressed: _isSubmitting || _sent || priceInvalid || durationInvalid
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

/// The sender's card: one line with their name and phone, ready to send;
/// "Edit" opens the three fields. Opens by itself when something is
/// missing.
class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.title,
    required this.note,
    required this.editLabel,
    required this.firstNameLabel,
    required this.lastNameLabel,
    required this.phoneLabel,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.editing,
    required this.enabled,
    required this.onEdit,
    this.firstNameError,
    this.phoneError,
  });

  final String title;
  final String note;
  final String editLabel;
  final String firstNameLabel;
  final String lastNameLabel;
  final String phoneLabel;
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController phone;
  final bool editing;
  final bool enabled;
  final VoidCallback onEdit;
  final String? firstNameError;
  final String? phoneError;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final name = [firstName.text.trim(), lastName.text.trim()]
        .where((part) => part.isNotEmpty)
        .join(' ');
    final initial = name.isEmpty ? '?' : name[0].toUpperCase();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.tealSoft,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(YbIcons.badge, size: 18, color: colors.tealInk),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.label.copyWith(
                      color: colors.tealInk,
                      fontSize: 13,
                    ),
                  ),
                ),
                if (!editing)
                  TextButton(
                    onPressed: enabled ? onEdit : null,
                    child: Text(editLabel),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            if (!editing)
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: colors.card,
                    child: Text(
                      initial,
                      style: AppTypography.headline.copyWith(
                        color: colors.tealInk,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTypography.headline.copyWith(
                            color: colors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              YbIcons.phone,
                              size: 16,
                              color: colors.ink2,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                phone.text.trim(),
                                style: AppTypography.tabular(
                                  AppTypography.body.copyWith(
                                    color: colors.ink2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else ...[
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: firstName,
                enabled: enabled,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: '$firstNameLabel *',
                  errorText: firstNameError,
                  filled: true,
                  fillColor: colors.card,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: lastName,
                enabled: enabled,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: lastNameLabel,
                  filled: true,
                  fillColor: colors.card,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: phone,
                enabled: enabled,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: '$phoneLabel *',
                  hintText: '+998 90 123 45 67',
                  errorText: phoneError,
                  filled: true,
                  fillColor: colors.card,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Text(
              note,
              style: AppTypography.caption.copyWith(color: colors.tealInk),
            ),
          ],
        ),
      ),
    );
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

  // Samples never take a deal: a sample service leads to a real request,
  // a sample request to alerts for real ones.
  final postId = target.postId;
  if (postId != null && isDemoFeedId(postId)) {
    final sample = await ref.read(yordamKerakPostProvider(postId).future);
    if (sample != null && context.mounted) {
      await answerSampleRequest(context, ref, sample);
    }
    return;
  }
  if (postId == null &&
      xizmat != null &&
      (xizmat.isDemo || isDemoFeedId(xizmat.id))) {
    await findProviderFromSample(context, ref, xizmat);
    return;
  }

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

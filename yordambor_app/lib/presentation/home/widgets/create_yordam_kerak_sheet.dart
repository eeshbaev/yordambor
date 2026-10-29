import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/category_providers.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/experience_providers.dart';
import 'package:yordambor/application/providers/feed_filter_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/application/providers/yordam_kerak_provider.dart';
import 'package:yordambor/core/constants/service_cities.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_shake.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/phone_validation.dart';
import 'package:yordambor/data/yordam_kerak/yordam_kerak_repository.dart';
import 'package:yordambor/domain/entities/category_item.dart';
import 'package:yordambor/domain/entities/request_draft.dart';
import 'package:yordambor/presentation/shared/alert_subscriptions.dart';
import 'package:yordambor/presentation/shared/busy_slot_confirm.dart';
import 'package:yordambor/presentation/shared/post_contact_preferences_section.dart';
import 'package:yordambor/presentation/shared/xizmat_service_city_field.dart';

/// Where a new request starts when it comes from somewhere specific (a
/// sample service): its trade and city.
class YordamKerakPrefill {
  const YordamKerakPrefill({
    this.categoryId,
    this.subcategoryId,
    this.serviceCityId,
  });

  final String? categoryId;
  final String? subcategoryId;
  final String? serviceCityId;
}

/// The "ask for help" form. [prefill] replaces the feed filter as the
/// starting trade and city; [offerNewServiceAlert] adds a switch to hear
/// when a provider joins in that trade. True when a request was published.
Future<bool?> showCreateYordamKerakSheet(
  BuildContext context, {
  YordamKerakPrefill? prefill,
  bool offerNewServiceAlert = false,
}) {
  return showModalBottomSheet<bool>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => CreateYordamKerakSheet(
      prefill: prefill,
      offerNewServiceAlert: offerNewServiceAlert,
    ),
  );
}

class CreateYordamKerakSheet extends ConsumerStatefulWidget {
  const CreateYordamKerakSheet({
    super.key,
    this.prefill,
    this.offerNewServiceAlert = false,
  });

  final YordamKerakPrefill? prefill;
  final bool offerNewServiceAlert;

  @override
  ConsumerState<CreateYordamKerakSheet> createState() =>
      _CreateYordamKerakSheetState();
}

class _CreateYordamKerakSheetState
    extends ConsumerState<CreateYordamKerakSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _phoneController = TextEditingController();

  CategoryItem? _category;
  SubcategoryItem? _subcategory;
  DateTime? _startDate;
  bool _isSubmitting = false;
  bool _published = false;
  bool _autovalidate = false;
  bool _showContactPhone = false;
  bool _phonePrefilled = false;
  String? _categoryError;
  String? _subcategoryError;

  /// Where the help is needed; every request has a city.
  String? _cityId;
  String? _cityError;

  /// Hear when a provider joins in this trade (asked from a sample).
  bool _alertNewServices = true;

  /// Drafts save themselves while the person types (manual S-06).
  late final RequestDraftNotifier _drafts;
  String? _ownerId;
  Timer? _saveTimer;
  bool _ready = false;
  bool _restoring = false;
  bool _restoredDraft = false;
  bool _submitted = false;

  /// Fields that need fixing shake once per failed attempt (manual S-03).
  final _titleField = GlobalKey<FormFieldState<String>>();
  final _messageField = GlobalKey<FormFieldState<String>>();
  int _titleShake = 0;
  int _messageShake = 0;
  int _categoryShake = 0;

  static const _saveDelay = Duration(milliseconds: 2500);

  @override
  void initState() {
    super.initState();
    _drafts = ref.read(requestDraftProvider.notifier);
    _ownerId = ref.read(sessionProvider).user?.id;
    for (final controller in [
      _titleController,
      _messageController,
      _priceController,
      _durationController,
    ]) {
      controller.addListener(_scheduleSave);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // A request started from somewhere specific (a sample) begins there,
      // not in an older draft.
      final restored = widget.prefill == null && await _restoreDraft();
      if (!restored) await _applyFilterDefaults();
      if (!mounted) return;
      _prefillPhone();
      _ready = true;
    });
  }

  /// Puts the saved draft back into the form. True when there was one.
  Future<bool> _restoreDraft() async {
    final draft = await _drafts.current();
    if (!mounted || draft == null || !draft.belongsTo(_ownerId)) return false;

    CategoryItem? category;
    SubcategoryItem? subcategory;
    if (draft.categoryId != null) {
      final categories = await ref.read(categoriesProvider.future);
      if (!mounted) return false;
      for (final item in categories) {
        if (item.id != draft.categoryId) continue;
        category = item;
        for (final sub in item.subcategories) {
          if (sub.id == draft.subcategoryId) subcategory = sub;
        }
      }
    }

    _restoring = true;
    _titleController.text = draft.title;
    _messageController.text = draft.message;
    _priceController.text = draft.price;
    _durationController.text = draft.duration;
    _restoring = false;
    setState(() {
      _category = category;
      _subcategory = subcategory;
      _startDate = draft.startDate;
      if (ServiceCities.isValidId(draft.serviceCity)) {
        _cityId = draft.serviceCity;
      }
      _restoredDraft = true;
    });
    return true;
  }

  RequestDraft _currentDraft() => RequestDraft(
        savedAt: DateTime.now(),
        ownerId: _ownerId,
        title: _titleController.text,
        message: _messageController.text,
        price: _priceController.text,
        duration: _durationController.text,
        categoryId: _category?.id,
        subcategoryId: _subcategory?.id,
        startDate: _startDate,
        serviceCity: _cityId,
      );

  void _scheduleSave() {
    if (!_ready || _restoring || _submitted) return;
    _saveTimer?.cancel();
    _saveTimer = Timer(_saveDelay, () {
      if (!_submitted) _drafts.save(_currentDraft());
    });
  }

  Future<void> _startOver() async {
    _saveTimer?.cancel();
    await _drafts.clear();
    if (!mounted) return;
    _restoring = true;
    _titleController.clear();
    _messageController.clear();
    _priceController.clear();
    _durationController.clear();
    _restoring = false;
    setState(() {
      _category = null;
      _subcategory = null;
      _startDate = null;
      _restoredDraft = false;
      _autovalidate = false;
      _categoryError = null;
      _subcategoryError = null;
      _cityId = null;
      _cityError = null;
    });
    await _applyFilterDefaults();
  }

  void _prefillPhone() {
    if (_phonePrefilled) return;
    _phonePrefilled = true;
    final phone = ref.read(sessionProvider).profile?.phone;
    if (phone != null && phone.isNotEmpty) {
      _phoneController.text = phone;
    }
  }

  Future<void> _applyFilterDefaults() async {
    final filter = ref.read(feedFilterProvider);
    final prefill = widget.prefill;
    // A given starting point wins; else the trade and the city the feed is
    // showing are the most likely ones.
    final cityId = prefill?.serviceCityId ?? filter.serviceCityId;
    final categoryId =
        prefill != null ? prefill.categoryId : filter.categoryId;
    final subcategoryId =
        prefill != null ? prefill.subcategoryId : filter.subcategoryId;
    if (ServiceCities.isValidId(cityId)) {
      setState(() => _cityId = cityId);
    }
    if (categoryId == null) return;

    final categories = await ref.read(categoriesProvider.future);
    CategoryItem? category;
    SubcategoryItem? subcategory;

    for (final item in categories) {
      if (item.id != categoryId) continue;
      category = item;
      if (subcategoryId != null) {
        for (final sub in item.subcategories) {
          if (sub.id == subcategoryId) {
            subcategory = sub;
            break;
          }
        }
      }
      break;
    }

    if (!mounted || category == null) return;
    setState(() {
      _category = category;
      _subcategory = subcategory;
      _categoryError = null;
      _subcategoryError = null;
    });
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    // Closing the sheet keeps what was typed; an emptied form clears it.
    if (_ready && !_submitted) _drafts.save(_currentDraft());
    _titleController.dispose();
    _messageController.dispose();
    _priceController.dispose();
    _durationController.dispose();
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
    if (picked != null) {
      setState(() => _startDate = picked);
      _scheduleSave();
    }
  }

  bool _validateCategories(AppStrings strings) {
    final categoryMissing = _category == null;
    final subcategoryMissing = _subcategory == null;
    final cityMissing = !ServiceCities.isValidId(_cityId);

    setState(() {
      _categoryError =
          categoryMissing ? strings.yordamKerakCategoryRequired : null;
      _subcategoryError =
          subcategoryMissing ? strings.yordamKerakSubcategoryRequired : null;
      _cityError = cityMissing ? strings.yordamKerakCityRequired : null;
    });

    return !categoryMissing && !subcategoryMissing && !cityMissing;
  }

  Future<void> _pickCity() {
    final strings = ref.read(appStringsProvider);
    return showServiceCityPicker(
      context: context,
      strings: strings,
      selectedId: _cityId,
      title: strings.filterCity,
      subtitle: strings.filterCityHint,
      onSelected: (id) {
        setState(() {
          _cityId = id;
          _cityError = null;
        });
        _scheduleSave();
      },
    );
  }

  Future<void> _submit() async {
    final strings = ref.read(appStringsProvider);
    setState(() => _autovalidate = true);

    final formValid = _formKey.currentState?.validate() ?? false;
    final categoriesValid = _validateCategories(strings);
    if (!formValid || !categoriesValid) {
      AppHaptics.error();
      setState(() {
        if (_titleField.currentState?.hasError ?? false) _titleShake++;
        if (_messageField.currentState?.hasError ?? false) _messageShake++;
        if (!categoriesValid) _categoryShake++;
      });
      return;
    }

    setState(() => _isSubmitting = true);

    if (_startDate != null) {
      final conflicts = await ref
          .read(providerToolsServiceProvider)
          .findSlotConflicts(slotStart: _startDate!);
      if (!mounted) return;
      final proceed = await confirmBusySlotConflicts(
        context,
        strings,
        conflicts,
      );
      if (!mounted) return;
      if (!proceed) {
        setState(() => _isSubmitting = false);
        return;
      }
    }

    final priceText = _priceController.text.trim();
    final price = priceText.isEmpty ? null : double.tryParse(priceText);
    final durationText = _durationController.text.trim();
    final contactPhone = normalizeOptionalContactPhone(_phoneController.text);

    if (!isValidOptionalContactPhone(_phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.invalidPhone)),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    try {
      await ref.read(yordamKerakRepositoryProvider).create(
            CreateYordamKerakInput(
              title: _titleController.text.trim(),
              message: _messageController.text.trim(),
              price: price,
              categoryId: _category!.id,
              subcategoryId: _subcategory!.id,
              startDate: _startDate,
              durationMinutes:
                  durationText.isEmpty ? null : int.tryParse(durationText),
              contactPhone: contactPhone,
              showContactPhone: _showContactPhone,
              serviceCity: _cityId,
            ),
          );
      _submitted = true;
      _saveTimer?.cancel();
      await _drafts.clear();
      if (widget.offerNewServiceAlert && _alertNewServices) {
        await subscribeToNewServices(
          ref,
          categoryId: _category!.id,
          subcategoryId: _subcategory!.id,
        );
      }
      if (!mounted) return;
      // Published: the button closes into a checkmark, then the sheet goes.
      setState(() {
        _isSubmitting = false;
        _published = true;
      });
      await Future.wait<void>([
        ref.read(yordamKerakFeedProvider.notifier).load(),
        Future<void>.delayed(const Duration(milliseconds: 650)),
      ]);
      if (mounted) Navigator.of(context).pop(true);
    } on YordamKerakFailure catch (error) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    } catch (_) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.stateErrorBody)),
        );
      }
    }
  }

  String _requiredLabel(AppStrings strings, String label) => '$label *';

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(onboardingPrefsProvider).language;
    final strings = ref.watch(appStringsProvider);

    return Form(
      key: _formKey,
      autovalidateMode: _autovalidate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: YbSheetBody(
        title: strings.yordamKerakPostTitle,
        children: [
          if (_restoredDraft) ...[
            _DraftRestoredRow(
              label: strings.draftRestored,
              actionLabel: strings.draftStartOver,
              onStartOver: _startOver,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          YbShake(
            trigger: _titleShake,
            child: TextFormField(
              key: _titleField,
              controller: _titleController,
              decoration: InputDecoration(
                labelText: _requiredLabel(strings, strings.yordamKerakTitleLabel),
                hintText: strings.yordamKerakTitleHint,
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return strings.yordamKerakTitleRequired;
                if (trimmed.length < 3) return strings.yordamKerakTitleTooShort;
                return null;
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          YbShake(
            trigger: _messageShake,
            child: TextFormField(
              key: _messageField,
              controller: _messageController,
              decoration: InputDecoration(
                labelText:
                    _requiredLabel(strings, strings.yordamKerakMessageLabel),
                hintText: strings.yordamKerakMessageHint,
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return strings.yordamKerakMessageRequired;
                if (trimmed.length < 10) {
                  return strings.yordamKerakMessageTooShort;
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(
              labelText: strings.yordamKerakBudgetLabel,
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.lg),
          YbSecondaryButton(
            label: _startDate == null
                ? strings.yordamKerakDateLabel
                : _formatDate(_startDate!),
            icon: YbIcons.calendarToday,
            onPressed: _pickDate,
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _durationController,
            decoration: InputDecoration(
              labelText: strings.yordamKerakDurationLabel,
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.lg),
          YbShake(
            trigger: _categoryShake,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PickerTile(
                  title: _requiredLabel(strings, strings.filterCategory),
                  value: _category?.label(language),
                  placeholder: strings.actionPick,
                  errorText: _categoryError,
                  onTap: () => _pickCategory(context),
                ),
                _PickerTile(
                  title: _requiredLabel(strings, strings.filterSubcategory),
                  value: _subcategory?.label(language),
                  placeholder: strings.actionPick,
                  errorText: _subcategoryError,
                  enabled: _category != null,
                  onTap: _category == null
                      ? null
                      : () => _pickSubcategory(context),
                ),
                _PickerTile(
                  title: _requiredLabel(strings, strings.filterCity),
                  value: ServiceCities.isValidId(_cityId)
                      ? strings.serviceCityLabel(_cityId!)
                      : null,
                  placeholder: strings.actionPick,
                  errorText: _cityError,
                  onTap: _pickCity,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PostContactPreferencesSection(
            strings: strings,
            phoneController: _phoneController,
            showContactPhone: _showContactPhone,
            onShowContactPhoneChanged: (value) =>
                setState(() => _showContactPhone = value),
            phoneValidator: (value) {
              if (!isValidOptionalContactPhone(value ?? '')) {
                return strings.invalidPhone;
              }
              return null;
            },
          ),
          if (widget.offerNewServiceAlert) ...[
            const SizedBox(height: AppSpacing.sm),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _alertNewServices,
              onChanged: (value) => setState(() => _alertNewServices = value),
              secondary: Icon(
                YbIcons.notificationsActiveFilled,
                color: context.ybColors.teal,
              ),
              title: Text(
                strings.sampleAlertNewServices,
                style: AppTypography.body,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          YbPrimaryButton(
            label: strings.yordamKerakPublish,
            isLoading: _isSubmitting,
            isSuccess: _published,
            onPressed: _isSubmitting || _published ? null : _submit,
          ),
        ],
      ),
    );
  }

  Future<void> _pickCategory(BuildContext context) async {
    final categories = await ref.read(categoriesProvider.future);
    if (!context.mounted) return;

    final picked = await showModalBottomSheet<CategoryItem>(
      sheetAnimationStyle: AppMotion.sheetOf(context),
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => _CategoryList(
        title: ref.read(appStringsProvider).filterCategory,
        items: categories,
        label: (item) => item.label(ref.read(onboardingPrefsProvider).language),
      ),
    );

    if (picked != null) {
      setState(() {
        _category = picked;
        _subcategory = null;
        _categoryError = null;
        _subcategoryError = null;
      });
      _scheduleSave();
    }
  }

  Future<void> _pickSubcategory(BuildContext context) async {
    final category = _category;
    if (category == null) return;

    final picked = await showModalBottomSheet<SubcategoryItem>(
      sheetAnimationStyle: AppMotion.sheetOf(context),
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => _CategoryList(
        title: ref.read(appStringsProvider).filterSubcategory,
        items: category.subcategories,
        label: (item) => item.label(ref.read(onboardingPrefsProvider).language),
      ),
    );

    if (picked != null) {
      setState(() {
        _subcategory = picked;
        _subcategoryError = null;
      });
      _scheduleSave();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

/// "Draft restored · Start over": one quiet line, so a prefilled form never
/// surprises.
class _DraftRestoredRow extends StatelessWidget {
  const _DraftRestoredRow({
    required this.label,
    required this.actionLabel,
    required this.onStartOver,
  });

  final String label;
  final String actionLabel;
  final VoidCallback onStartOver;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Row(
      children: [
        Icon(YbIcons.history, size: 18, color: colors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: AppTypography.body.copyWith(color: colors.textSecondary),
          ),
        ),
        TextButton(
          onPressed: onStartOver,
          child: Text(actionLabel),
        ),
      ],
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.title,
    required this.placeholder,
    this.value,
    this.errorText,
    this.enabled = true,
    this.onTap,
  });

  final String title;
  final String? value;
  final String placeholder;
  final String? errorText;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final subtitle = value ?? placeholder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(AppRadius.chip),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.caption.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          subtitle,
                          style: AppTypography.headline.copyWith(
                            color: enabled
                                ? (value == null
                                    ? colors.textTertiary
                                    : colors.textPrimary)
                                : colors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    YbIcons.chevronRightFilled,
                    color: enabled ? colors.textTertiary : colors.borderSubtle,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.sm),
          YbInlineMessage(message: errorText!),
        ],
      ],
    );
  }
}

class _CategoryList<T> extends StatelessWidget {
  const _CategoryList({
    required this.title,
    required this.items,
    required this.label,
  });

  final String title;
  final List<T> items;
  final String Function(T item) label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.75;

    return SafeArea(
      child: SizedBox(
        height: maxHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                title,
                style: AppTypography.title.copyWith(color: colors.textPrimary),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  indent: AppSpacing.lg,
                  color: colors.borderSubtle,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.xs,
                    ),
                    title: Text(
                      label(item),
                      style: AppTypography.headline.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    trailing: Icon(
                      YbIcons.chevronRightFilled,
                      color: colors.textTertiary,
                    ),
                    onTap: () => Navigator.of(context).pop(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

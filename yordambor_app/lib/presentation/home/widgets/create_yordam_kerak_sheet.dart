import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/category_providers.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/feed_filter_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/application/providers/yordam_kerak_provider.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/phone_validation.dart';
import 'package:yordambor/data/yordam_kerak/yordam_kerak_repository.dart';
import 'package:yordambor/domain/entities/category_item.dart';
import 'package:yordambor/presentation/shared/busy_slot_confirm.dart';
import 'package:yordambor/presentation/shared/post_contact_preferences_section.dart';

Future<bool?> showCreateYordamKerakSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => const CreateYordamKerakSheet(),
  );
}

class CreateYordamKerakSheet extends ConsumerStatefulWidget {
  const CreateYordamKerakSheet({super.key});

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
  bool _autovalidate = false;
  bool _showContactPhone = false;
  bool _phonePrefilled = false;
  String? _categoryError;
  String? _subcategoryError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyFilterDefaults();
      _prefillPhone();
    });
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
    if (filter.categoryId == null) return;

    final categories = await ref.read(categoriesProvider.future);
    CategoryItem? category;
    SubcategoryItem? subcategory;

    for (final item in categories) {
      if (item.id != filter.categoryId) continue;
      category = item;
      if (filter.subcategoryId != null) {
        for (final sub in item.subcategories) {
          if (sub.id == filter.subcategoryId) {
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
    if (picked != null) setState(() => _startDate = picked);
  }

  bool _validateCategories(AppStrings strings) {
    final categoryMissing = _category == null;
    final subcategoryMissing = _subcategory == null;

    setState(() {
      _categoryError =
          categoryMissing ? strings.yordamKerakCategoryRequired : null;
      _subcategoryError =
          subcategoryMissing ? strings.yordamKerakSubcategoryRequired : null;
    });

    return !categoryMissing && !subcategoryMissing;
  }

  Future<void> _submit() async {
    final strings = ref.read(appStringsProvider);
    setState(() => _autovalidate = true);

    final formValid = _formKey.currentState?.validate() ?? false;
    final categoriesValid = _validateCategories(strings);
    if (!formValid || !categoriesValid) return;

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
            ),
          );
      await ref.read(yordamKerakFeedProvider.notifier).load();
      if (mounted) Navigator.of(context).pop(true);
    } on YordamKerakFailure catch (error) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    } catch (error) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
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
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: _requiredLabel(strings, strings.yordamKerakTitleLabel),
              hintText: strings.yordamKerakTitleHint,
            ),
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              final trimmed = value?.trim() ?? '';
              if (trimmed.isEmpty) return strings.fieldRequired;
              if (trimmed.length < 3) return strings.yordamKerakTitleTooShort;
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
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
              if (trimmed.isEmpty) return strings.fieldRequired;
              if (trimmed.length < 10) {
                return strings.yordamKerakMessageTooShort;
              }
              return null;
            },
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
            icon: Icons.calendar_today_outlined,
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
            onTap: _category == null ? null : () => _pickSubcategory(context),
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
          const SizedBox(height: AppSpacing.xl),
          YbPrimaryButton(
            label: strings.yordamKerakPublish,
            isLoading: _isSubmitting,
            onPressed: _isSubmitting ? null : _submit,
          ),
        ],
      ),
    );
  }

  Future<void> _pickCategory(BuildContext context) async {
    final categories = await ref.read(categoriesProvider.future);
    if (!context.mounted) return;

    final picked = await showModalBottomSheet<CategoryItem>(
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
    }
  }

  Future<void> _pickSubcategory(BuildContext context) async {
    final category = _category;
    if (category == null) return;

    final picked = await showModalBottomSheet<SubcategoryItem>(
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
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
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
                    Icons.chevron_right_rounded,
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
                      Icons.chevron_right_rounded,
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

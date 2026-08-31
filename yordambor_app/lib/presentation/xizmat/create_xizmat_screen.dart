import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/category_providers.dart';
import 'package:yordambor/application/providers/create_xizmat_provider.dart';
import 'package:yordambor/application/providers/feed_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/core/utils/phone_validation.dart';
import 'package:yordambor/domain/entities/category_item.dart';
import 'package:yordambor/presentation/shared/post_contact_preferences_section.dart';
import 'package:yordambor/presentation/shared/xizmat_availability_section.dart';
import 'package:yordambor/presentation/shared/xizmat_promise_section.dart';
import 'package:yordambor/presentation/shared/xizmat_pricing_section.dart';

class CreateXizmatScreen extends ConsumerWidget {
  const CreateXizmatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createXizmatProvider);
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.createXizmat),
        leading: state.step == 2
            ? null
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
        bottom: state.step < 2
            ? PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: LinearProgressIndicator(
                  value: (state.step + 1) / 2,
                  minHeight: 3,
                  backgroundColor: colors.borderSubtle,
                  color: AppColors.primary,
                ),
              )
            : null,
      ),
      body: switch (state.step) {
        0 => const _StepIdentity(),
        1 => const _StepPortfolio(),
        _ => const _StepSuccess(),
      },
    );
  }
}

class _StepIdentity extends ConsumerWidget {
  const _StepIdentity();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createXizmatProvider);
    final notifier = ref.read(createXizmatProvider.notifier);
    final language = ref.watch(onboardingPrefsProvider).language;
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(
                strings.xizmatStepIdentity,
                style: AppTypography.headline.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.lg),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'individual',
                    label: Text(strings.xizmatProviderIndividual),
                  ),
                  ButtonSegment(
                    value: 'institution',
                    label: Text(strings.xizmatProviderInstitution),
                  ),
                ],
                selected: {state.providerType},
                onSelectionChanged: (value) =>
                    notifier.setProviderType(value.first),
              ),
              const SizedBox(height: AppSpacing.xl),
              TextFormField(
                initialValue: state.name,
                decoration: InputDecoration(labelText: strings.xizmatNameLabel),
                onChanged: notifier.setName,
              ),
              const SizedBox(height: AppSpacing.lg),
              _PickRow(
                title: strings.filterCategory,
                value: state.category?.label(language) ?? strings.actionPick,
                onTap: () => _pickCategory(context, ref),
              ),
              _PickRow(
                title: strings.filterSubcategory,
                value: state.subcategory?.label(language) ?? strings.actionPick,
                enabled: state.category != null,
                onTap: state.category == null
                    ? null
                    : () => _pickSubcategory(context, ref, state.category!),
              ),
              if (state.errorMessage != null) ...[
                const SizedBox(height: AppSpacing.md),
                YbInlineMessage(message: state.errorMessage!),
              ],
            ],
          ),
        ),
        YbStickyActionBar(
          children: [
            YbPrimaryButton(
              label: strings.xizmatContinue,
              onPressed: state.canContinueStep1 ? notifier.nextStep : null,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickCategory(BuildContext context, WidgetRef ref) async {
    final language = ref.read(onboardingPrefsProvider).language;
    final categories = await ref.read(categoriesProvider.future);

    if (!context.mounted) return;

    final selected = await showModalBottomSheet<CategoryItem>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _CategoryPickList(
        categories: categories,
        language: language,
      ),
    );

    if (selected != null) {
      ref.read(createXizmatProvider.notifier).setCategory(selected);
    }
  }

  Future<void> _pickSubcategory(
    BuildContext context,
    WidgetRef ref,
    CategoryItem category,
  ) async {
    final language = ref.read(onboardingPrefsProvider).language;
    final providerType = ref.read(createXizmatProvider).providerType;

    if (!context.mounted) return;

    final subs = category.subcategories
        .where((sub) => sub.providerType == providerType)
        .toList();

    final selected = await showModalBottomSheet<SubcategoryItem>(
      context: context,
      showDragHandle: true,
      builder: (context) => _SubcategoryPickList(
        subcategories: subs,
        language: language,
      ),
    );

    if (selected != null) {
      ref.read(createXizmatProvider.notifier).setSubcategory(selected);
    }
  }
}

class _PickRow extends StatelessWidget {
  const _PickRow({
    required this.title,
    required this.value,
    this.onTap,
    this.enabled = true,
  });

  final String title;
  final String value;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Material(
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
                      value,
                      style: AppTypography.headline.copyWith(
                        color: enabled ? colors.textPrimary : colors.textTertiary,
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
    );
  }
}

class _StepPortfolio extends ConsumerStatefulWidget {
  const _StepPortfolio();

  @override
  ConsumerState<_StepPortfolio> createState() => _StepPortfolioState();
}

class _StepPortfolioState extends ConsumerState<_StepPortfolio> {
  late final TextEditingController _phoneController;
  late final TextEditingController _priceController;
  late final TextEditingController _minDurationController;
  late final TextEditingController _promiseController;
  bool _phonePrefilled = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _priceController = TextEditingController();
    _minDurationController = TextEditingController();
    _promiseController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _priceController.dispose();
    _minDurationController.dispose();
    _promiseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createXizmatProvider);
    final notifier = ref.read(createXizmatProvider.notifier);
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final profilePhone = ref.watch(sessionProvider).profile?.phone;
    if (!_phonePrefilled) {
      _phonePrefilled = true;
      notifier.prefillContactPhone(profilePhone);
      if (profilePhone != null && profilePhone.isNotEmpty) {
        _phoneController.text = profilePhone;
      }
    } else if (_phoneController.text != state.contactPhone) {
      _phoneController.text = state.contactPhone;
    }
    if (_priceController.text != state.basePriceText) {
      _priceController.text = state.basePriceText;
    }
    if (_minDurationController.text != state.minDurationText) {
      _minDurationController.text = state.minDurationText;
    }
    if (_promiseController.text != state.servicePromiseText) {
      _promiseController.text = state.servicePromiseText;
    }
    final picker = ImagePicker();

    Future<void> pickImage() async {
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (file == null) return;

      final bytes = await file.readAsBytes();
      final ext = file.path.split('.').last.toLowerCase();
      notifier.addPortfolio(
        PortfolioDraft(
          bytes: bytes,
          extension: ext == 'png' || ext == 'webp' ? ext : 'jpg',
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(
                strings.xizmatStepPortfolio,
                style: AppTypography.headline.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                strings.xizmatPortfolioHint,
                style: AppTypography.caption.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (var i = 0; i < state.portfolio.length; i++)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          child: Image.memory(
                            state.portfolio[i].bytes,
                            width: 104,
                            height: 104,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (i == 0)
                          Positioned(
                            left: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                strings.xizmatHeroLabel,
                                style: AppTypography.label.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                              foregroundColor: Colors.white,
                            ),
                            iconSize: 18,
                            onPressed: () => notifier.removePortfolioAt(i),
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                  InkWell(
                    onTap: pickImage,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    child: Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(color: colors.borderSubtle),
                        color: colors.card,
                      ),
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        color: colors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                initialValue: state.description,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: strings.xizmatDescriptionLabel,
                  alignLabelWithHint: true,
                ),
                onChanged: notifier.setDescription,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                initialValue: state.serviceCity,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: strings.xizmatServiceCityLabel,
                  hintText: strings.xizmatServiceCityHint,
                ),
                onChanged: notifier.setServiceCity,
              ),
              const SizedBox(height: AppSpacing.lg),
              XizmatAvailabilitySection(
                strings: strings,
                visible: state.availabilityVisible,
                onVisibleChanged: notifier.setAvailabilityVisible,
                mode: state.availabilityMode,
                onModeChanged: notifier.setAvailabilityMode,
                from: state.availabilityFrom,
                until: state.availabilityUntil,
                onFromChanged: notifier.setAvailabilityFrom,
                onUntilChanged: notifier.setAvailabilityUntil,
              ),
              const SizedBox(height: AppSpacing.lg),
              XizmatPricingSection(
                strings: strings,
                pricingModel: state.pricingModel,
                onPricingModelChanged: notifier.setPricingModel,
                priceController: _priceController,
                minDurationController: _minDurationController,
              ),
              const SizedBox(height: AppSpacing.lg),
              XizmatPromiseSection(
                strings: strings,
                visible: state.showServicePromise,
                onVisibleChanged: notifier.setShowServicePromise,
                promiseController: _promiseController,
                onPromiseChanged: () =>
                    notifier.setServicePromiseText(_promiseController.text),
              ),
              const SizedBox(height: AppSpacing.lg),
              PostContactPreferencesSection(
                strings: strings,
                phoneController: _phoneController,
                showContactPhone: state.showContactPhone,
                onShowContactPhoneChanged: notifier.setShowContactPhone,
                phoneValidator: (value) {
                  if (!isValidOptionalContactPhone(value ?? '')) {
                    return strings.invalidPhone;
                  }
                  return null;
                },
              ),
              if (state.errorMessage != null) ...[
                const SizedBox(height: AppSpacing.md),
                YbInlineMessage(message: state.errorMessage!),
              ],
            ],
          ),
        ),
        YbStickyActionBar(
          children: [
            YbPrimaryButton(
              label: state.isSubmitting
                  ? strings.xizmatUploading
                  : strings.xizmatReady,
              isLoading: state.isSubmitting,
              onPressed: state.canContinueStep2 && !state.isSubmitting
                  ? () async {
                      if (!isValidOptionalContactPhone(_phoneController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(strings.invalidPhone)),
                        );
                        return;
                      }
                      notifier.setContactPhone(_phoneController.text);
                      notifier.setBasePriceText(_priceController.text);
                      notifier.setMinDurationText(_minDurationController.text);
                      notifier.setServicePromiseText(_promiseController.text);
                      final ok = await notifier.submit();
                      if (ok) {
                        ref.read(feedProvider.notifier).load();
                        ref.invalidate(myXizmatlarProvider);
                      }
                    }
                  : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            YbSecondaryButton(
              label: strings.xizmatBack,
              onPressed: notifier.previousStep,
            ),
          ],
        ),
      ],
    );
  }
}

class _StepSuccess extends ConsumerWidget {
  const _StepSuccess();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              size: 52,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            strings.xizmatSuccessTitle,
            style: AppTypography.title.copyWith(color: colors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            strings.xizmatSuccessBody,
            style: AppTypography.body.copyWith(color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxxl),
          YbPrimaryButton(
            label: strings.tabHome,
            onPressed: () {
              ref.read(createXizmatProvider.notifier).reset();
              context.go('/home');
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryPickList extends StatelessWidget {
  const _CategoryPickList({
    required this.categories,
    required this.language,
  });

  final List<CategoryItem> categories;
  final String language;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return SafeArea(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        itemCount: categories.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          indent: AppSpacing.lg,
          color: colors.borderSubtle,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
            leading: Text(category.icon, style: const TextStyle(fontSize: 24)),
            title: Text(
              category.label(language),
              style: AppTypography.headline.copyWith(color: colors.textPrimary),
            ),
            trailing: Icon(Icons.chevron_right_rounded, color: colors.textTertiary),
            onTap: () => Navigator.pop(context, category),
          );
        },
      ),
    );
  }
}

class _SubcategoryPickList extends StatelessWidget {
  const _SubcategoryPickList({
    required this.subcategories,
    required this.language,
  });

  final List<SubcategoryItem> subcategories;
  final String language;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return SafeArea(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        itemCount: subcategories.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          indent: AppSpacing.lg,
          color: colors.borderSubtle,
        ),
        itemBuilder: (context, index) {
          final sub = subcategories[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
            title: Text(
              sub.label(language),
              style: AppTypography.headline.copyWith(color: colors.textPrimary),
            ),
            trailing: Icon(Icons.chevron_right_rounded, color: colors.textTertiary),
            onTap: () => Navigator.pop(context, sub),
          );
        },
      ),
    );
  }
}

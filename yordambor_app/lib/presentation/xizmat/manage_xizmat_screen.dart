import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/category_providers.dart';
import 'package:yordambor/application/providers/feed_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/application/providers/analytics_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/review_providers.dart';
import 'package:yordambor/data/review/review_repository.dart';
import 'package:yordambor/domain/entities/review.dart';
import 'package:yordambor/domain/entities/category_item.dart';
import 'package:yordambor/domain/entities/portfolio_item.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/domain/entities/xizmat_availability_mode.dart';
import 'package:yordambor/domain/entities/xizmat_pricing_model.dart';
import 'package:yordambor/data/xizmat/xizmat_repository.dart';
import 'package:yordambor/core/utils/phone_validation.dart';
import 'package:yordambor/presentation/shared/post_contact_preferences_section.dart';
import 'package:yordambor/presentation/shared/xizmat_availability_section.dart';
import 'package:yordambor/presentation/shared/xizmat_pricing_section.dart';
import 'package:yordambor/presentation/shared/xizmat_promise_section.dart';
import 'package:yordambor/presentation/shared/xizmat_service_city_field.dart';

final xizmatPortfolioProvider =
    FutureProvider.family<List<PortfolioItem>, String>((ref, xizmatId) async {
  return ref.watch(xizmatRepositoryProvider).fetchPortfolioItems(xizmatId);
});

class ManageXizmatScreen extends ConsumerStatefulWidget {
  const ManageXizmatScreen({super.key, required this.xizmatId});

  final String xizmatId;

  @override
  ConsumerState<ManageXizmatScreen> createState() => _ManageXizmatScreenState();
}

class _ManageXizmatScreenState extends ConsumerState<ManageXizmatScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _priceController = TextEditingController();
  final _minDurationController = TextEditingController();
  final _promiseController = TextEditingController();
  final _serviceCityController = TextEditingController();

  CategoryItem? _category;
  SubcategoryItem? _subcategory;
  String _providerType = 'individual';
  XizmatPricingModel _pricingModel = XizmatPricingModel.negotiable;
  bool _availabilityVisible = false;
  XizmatAvailabilityMode? _availabilityMode;
  DateTime? _availabilityFrom;
  DateTime? _availabilityUntil;
  bool _showServicePromise = false;
  bool _showContactPhone = false;
  bool _initialized = false;
  bool _isSaving = false;
  bool _isUploading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _priceController.dispose();
    _minDurationController.dispose();
    _promiseController.dispose();
    _serviceCityController.dispose();
    super.dispose();
  }

  void _initFrom(XizmatFeedItem item) {
    if (_initialized) return;
    _initialized = true;
    _nameController.text = item.name;
    _descriptionController.text = item.description ?? '';
    _providerType = item.providerType;
    _phoneController.text = item.contactPhone ?? '';
    _showContactPhone = item.showContactPhone;
    _pricingModel = item.pricingModel;
    if (item.basePrice != null) {
      final price = item.basePrice!;
      _priceController.text =
          price % 1 == 0 ? price.toInt().toString() : price.toString();
    }
    if (item.minDurationMinutes != null) {
      _minDurationController.text = item.minDurationMinutes.toString();
    }
    _availabilityVisible = item.availabilityVisible;
    _availabilityMode = item.availabilityMode;
    _availabilityFrom = item.availabilityFrom;
    _availabilityUntil = item.availabilityUntil;
    _showServicePromise = item.showServicePromise;
    _promiseController.text = item.servicePromise ?? '';
    _serviceCityController.text = item.serviceCity ?? '';

    ref.read(categoriesProvider.future).then((categories) {
      for (final category in categories) {
        if (category.id != item.categoryId) continue;
        _category = category;
        for (final sub in category.subcategories) {
          if (sub.id == item.subcategoryId) {
            _subcategory = sub;
            break;
          }
        }
        break;
      }
      if (mounted) setState(() {});
    });
  }

  Future<void> _saveIdentity() async {
    final category = _category;
    final subcategory = _subcategory;
    if (category == null || subcategory == null) {
      setState(() => _errorMessage = ref.read(appStringsProvider).xizmatPickCategoryError);
      return;
    }

    if (!isValidOptionalContactPhone(_phoneController.text)) {
      setState(() => _errorMessage = ref.read(appStringsProvider).invalidPhone);
      return;
    }

    final contactPhone = normalizeOptionalContactPhone(_phoneController.text);
    final strings = ref.read(appStringsProvider);

    final pricingError = validateXizmatPricing(
      model: _pricingModel,
      priceText: _priceController.text,
      strings: strings,
    );
    if (pricingError != null) {
      setState(() => _errorMessage = pricingError);
      return;
    }

    final availabilityError = validateXizmatAvailability(
      visible: _availabilityVisible,
      mode: _availabilityMode,
      from: _availabilityFrom,
      until: _availabilityUntil,
      strings: strings,
    );
    if (availabilityError != null) {
      setState(() => _errorMessage = availabilityError);
      return;
    }

    final promiseError = validateXizmatPromise(
      visible: _showServicePromise,
      promiseText: _promiseController.text,
      strings: strings,
    );
    if (promiseError != null) {
      setState(() => _errorMessage = promiseError);
      return;
    }

    final basePrice = _pricingModel == XizmatPricingModel.negotiable
        ? null
        : parseOptionalPrice(_priceController.text);
    final minDuration = _pricingModel == XizmatPricingModel.hourly
        ? parseOptionalMinutes(_minDurationController.text)
        : null;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await ref.read(xizmatRepositoryProvider).updateXizmat(
            widget.xizmatId,
            UpdateXizmatInput(
              name: _nameController.text,
              providerType: _providerType,
              categoryId: category.id,
              subcategoryId: subcategory.id,
              description: _descriptionController.text,
              contactPhone: contactPhone,
              showContactPhone: _showContactPhone,
              pricingModel: _pricingModel,
              basePrice: basePrice,
              minDurationMinutes: minDuration,
              availabilityVisible: _availabilityVisible,
              availabilityMode: _availabilityMode,
              availabilityFrom: _availabilityFrom,
              availabilityUntil: _availabilityUntil,
              showServicePromise: _showServicePromise,
              servicePromise: normalizeServicePromise(_promiseController.text),
              serviceCity: normalizeServiceCity(_serviceCityController.text),
            ),
          );
      ref.invalidate(xizmatDetailProvider(widget.xizmatId));
      ref.invalidate(myXizmatlarProvider);
      ref.read(feedProvider.notifier).load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ref.read(appStringsProvider).xizmatSaved)),
        );
      }
    } on XizmatFailure catch (error) {
      setState(() => _errorMessage = error.message);
    } catch (error) {
      setState(() => _errorMessage = error.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _addPhoto() async {
    final session = ref.read(sessionProvider);
    final userId = session.user?.id;
    if (userId == null) return;

    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      imageQuality: 85,
    );
    if (file == null) return;

    setState(() => _isUploading = true);
    try {
      final bytes = await file.readAsBytes();
      final ext = file.path.split('.').last;
      final url = await ref.read(storageRepositoryProvider).uploadPortfolioImage(
            ownerId: userId,
            xizmatId: widget.xizmatId,
            bytes: bytes,
            fileExtension: ext,
          );
      await ref
          .read(xizmatRepositoryProvider)
          .addPortfolioItem(widget.xizmatId, url);
      ref.invalidate(xizmatPortfolioProvider(widget.xizmatId));
      ref.invalidate(xizmatDetailProvider(widget.xizmatId));
      ref.read(feedProvider.notifier).load();
    } on Exception catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _removePhoto(PortfolioItem item) async {
    try {
      await ref
          .read(xizmatRepositoryProvider)
          .removePortfolioItem(widget.xizmatId, item.id);
      ref.invalidate(xizmatPortfolioProvider(widget.xizmatId));
      ref.invalidate(xizmatDetailProvider(widget.xizmatId));
      ref.read(feedProvider.notifier).load();
    } on XizmatFailure catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    }
  }

  Future<void> _setHero(PortfolioItem item) async {
    await ref
        .read(xizmatRepositoryProvider)
        .setHeroPortfolioItem(widget.xizmatId, item.id);
    ref.invalidate(xizmatPortfolioProvider(widget.xizmatId));
    ref.invalidate(xizmatDetailProvider(widget.xizmatId));
    ref.read(feedProvider.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(onboardingPrefsProvider).language;
    final strings = ref.watch(appStringsProvider);
    final detailAsync = ref.watch(xizmatDetailProvider(widget.xizmatId));
    final portfolioAsync = ref.watch(xizmatPortfolioProvider(widget.xizmatId));
    final userId = ref.watch(sessionProvider).user?.id;

    return detailAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(strings.xizmatEditTitle)),
        body: const YbSkeletonList(count: 3),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(strings.xizmatEditTitle)),
        body: AppLayout.page(
          context: context,
          child: YbEmptyState(
            icon: Icons.error_outline_rounded,
            title: strings.xizmatEditTitle,
            subtitle: '$error',
          ),
        ),
      ),
      data: (item) {
        if (item == null) {
          return Scaffold(
            appBar: AppBar(title: Text(strings.xizmatEditTitle)),
            body: AppLayout.page(
              context: context,
              child: YbEmptyState(
                icon: Icons.search_off_outlined,
                title: strings.xizmatEditTitle,
                subtitle: strings.xizmatNotFound,
              ),
            ),
          );
        }

        if (item.ownerId != userId) {
          return Scaffold(
            appBar: AppBar(title: Text(strings.xizmatEditTitle)),
            body: AppLayout.page(
              context: context,
              child: YbEmptyState(
                icon: Icons.lock_outline_rounded,
                title: strings.xizmatEditTitle,
                subtitle: strings.xizmatNoPermission,
              ),
            ),
          );
        }

        _initFrom(item);
        final colors = context.ybColors;

        return Scaffold(
          appBar: AppBar(
            title: Text(strings.xizmatEditTitle),
            actions: [
              TextButton(
                onPressed: () => context.push('/xizmat/${widget.xizmatId}'),
                child: Text(strings.actionView),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: AppLayout.page(
                  context: context,
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      _AnalyticsSection(xizmatId: widget.xizmatId),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        strings.xizmatBasicInfo,
                        style: AppTypography.headline.copyWith(
                          color: colors.textPrimary,
                        ),
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
                selected: {_providerType},
                onSelectionChanged: (value) =>
                    setState(() => _providerType = value.first),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: strings.xizmatNameLabel),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: strings.xizmatDescriptionFull),
                maxLines: 4,
              ),
              const SizedBox(height: AppSpacing.lg),
              XizmatServiceCityField(
                strings: strings,
                controller: _serviceCityController,
              ),
              const SizedBox(height: AppSpacing.lg),
              _ManagePickRow(
                title: strings.filterCategory,
                value: _category?.label(language) ?? strings.actionPick,
                onTap: () => _pickCategory(context),
              ),
              _ManagePickRow(
                title: strings.filterSubcategory,
                value: _subcategory?.label(language) ?? strings.actionPick,
                enabled: _category != null,
                onTap: _category == null ? null : () => _pickSubcategory(context),
              ),
              const SizedBox(height: AppSpacing.lg),
              XizmatAvailabilitySection(
                strings: strings,
                visible: _availabilityVisible,
                onVisibleChanged: (value) => setState(() {
                  _availabilityVisible = value;
                  if (value && _availabilityMode == null) {
                    _availabilityMode = XizmatAvailabilityMode.availableNow;
                  }
                  if (!value) {
                    _availabilityMode = null;
                    _availabilityFrom = null;
                    _availabilityUntil = null;
                  }
                }),
                mode: _availabilityMode,
                onModeChanged: (mode) => setState(() {
                  _availabilityMode = mode;
                  if (mode == XizmatAvailabilityMode.callMe) {
                    _availabilityFrom = null;
                    _availabilityUntil = null;
                  }
                }),
                from: _availabilityFrom,
                until: _availabilityUntil,
                onFromChanged: (value) =>
                    setState(() => _availabilityFrom = value),
                onUntilChanged: (value) =>
                    setState(() => _availabilityUntil = value),
              ),
              const SizedBox(height: AppSpacing.lg),
              XizmatPricingSection(
                strings: strings,
                pricingModel: _pricingModel,
                onPricingModelChanged: (model) =>
                    setState(() => _pricingModel = model),
                priceController: _priceController,
                minDurationController: _minDurationController,
              ),
              const SizedBox(height: AppSpacing.lg),
              XizmatPromiseSection(
                strings: strings,
                visible: _showServicePromise,
                onVisibleChanged: (value) =>
                    setState(() => _showServicePromise = value),
                promiseController: _promiseController,
                onPromiseChanged: () => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.lg),
              PostContactPreferencesSection(
                strings: strings,
                phoneController: _phoneController,
                showContactPhone: _showContactPhone,
                onShowContactPhoneChanged: (value) =>
                    setState(() => _showContactPhone = value),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: AppSpacing.md),
                YbInlineMessage(message: _errorMessage!),
              ],
              const SizedBox(height: AppSpacing.xxxl),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      strings.xizmatPortfolio,
                      style: AppTypography.headline.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  if (_isUploading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    IconButton(
                      onPressed: _addPhoto,
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                      tooltip: strings.xizmatAddPhoto,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              portfolioAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, _) => Text('$error'),
                data: (items) {
                  if (items.isEmpty) {
                    return Text(
                      strings.xizmatPortfolioEmpty,
                      style: AppTypography.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: AppSpacing.sm,
                      mainAxisSpacing: AppSpacing.sm,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final photo = items[index];
                      return _PortfolioTile(
                        item: photo,
                        strings: strings,
                        onSetHero: () => _setHero(photo),
                        onRemove: () => _removePhoto(photo),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xxxl),
              _ProviderReviewsSection(xizmatId: widget.xizmatId),
                    ],
                  ),
                ),
              ),
              YbStickyActionBar(
                children: [
                  YbPrimaryButton(
                    label: strings.actionSave,
                    isLoading: _isSaving,
                    onPressed: _isSaving ? null : _saveIdentity,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickCategory(BuildContext context) async {
    final categories = await ref.read(categoriesProvider.future);
    if (!context.mounted) return;

    final picked = await showModalBottomSheet<CategoryItem>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _PickerList(
        title: ref.read(appStringsProvider).filterCategory,
        labels: categories
            .map((c) => c.label(ref.read(onboardingPrefsProvider).language))
            .toList(),
        onPick: (index) => Navigator.of(context).pop(categories[index]),
      ),
    );

    if (picked != null) {
      setState(() {
        _category = picked;
        _subcategory = null;
      });
    }
  }

  Future<void> _pickSubcategory(BuildContext context) async {
    final category = _category;
    if (category == null) return;

    final subs = category.subcategories;
    final picked = await showModalBottomSheet<SubcategoryItem>(
      context: context,
      showDragHandle: true,
      builder: (context) => _PickerList(
        title: ref.read(appStringsProvider).filterSubcategory,
        labels: subs
            .map((s) => s.label(ref.read(onboardingPrefsProvider).language))
            .toList(),
        onPick: (index) => Navigator.of(context).pop(subs[index]),
      ),
    );

    if (picked != null) setState(() => _subcategory = picked);
  }
}

class _PortfolioTile extends StatelessWidget {
  const _PortfolioTile({
    required this.item,
    required this.strings,
    required this.onSetHero,
    required this.onRemove,
  });

  final PortfolioItem item;
  final AppStrings strings;
  final VoidCallback onSetHero;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.chip),
          child: CachedNetworkImage(
            imageUrl: item.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        if (item.isHero)
          Positioned(
            left: AppSpacing.xs,
            top: AppSpacing.xs,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
              child: Text(
                strings.xizmatHeroLabel,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        Positioned(
          right: 0,
          bottom: 0,
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'hero') onSetHero();
              if (value == 'remove') onRemove();
            },
            itemBuilder: (context) => [
              if (!item.isHero)
                PopupMenuItem(
                  value: 'hero',
                  child: Text(strings.xizmatSetHero),
                ),
              PopupMenuItem(
                value: 'remove',
                child: Text(strings.actionDelete),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnalyticsSection extends ConsumerWidget {
  const _AnalyticsSection({required this.xizmatId});

  final String xizmatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final statsAsync = ref.watch(xizmatAnalyticsProvider(xizmatId));

    return statsAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, _) => const SizedBox.shrink(),
      data: (stats) {
        return YbSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                strings.xizmatAnalytics,
                style: AppTypography.headline.copyWith(
                  color: context.ybColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.sm,
                children: [
                  _StatChip(
                    label: strings.analyticsViews,
                    value: '${stats.viewCount}',
                  ),
                  _StatChip(
                    label: strings.analyticsFavorites,
                    value: '${stats.favoriteCount}',
                  ),
                  _StatChip(
                    label: strings.analyticsActiveDeals,
                    value: '${stats.incomingDeals}',
                  ),
                  _StatChip(
                    label: strings.analyticsCompletedDeals,
                    value: '${stats.completedDeals}',
                  ),
                ],
              ),
              if (stats.viewCount > 0) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  strings.analyticsConversion(
                    stats.conversionRate.toStringAsFixed(1),
                  ),
                  style: AppTypography.caption.copyWith(
                    color: context.ybColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTypography.title.copyWith(color: colors.textPrimary),
        ),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

class _ProviderReviewsSection extends ConsumerWidget {
  const _ProviderReviewsSection({required this.xizmatId});

  final String xizmatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final reviewsAsync = ref.watch(xizmatReviewsProvider(xizmatId));

    return reviewsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (reviews) {
        if (reviews.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              strings.xizmatReviewReplies,
              style: AppTypography.headline.copyWith(
                color: context.ybColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...reviews.map((review) => _ReviewReplyTile(review: review)),
          ],
        );
      },
    );
  }
}

class _ReviewReplyTile extends ConsumerStatefulWidget {
  const _ReviewReplyTile({required this.review});

  final Review review;

  @override
  ConsumerState<_ReviewReplyTile> createState() => _ReviewReplyTileState();
}

class _ReviewReplyTileState extends ConsumerState<_ReviewReplyTile> {
  late final TextEditingController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.review.providerReply ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await ref.read(reviewRepositoryProvider).setProviderReply(
            widget.review.id,
            _controller.text,
          );
      ref.invalidate(xizmatReviewsProvider(widget.review.xizmatId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ref.read(appStringsProvider).xizmatReplySaved)),
        );
      }
    } on ReviewFailure catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final review = widget.review;
    final colors = context.ybColors;

    return YbSurfaceCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.star_rounded, color: AppColors.star, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${review.rating}/5',
                style: AppTypography.headline.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  review.reviewerName ?? strings.xizmatClientLabel,
                  style: AppTypography.caption.copyWith(color: colors.textSecondary),
                ),
              ),
            ],
          ),
          if (review.comment != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              review.comment!,
              style: AppTypography.body.copyWith(color: colors.textPrimary),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: strings.xizmatReplyLabel,
              hintText: strings.xizmatReplyHint,
            ),
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: YbPrimaryButton(
              label: strings.actionSave,
              isLoading: _isSaving,
              onPressed: _isSaving ? null : _save,
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerList extends StatelessWidget {
  const _PickerList({
    required this.title,
    required this.labels,
    required this.onPick,
  });

  final String title;
  final List<String> labels;
  final void Function(int index) onPick;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              title,
              style: AppTypography.title.copyWith(color: colors.textPrimary),
            ),
          ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: labels.length,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                indent: AppSpacing.lg,
                color: colors.borderSubtle,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xs,
                  ),
                  title: Text(
                    labels[index],
                    style: AppTypography.headline.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: colors.textTertiary,
                  ),
                  onTap: () => onPick(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ManagePickRow extends StatelessWidget {
  const _ManagePickRow({
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

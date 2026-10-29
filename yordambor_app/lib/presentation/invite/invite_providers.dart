import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yordambor/application/providers/category_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/constants/service_cities.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_picker_sheet.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/share/app_share_links.dart';
import 'package:yordambor/core/utils/category_icons.dart';
import 'package:yordambor/core/utils/phone_validation.dart';
import 'package:yordambor/domain/entities/category_item.dart';
import 'package:yordambor/domain/entities/create_xizmat_prefill.dart';
import 'package:yordambor/presentation/shared/xizmat_service_city_field.dart';

/// Inviting real providers: anyone can send the app to a provider they
/// know, or prepare a link that opens "new service" with a trade and city
/// filled in. The provider always publishes the service themselves;
/// nothing is created for them, and the name and phone typed here only
/// address the message.

/// The text an invite carries: [lead] (or the general invitation), a link
/// that opens "new service" in the app, and the app's store page.
String providerInviteText(
  AppStrings strings, {
  String? lead,
  CreateXizmatPrefill prefill = const CreateXizmatPrefill(),
}) {
  return [
    lead ?? strings.inviteMessage,
    strings.inviteOpenLink(AppShareLinks.joinLink(prefill)),
    strings.inviteAppLink(AppShareLinks.playStoreLink),
  ].join('\n\n');
}

/// The general invitation through the share sheet.
Future<void> shareProviderInvite(AppStrings strings) {
  return SharePlus.instance.share(
    ShareParams(
      text: providerInviteText(strings),
      subject: strings.inviteTitle,
    ),
  );
}

/// The same invitation as a sheet, from the samples on Home.
Future<void> showInviteProvidersSheet(
  BuildContext context,
  WidgetRef ref,
) async {
  final strings = ref.read(appStringsProvider);
  final prepare = await showModalBottomSheet<bool>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (sheetContext) => YbSheetBody(
      title: strings.inviteTitle,
      subtitle: strings.inviteBody,
      children: [
        _FoundingLine(strings: strings),
        const SizedBox(height: AppSpacing.xl),
        YbPrimaryButton(
          label: strings.inviteShare,
          icon: YbIcons.share,
          onPressed: () {
            Navigator.of(sheetContext).pop();
            shareProviderInvite(strings);
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        YbSecondaryButton(
          label: strings.invitePrepare,
          icon: YbIcons.personAdd,
          onPressed: () => Navigator.of(sheetContext).pop(true),
        ),
      ],
    ),
  );
  if (prepare == true && context.mounted) {
    await showPrepareServiceInviteSheet(context, ref);
  }
}

/// "The first providers get the badge", beside the medal.
class _FoundingLine extends StatelessWidget {
  const _FoundingLine({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(YbIcons.militaryTechFilled, size: 20, color: colors.star),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            strings.foundingBadgeNote,
            style: AppTypography.caption.copyWith(color: colors.ink2),
          ),
        ),
      ],
    );
  }
}

/// "Prepare a service for someone": pick their trade and city, and send
/// them a link that opens "new service" with both filled in.
Future<void> showPrepareServiceInviteSheet(
  BuildContext context,
  WidgetRef ref,
) {
  return showModalBottomSheet<void>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => const _PrepareInviteSheet(),
  );
}

enum _InviteChannel { whatsApp, sms, other }

class _PrepareInviteSheet extends ConsumerStatefulWidget {
  const _PrepareInviteSheet();

  @override
  ConsumerState<_PrepareInviteSheet> createState() =>
      _PrepareInviteSheetState();
}

class _PrepareInviteSheetState extends ConsumerState<_PrepareInviteSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  CategoryItem? _category;
  SubcategoryItem? _subcategory;
  String? _cityId;
  bool _showMissing = false;
  String? _phoneError;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickTrade() async {
    final strings = ref.read(appStringsProvider);
    final language = ref.read(onboardingPrefsProvider).language;
    List<CategoryItem> categories;
    try {
      categories = await ref.read(categoriesProvider.future);
    } catch (_) {
      return;
    }
    if (!mounted) return;

    final categoryId = await showYbPickerSheet<String>(
      context: context,
      child: Builder(
        builder: (sheetContext) => YbCompactPickerSheet(
          title: strings.filterCategory,
          headerIcon: YbIcons.category,
          selectedId: _category?.id,
          options: [
            for (final category in categories)
              YbPickerOption(
                id: category.id,
                label: category.label(language),
                icon: CategoryIcons.forService(categoryId: category.id),
              ),
          ],
          onSelected: (option) => Navigator.of(sheetContext).pop(option.id),
        ),
      ),
    );
    if (categoryId == null || !mounted) return;
    CategoryItem? found;
    for (final item in categories) {
      if (item.id == categoryId) found = item;
    }
    if (found == null) return;
    final category = found;
    final subs = category.subcategories;

    final subcategoryId = await showYbPickerSheet<String>(
      context: context,
      child: Builder(
        builder: (sheetContext) => YbCompactPickerSheet(
          title: strings.filterSubcategory,
          headerIcon: CategoryIcons.forService(categoryId: category.id),
          selectedId: _subcategory == null ? null : _subKey(_subcategory!),
          options: [
            for (final sub in subs)
              YbPickerOption(
                id: _subKey(sub),
                label: sub.label(language),
                subtitle: strings.providerTypeLabel(sub.providerType),
                icon: CategoryIcons.forService(
                  categoryId: category.id,
                  subcategoryId: sub.id,
                ),
              ),
          ],
          onSelected: (option) => Navigator.of(sheetContext).pop(option.id),
        ),
      ),
    );
    if (subcategoryId == null || !mounted) return;
    SubcategoryItem? subcategory;
    for (final item in subs) {
      if (_subKey(item) == subcategoryId) subcategory = item;
    }
    if (subcategory == null) return;
    setState(() {
      _category = category;
      _subcategory = subcategory;
    });
  }

  /// "Other" is a trade for both kinds of provider; the kind tells them
  /// apart.
  static String _subKey(SubcategoryItem sub) => '${sub.providerType}/${sub.id}';

  Future<void> _pickCity() {
    final strings = ref.read(appStringsProvider);
    return showServiceCityPicker(
      context: context,
      strings: strings,
      selectedId: _cityId,
      onSelected: (id) => setState(() => _cityId = id),
    );
  }

  Future<void> _send(_InviteChannel channel) async {
    final strings = ref.read(appStringsProvider);
    final language = ref.read(onboardingPrefsProvider).language;
    final category = _category;
    final subcategory = _subcategory;
    final cityId = _cityId;
    final phoneText = _phoneController.text.trim();
    final phoneOk = isValidOptionalContactPhone(phoneText);
    setState(() {
      _showMissing = true;
      _phoneError = phoneOk ? null : strings.invalidPhone;
    });
    if (category == null || subcategory == null || cityId == null || !phoneOk) {
      return;
    }

    final name = _nameController.text.trim();
    final trade = subcategory.label(language);
    final city = strings.serviceCityLabel(cityId);
    final text = providerInviteText(
      strings,
      lead: name.isEmpty
          ? strings.invitePersonalMessageNoName(trade, city)
          : strings.invitePersonalMessage(name, trade, city),
      prefill: CreateXizmatPrefill(
        categoryId: category.id,
        subcategoryId: subcategory.id,
        cityId: cityId,
        providerType: subcategory.providerType,
      ),
    );
    final phone = normalizeOptionalContactPhone(phoneText);

    final uri = switch (channel) {
      // wa.me takes the number as digits only; without one, WhatsApp asks
      // whom to send it to.
      _InviteChannel.whatsApp => Uri.parse(
          'https://wa.me/${phone?.replaceAll(RegExp(r'\D'), '') ?? ''}'
          '?text=${Uri.encodeComponent(text)}',
        ),
      _InviteChannel.sms => Uri.parse(
          'sms:${phone ?? ''}?body=${Uri.encodeComponent(text)}',
        ),
      _InviteChannel.other => null,
    };

    var opened = false;
    if (uri != null) {
      try {
        opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {
        opened = false;
      }
    }
    // No such app here: the share sheet still gets it out.
    if (!opened) {
      await SharePlus.instance.share(
        ShareParams(text: text, subject: strings.inviteTitle),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final language = ref.watch(onboardingPrefsProvider).language;
    final colors = context.ybColors;
    final missing = _showMissing &&
        (_category == null || _subcategory == null || _cityId == null);

    return YbSheetBody(
      title: strings.invitePrepareTitle,
      subtitle: strings.invitePrepareBody,
      children: [
        TextField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: strings.invitePersonName),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: strings.invitePersonPhone,
            hintText: '+998',
            errorText: _phoneError,
          ),
          onChanged: (_) {
            if (_phoneError != null) setState(() => _phoneError = null);
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        _PickTile(
          icon: _subcategory == null
              ? YbIcons.category
              : CategoryIcons.forService(
                  categoryId: _category?.id,
                  subcategoryId: _subcategory?.id,
                ),
          title: strings.invitePickTrade,
          value: _subcategory?.label(language),
          placeholder: strings.actionPick,
          onTap: _pickTrade,
        ),
        _PickTile(
          icon: YbIcons.locationOnFilled,
          iconColor: colors.place,
          title: strings.filterCity,
          value: _cityId == null || !ServiceCities.isValidId(_cityId)
              ? null
              : strings.serviceCityLabel(_cityId!),
          placeholder: strings.actionPick,
          onTap: _pickCity,
        ),
        if (missing) ...[
          const SizedBox(height: AppSpacing.sm),
          YbInlineMessage(message: strings.inviteNeedTradeCity),
        ],
        const SizedBox(height: AppSpacing.lg),
        YbPrimaryButton(
          label: strings.inviteSendWhatsApp,
          icon: YbIcons.chatBubbleFilled,
          height: 48,
          onPressed: () => _send(_InviteChannel.whatsApp),
        ),
        const SizedBox(height: AppSpacing.sm),
        YbSecondaryButton(
          label: strings.inviteSendSms,
          icon: YbIcons.chat,
          height: 48,
          onPressed: () => _send(_InviteChannel.sms),
        ),
        const SizedBox(height: AppSpacing.xs),
        Center(
          child: TextButton.icon(
            onPressed: () => _send(_InviteChannel.other),
            icon: const Icon(YbIcons.share, size: 18),
            label: Text(strings.inviteSendOther),
          ),
        ),
      ],
    );
  }
}

/// A choice in the sheet: what it is, what is picked (or "Pick"), a chevron.
class _PickTile extends StatelessWidget {
  const _PickTile({
    required this.icon,
    required this.title,
    required this.placeholder,
    required this.onTap,
    this.value,
    this.iconColor,
  });

  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            children: [
              Icon(icon, size: 22, color: iconColor ?? colors.teal),
              const SizedBox(width: AppSpacing.md),
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
                    const SizedBox(height: 2),
                    Text(
                      value ?? placeholder,
                      style: AppTypography.headline.copyWith(
                        color: value == null
                            ? colors.textTertiary
                            : colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(YbIcons.chevronRightFilled, color: colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

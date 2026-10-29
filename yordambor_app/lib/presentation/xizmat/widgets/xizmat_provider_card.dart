import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/public_profile_providers.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_dotted_line.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/presentation/profile/widgets/profile_avatar.dart';

/// Who gives the service, as a small business card near the top of its
/// page: their picture (or initials) with a mark for person or
/// organisation, the name and what they are, then since when they are on
/// YordamBor and how many services they offer. The whole card opens their
/// profile.
class XizmatProviderCard extends ConsumerWidget {
  const XizmatProviderCard({
    super.key,
    required this.ownerId,
    required this.isInstitution,
    required this.typeLabel,
    required this.strings,
    this.isSelf = false,
    this.fallbackName,
    this.fallbackAvatarUrl,
  });

  final String ownerId;
  final bool isInstitution;

  /// "Jismoniy shaxs" / "Tashkilot".
  final String typeLabel;
  final AppStrings strings;
  final bool isSelf;
  final String? fallbackName;
  final String? fallbackAvatarUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.ybColors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final profile = ref.watch(publicUserProfileProvider(ownerId)).valueOrNull;
    final services = ref
        .watch(publicUserXizmatlarProvider(ownerId))
        .valueOrNull;

    final name = profile?.fullName.trim().isNotEmpty == true
        ? profile!.fullName.trim()
        : (fallbackName?.trim().isNotEmpty == true
              ? fallbackName!.trim()
              : strings.genericUser);
    final joined = profile?.createdAt;
    final serviceCount = services?.length ?? 0;
    final facts = <(IconData, String)>[
      if (joined != null)
        (
          YbIcons.eventAvailableFilled,
          strings.providerMemberSince('${joined.year}'),
        ),
      if (serviceCount > 0)
        (YbIcons.gridViewFilled, strings.providerServicesCount(serviceCount)),
    ];
    final link = isSelf
        ? strings.profileViewPublic
        : strings.userProfileViewProfile;
    final radius = BorderRadius.circular(AppRadius.card);

    return Semantics(
      button: true,
      label: [
        name,
        typeLabel,
        for (final fact in facts) fact.$2,
        link,
      ].join('. '),
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: dark ? Border.all(color: colors.borderSubtle) : null,
          boxShadow: AppElevation.card(context),
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [
              colors.tealSoft,
              Color.lerp(colors.tealSoft, colors.card, 0.6)!,
              colors.card,
            ],
            stops: const [0, 0.45, 1],
          ),
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () => context.push('/user/$ownerId'),
              child: Stack(
                children: [
                  // The handshake of the brand, faint, as on a printed card.
                  PositionedDirectional(
                    end: -18,
                    bottom: -26,
                    child: ExcludeSemantics(
                      child: Icon(
                        YbIcons.handshakeFilled,
                        size: 120,
                        color: colors.teal.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md + 2,
                      AppSpacing.md + 2,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            _Portrait(
                              name: name,
                              avatarUrl:
                                  profile?.avatarUrl ?? fallbackAvatarUrl,
                              isInstitution: isInstitution,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.headline.copyWith(
                                      color: colors.ink,
                                      fontSize: 18,
                                      height: 22 / 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    typeLabel,
                                    style: AppTypography.label.copyWith(
                                      color: colors.tealInk,
                                      fontSize: 13,
                                      height: 18 / 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Icon(
                              YbIcons.chevronRightFilled,
                              color: colors.ink3,
                            ),
                          ],
                        ),
                        if (facts.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.md),
                          YbDottedLine(
                            color: colors.teal.withValues(alpha: 0.25),
                            thickness: 1,
                            dash: 4,
                            gap: 3,
                          ),
                          const SizedBox(height: AppSpacing.sm + 2),
                          Wrap(
                            spacing: AppSpacing.lg,
                            runSpacing: AppSpacing.xs + 2,
                            children: [
                              for (final (icon, text) in facts)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(icon, size: 16, color: colors.teal),
                                    const SizedBox(width: 5),
                                    Text(
                                      text,
                                      style: AppTypography.caption.copyWith(
                                        color: colors.ink2,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The picture in a white ring, with a small mark for person or
/// organisation at its corner.
class _Portrait extends StatelessWidget {
  const _Portrait({
    required this.name,
    required this.avatarUrl,
    required this.isInstitution,
  });

  final String name;
  final String? avatarUrl;
  final bool isInstitution;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.card, width: 2),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ProfileAvatar(
              fullName: name,
              avatarUrl: avatarUrl,
              radius: 26,
              showChangePhotoAction: false,
            ),
          ),
          PositionedDirectional(
            end: -3,
            bottom: -3,
            child: Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.tealInk,
                shape: BoxShape.circle,
                border: Border.all(color: colors.card, width: 2),
              ),
              child: Icon(
                isInstitution ? YbIcons.apartmentFilled : YbIcons.personFilled,
                size: 12,
                color: colors.onTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

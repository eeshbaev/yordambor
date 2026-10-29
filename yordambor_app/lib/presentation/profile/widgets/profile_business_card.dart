import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/presentation/onboarding/widgets/yordambor_logo.dart';
import 'package:yordambor/presentation/profile/widgets/profile_avatar.dart';

/// Profile header styled as a digital business card.
class ProfileBusinessCard extends ConsumerWidget {
  const ProfileBusinessCard({
    super.key,
    required this.displayName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.userId,
  });

  final String displayName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    const avatarRadius = 44.0;
    final phoneText = phone?.trim();

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppElevation.card(context),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Material(
          color: colors.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 112,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const _CardHeaderBand(),
                    const Positioned(
                      top: AppSpacing.lg,
                      right: AppSpacing.lg,
                      child: _HeaderBrand(),
                    ),
                    Positioned(
                      left: AppSpacing.lg,
                      bottom: -avatarRadius,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colors.card,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ProfileAvatar(
                          fullName: displayName,
                          avatarUrl: avatarUrl,
                          radius: avatarRadius,
                          editable: true,
                          showChangePhotoAction: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  avatarRadius + AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: AppTypography.title.copyWith(
                        color: colors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      strings.appName,
                      style: AppTypography.caption.copyWith(
                        color: context.ybColors.teal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (email.isNotEmpty)
                      _ContactRow(
                        icon: YbIcons.mail,
                        label: email,
                      ),
                    if (phoneText != null && phoneText.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _ContactRow(
                        icon: YbIcons.phone,
                        label: phoneText,
                      ),
                    ],
                    if (userId != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      YbSecondaryButton(
                        label: strings.profileViewPublic,
                        icon: YbIcons.visibility,
                        onPressed: () => context.push('/user/$userId'),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardHeaderBand extends StatelessWidget {
  const _CardHeaderBand();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          // A brand surface: it stays teal in both themes, with white text.
          colors: [
            AppColors.brand,
            AppColors.primary,
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -24,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            left: -36,
            bottom: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBrand extends StatelessWidget {
  const _HeaderBrand();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const YordamBorLogoMark(size: 22, shake: false),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'YordamBor',
            style: AppTypography.label.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.borderSubtle,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: context.ybColors.teal),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyRegular.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

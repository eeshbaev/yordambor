import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/profile_certificate.dart';

class ProfileCertificatesDisplay extends StatelessWidget {
  const ProfileCertificatesDisplay({
    super.key,
    required this.certificates,
    required this.strings,
    this.showDisclaimer = true,
  });

  final List<ProfileCertificate> certificates;
  final AppStrings strings;
  final bool showDisclaimer;

  @override
  Widget build(BuildContext context) {
    if (certificates.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(strings.profileCertificatesTitle, style: AppTypography.headline),
        if (showDisclaimer) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            strings.profileCertificatesDisclaimer,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 168,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: certificates.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final cert = certificates[index];
              return _CertificateTile(
                certificate: cert,
                onTap: () => _openPreview(context, cert),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openPreview(BuildContext context, ProfileCertificate cert) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.card),
              ),
              child: CachedNetworkImage(
                imageUrl: cert.imageUrl,
                fit: BoxFit.cover,
                height: 240,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cert.title, style: AppTypography.title),
                  if (cert.issuer != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(cert.issuer!, style: AppTypography.caption),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CertificateTile extends StatelessWidget {
  const _CertificateTile({required this.certificate, this.onTap});

  final ProfileCertificate certificate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Ink(
        width: 128,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.card),
                ),
                child: CachedNetworkImage(
                  imageUrl: certificate.imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => const ColoredBox(
                    color: AppColors.skeleton,
                    child: Icon(Icons.workspace_premium_outlined),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Text(
                certificate.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.label,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

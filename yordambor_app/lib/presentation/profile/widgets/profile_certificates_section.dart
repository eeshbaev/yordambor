import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yordambor/application/providers/certificate_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_confirm_dialog.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/data/profile/certificate_repository.dart';
import 'package:yordambor/domain/entities/profile_certificate.dart';

class ProfileCertificatesSection extends ConsumerStatefulWidget {
  const ProfileCertificatesSection({
    super.key,
    required this.profileId,
    this.embedded = false,
  });

  final String profileId;
  final bool embedded;

  @override
  ConsumerState<ProfileCertificatesSection> createState() =>
      _ProfileCertificatesSectionState();
}

class _ProfileCertificatesSectionState
    extends ConsumerState<ProfileCertificatesSection> {
  bool _isUploading = false;

  Future<void> _addCertificate() async {
    final strings = ref.read(appStringsProvider);
    final existing = ref.read(profileCertificatesProvider(widget.profileId));
    final count = existing.maybeWhen(data: (items) => items.length, orElse: () => 0);
    if (count >= CertificateRepository.maxCertificates) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.profileCertificatesMaxReached)),
        );
      }
      return;
    }

    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      imageQuality: 85,
    );
    if (file == null || !mounted) return;

    final details = await _CertificateDetailsSheet.show(context, strings);
    if (details == null || !mounted) return;

    setState(() => _isUploading = true);
    try {
      final bytes = await file.readAsBytes();
      final ext = file.path.split('.').last;
      final url = await ref.read(storageRepositoryProvider).uploadCertificateImage(
            ownerId: widget.profileId,
            bytes: bytes,
            fileExtension: ext,
          );
      await ref.read(certificateRepositoryProvider).add(
            profileId: widget.profileId,
            input: AddProfileCertificateInput(
              title: details.title,
              issuer: details.issuer,
              imageUrl: url,
            ),
          );
      ref.invalidate(profileCertificatesProvider(widget.profileId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.profileCertificatesAdded)),
        );
      }
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

  Future<void> _removeCertificate(ProfileCertificate certificate) async {
    final strings = ref.read(appStringsProvider);
    final confirmed = await showYbConfirmDialog(
      context,
      title: strings.profileCertificatesRemoveTitle,
      message: certificate.title,
      confirmLabel: strings.actionDelete,
      isDestructive: true,
    );
    if (!confirmed || !mounted) return;

    try {
      await ref.read(certificateRepositoryProvider).remove(certificate.id);
      ref.invalidate(profileCertificatesProvider(widget.profileId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.profileCertificatesRemoved)),
        );
      }
    } on Exception catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final certsAsync = ref.watch(profileCertificatesProvider(widget.profileId));
    final colors = context.ybColors;

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.profileCertificatesTitle,
                      style: AppTypography.headline.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      strings.profileCertificatesSubtitle,
                      style: AppTypography.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isUploading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: strings.profileCertificatesAdd,
                  onPressed: _addCertificate,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            strings.profileCertificatesDisclaimer,
            style: AppTypography.caption.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          certsAsync.when(
            loading: () => const Column(
              children: [
                YbSkeletonBox(width: double.infinity, height: 48),
              ],
            ),
            error: (error, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                YbInlineMessage(message: strings.profileSectionLoadFailed),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => ref.invalidate(
                      profileCertificatesProvider(widget.profileId),
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(strings.actionRetry),
                  ),
                ),
              ],
            ),
            data: (items) {
              if (items.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      strings.profileCertificatesEmpty,
                      style: AppTypography.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    YbSecondaryButton(
                      label: strings.profileCertificatesAdd,
                      icon: Icons.upload_file_outlined,
                      onPressed: _addCertificate,
                    ),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: items.map(
                  (cert) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.chip),
                      child: Image.network(
                        cert.imageUrl,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => ColoredBox(
                          color: colors.surface,
                          child: const SizedBox(
                            width: 48,
                            height: 48,
                            child: Icon(Icons.workspace_premium_outlined),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      cert.title,
                      style: AppTypography.headline.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    subtitle: cert.issuer != null
                        ? Text(
                            cert.issuer!,
                            style: AppTypography.caption.copyWith(
                              color: colors.textSecondary,
                            ),
                          )
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _removeCertificate(cert),
                    ),
                    onTap: () {},
                  ),
                ).toList(),
              );
            },
          ),
        ],
      );

    if (widget.embedded) return body;
    return YbSurfaceCard(child: body);
  }
}

class _CertificateDetails {
  const _CertificateDetails({required this.title, this.issuer});

  final String title;
  final String? issuer;
}

class _CertificateDetailsSheet extends StatefulWidget {
  const _CertificateDetailsSheet({required this.strings});

  final AppStrings strings;

  static Future<_CertificateDetails?> show(
    BuildContext context,
    AppStrings strings,
  ) {
    return showModalBottomSheet<_CertificateDetails>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => _CertificateDetailsSheet(strings: strings),
    );
  }

  @override
  State<_CertificateDetailsSheet> createState() =>
      _CertificateDetailsSheetState();
}

class _CertificateDetailsSheetState extends State<_CertificateDetailsSheet> {
  final _titleController = TextEditingController();
  final _issuerController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _issuerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = widget.strings;

    return YbSheetBody(
      title: strings.profileCertificatesAdd,
      children: [
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: strings.profileCertificatesTitleLabel,
            hintText: strings.profileCertificatesTitleHint,
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _issuerController,
          decoration: InputDecoration(
            labelText: strings.profileCertificatesIssuerLabel,
            hintText: strings.profileCertificatesIssuerHint,
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: AppSpacing.lg),
        YbPrimaryButton(
          label: strings.actionSave,
          onPressed: () {
            final title = _titleController.text.trim();
            if (title.length < 2) return;
            final issuer = _issuerController.text.trim();
            Navigator.pop(
              context,
              _CertificateDetails(
                title: title,
                issuer: issuer.isEmpty ? null : issuer,
              ),
            );
          },
        ),
      ],
    );
  }
}

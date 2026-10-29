import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/data/growth/provider_stats_repository.dart' show currentPlatformLabel;
import 'package:yordambor/application/providers/growth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/data/support/support_repository.dart';

class ReportProblemScreen extends ConsumerStatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  ConsumerState<ReportProblemScreen> createState() =>
      _ReportProblemScreenState();
}

class _ReportProblemScreenState extends ConsumerState<ReportProblemScreen> {
  SupportCategory _category = SupportCategory.bug;
  final _descriptionController = TextEditingController();
  // Optional contact field — shown only when user is not signed in
  final _contactController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final strings = ref.read(appStringsProvider);
    final session = ref.read(sessionProvider);
    setState(() => _isSubmitting = true);
    try {
      // Use Supabase only when both configured AND the user is authenticated.
      // If Supabase isn't set up yet, or the user isn't logged in, fall back
      // to opening the device's email client so anyone can report a problem.
      if (Env.isConfigured && session.isAuthenticated) {
        await ref.read(supportRepositoryProvider).submitTicket(
              category: _category,
              description: _descriptionController.text,
            );
      } else {
        await _launchMailto(strings, session.isAuthenticated);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.supportSubmitted)),
        );
        context.pop();
      }
    } on SupportFailure catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _launchMailto(AppStrings strings, bool isAuth) async {
    final contact = _contactController.text.trim();
    final description = _descriptionController.text.trim();

    final subject = Uri.encodeComponent(
      'YordamBor: ${strings.supportCategoryLabel(_category)}',
    );

    // Build body — include contact info for guest reports so we can reply
    final bodyLines = <String>[
      description,
      '',
      '---',
      'Platforma: ${currentPlatformLabel()}',
      if (!isAuth && contact.isNotEmpty) 'Aloqa: $contact',
    ];
    final body = Uri.encodeComponent(bodyLines.join('\n'));

    final uri = Uri.parse(
      'mailto:eeshbaev@outlook.com?subject=$subject&body=$body',
    );
    if (!await launchUrl(uri)) {
      throw SupportFailure(strings.supportMailtoFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final session = ref.watch(sessionProvider);
    final isGuest = !session.isAuthenticated;
    final colors = context.ybColors;

    return Scaffold(
      appBar: AppBar(title: Text(strings.supportReportTitle)),
      body: AppLayout.page(
        context: context,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              strings.supportReportSubtitle,
              style: AppTypography.body.copyWith(
                color: colors.textSecondary,
              ),
            ),

            // ── Guest notice ──────────────────────────────────────────────
            if (isGuest) ...[
              const SizedBox(height: AppSpacing.md),
              _GuestNotice(strings: strings),
            ],

            const SizedBox(height: AppSpacing.lg),

            // ── Category ──────────────────────────────────────────────────
            DropdownMenu<SupportCategory>(
              trailingIcon: const Icon(YbIcons.expandMore),
              selectedTrailingIcon: const Icon(YbIcons.expandLess),
              initialSelection: _category,
              label: Text(strings.supportCategoryLabelField),
              dropdownMenuEntries: SupportCategory.values
                  .map(
                    (c) => DropdownMenuEntry(
                      value: c,
                      label: strings.supportCategoryLabel(c),
                    ),
                  )
                  .toList(),
              onSelected: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Description ───────────────────────────────────────────────
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: strings.supportDescriptionLabel,
                hintText: strings.supportDescriptionHint,
              ),
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
            ),

            // ── Optional contact (guests only) ────────────────────────────
            if (isGuest) ...[
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Email yoki telefon (ixtiyoriy)',
                  hintText: 'Javob olish uchun',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],

            const SizedBox(height: AppSpacing.xl),
            YbPrimaryButton(
              label: strings.supportSubmit,
              isLoading: _isSubmitting,
              onPressed: _isSubmitting ? null : _submit,
            ),

            // Email address shown as selectable text so users who
            // can't open the mail app know where to write directly.
            if (isGuest) ...[
              const SizedBox(height: AppSpacing.md),
              Center(
                child: SelectableText(
                  strings.supportContactHint,
                  style: AppTypography.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Guest notice widget ───────────────────────────────────────────────────────

class _GuestNotice extends StatelessWidget {
  const _GuestNotice({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.primaryMuted,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: colors.teal.withOpacity(.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              size: 18, color: colors.teal),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Siz tizimga kirmagansiz. Xabaringiz email orqali yuboriladi.',
              style: AppTypography.caption.copyWith(
                color: colors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

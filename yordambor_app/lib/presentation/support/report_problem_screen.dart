import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/growth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
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
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final strings = ref.read(appStringsProvider);
    setState(() => _isSubmitting = true);
    try {
      if (Env.isConfigured) {
        await ref.read(supportRepositoryProvider).submitTicket(
              category: _category,
              description: _descriptionController.text,
            );
      } else {
        await _launchMailto(strings);
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

  Future<void> _launchMailto(AppStrings strings) async {
    final subject = Uri.encodeComponent(
      'YordamBor: ${strings.supportCategoryLabel(_category)}',
    );
    final body = Uri.encodeComponent(_descriptionController.text.trim());
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

    if (!session.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: Text(strings.supportReportTitle)),
        body: AppLayout.page(
          context: context,
          child: YbEmptyState(
            icon: Icons.lock_outline_rounded,
            title: strings.supportReportTitle,
            subtitle: strings.supportLoginRequired,
          ),
        ),
      );
    }

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
                color: context.ybColors.textSecondary,
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          DropdownMenu<SupportCategory>(
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
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: strings.supportDescriptionLabel,
              hintText: strings.supportDescriptionHint,
            ),
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: AppSpacing.xl),
          YbPrimaryButton(
            label: strings.supportSubmit,
            isLoading: _isSubmitting,
            onPressed: _isSubmitting ? null : _submit,
          ),
        ],
        ),
      ),
    );
  }
}

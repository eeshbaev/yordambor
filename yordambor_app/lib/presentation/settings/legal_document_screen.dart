import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';

class LegalDocumentScreen extends ConsumerWidget {
  const LegalDocumentScreen({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final isPrivacy = type == 'privacy';
    final isSafety = type == 'safety';
    final body = isPrivacy
        ? strings.legalPrivacyBody
        : isSafety
            ? strings.legalSafetyBody
            : strings.legalTermsBody;
    final paragraphs = body.split('\n\n').where((part) => part.trim().isNotEmpty);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isPrivacy
              ? strings.settingsPrivacy
              : isSafety
                  ? strings.settingsSafety
                  : strings.settingsTerms,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            isPrivacy
                ? strings.legalPrivacyTitle
                : isSafety
                    ? strings.legalSafetyTitle
                    : strings.legalTermsTitle,
            style: AppTypography.title,
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final paragraph in paragraphs) ...[
            Text(
              paragraph,
              style: paragraph.startsWith(RegExp(r'\d+\.'))
                  ? AppTypography.headline
                  : AppTypography.body,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

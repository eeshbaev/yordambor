import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/l10n/app_strings.dart';

const kXizmatServicePromiseMaxLength = 280;

class XizmatPromiseSection extends StatelessWidget {
  const XizmatPromiseSection({
    super.key,
    required this.strings,
    required this.visible,
    required this.onVisibleChanged,
    required this.promiseController,
    required this.onPromiseChanged,
  });

  final AppStrings strings;
  final bool visible;
  final ValueChanged<bool> onVisibleChanged;
  final TextEditingController promiseController;
  final VoidCallback onPromiseChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(strings.xizmatPromiseSectionTitle, style: AppTypography.headline),
        const SizedBox(height: AppSpacing.sm),
        Text(strings.xizmatPromiseSectionSubtitle, style: AppTypography.caption),
        const SizedBox(height: AppSpacing.lg),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(strings.xizmatPromiseShowLabel),
          subtitle: Text(strings.xizmatPromiseShowSubtitle),
          value: visible,
          onChanged: onVisibleChanged,
        ),
        if (visible) ...[
          const SizedBox(height: AppSpacing.md),
          Text(strings.xizmatPromisePresetsLabel, style: AppTypography.caption),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final preset in strings.xizmatPromisePresets)
                ActionChip(
                  label: Text(preset),
                  onPressed: () {
                    promiseController.text = preset;
                    onPromiseChanged();
                  },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            controller: promiseController,
            maxLines: 3,
            maxLength: kXizmatServicePromiseMaxLength,
            decoration: InputDecoration(
              labelText: strings.xizmatPromiseFieldLabel,
              hintText: strings.xizmatPromiseFieldHint,
              alignLabelWithHint: true,
            ),
            onChanged: (_) => onPromiseChanged(),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            strings.xizmatPromiseDisclaimer,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}

String? validateXizmatPromise({
  required bool visible,
  required String promiseText,
  required AppStrings strings,
}) {
  if (!visible) return null;
  final trimmed = promiseText.trim();
  if (trimmed.isEmpty) return strings.xizmatPromiseRequiredError;
  if (trimmed.length > kXizmatServicePromiseMaxLength) {
    return strings.xizmatPromiseTooLongError;
  }
  return null;
}

String? normalizeServicePromise(String? text) {
  final trimmed = text?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}

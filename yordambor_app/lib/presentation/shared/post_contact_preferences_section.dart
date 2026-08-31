import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/l10n/app_strings.dart';

class PostContactPreferencesSection extends StatelessWidget {
  const PostContactPreferencesSection({
    super.key,
    required this.strings,
    required this.phoneController,
    required this.showContactPhone,
    required this.onShowContactPhoneChanged,
    this.phoneValidator,
  });

  final AppStrings strings;
  final TextEditingController phoneController;
  final bool showContactPhone;
  final ValueChanged<bool> onShowContactPhoneChanged;
  final FormFieldValidator<String>? phoneValidator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(strings.postContactSectionTitle, style: AppTypography.headline),
        const SizedBox(height: AppSpacing.sm),
        Text(
          strings.postContactSectionSubtitle,
          style: AppTypography.caption,
        ),
        const SizedBox(height: AppSpacing.lg),
        TextFormField(
          controller: phoneController,
          decoration: InputDecoration(
            labelText: strings.postContactPhoneLabel,
            hintText: strings.postContactPhoneHint,
            helperText: strings.postContactPhoneOptional,
          ),
          keyboardType: TextInputType.phone,
          validator: phoneValidator,
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(strings.postShowPhoneLabel),
          subtitle: Text(strings.postShowPhoneSubtitle),
          value: showContactPhone,
          onChanged: onShowContactPhoneChanged,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/data/auth/auth_repository.dart';

class ForgotPasswordForm extends ConsumerStatefulWidget {
  const ForgotPasswordForm({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  ConsumerState<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends ConsumerState<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  var _isLoading = false;
  var _sent = false;
  var _autovalidate = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _autovalidate = true);
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).resetPassword(email);
      ref.read(pendingPasswordResetEmailProvider.notifier).state = email;
      setState(() => _sent = true);
    } on AuthFailure catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final sentEmail =
        ref.watch(pendingPasswordResetEmailProvider) ?? _emailController.text;

    return Form(
      key: _formKey,
      autovalidateMode: _autovalidate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            strings.forgotPassword,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_sent) ...[
            Icon(
              Icons.mark_email_read_outlined,
              size: 48,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              strings.resetPasswordEmailSent(sentEmail),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              strings.resetPasswordEmailHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
            ),
          ] else
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(labelText: '${strings.email} *'),
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return strings.fieldRequired;
                if (!_emailPattern.hasMatch(trimmed)) {
                  return strings.invalidEmail;
                }
                return null;
              },
            ),
          const SizedBox(height: AppSpacing.lg),
          if (!_sent)
            YbPrimaryButton(
              label: strings.resetPasswordSendLink,
              isLoading: _isLoading,
              onPressed: _isLoading ? null : _submit,
            ),
          TextButton(
            onPressed: widget.onBack,
            child: Text(strings.login),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/data/auth/auth_repository.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({
    super.key,
    required this.onSuccess,
    required this.onError,
  });

  final VoidCallback onSuccess;
  final void Function(AuthFailure error) onError;

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  var _isLoading = false;
  var _acceptedTerms = false;
  var _showTermsError = false;
  var _autovalidate = false;
  var _obscurePassword = true;
  late final TapGestureRecognizer _termsLinkRecognizer;

  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  @override
  void initState() {
    super.initState();
    _termsLinkRecognizer = TapGestureRecognizer()..onTap = _openTerms;
  }

  @override
  void dispose() {
    _termsLinkRecognizer.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _autovalidate = true;
      _showTermsError = !_acceptedTerms;
    });

    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      widget.onError(
        AuthFailure(ref.read(appStringsProvider).acceptTermsRequired),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signUp(
            fullName: _nameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            password: _passwordController.text,
          );
      widget.onSuccess();
    } on AuthFailure catch (e) {
      widget.onError(e);
    } catch (e) {
      widget.onError(AuthFailure(e.toString()));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openTerms() {
    context.push('/legal/terms');
  }

  String _requiredLabel(AppStrings strings, String label) => '$label *';

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final linkStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        );

    return Form(
      key: _formKey,
      autovalidateMode: _autovalidate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: _requiredLabel(strings, strings.fullName),
              ),
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return strings.fieldRequired;
                if (trimmed.length < 2) return strings.fieldRequired;
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: _requiredLabel(strings, strings.email),
              ),
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return strings.fieldRequired;
                if (!_emailPattern.hasMatch(trimmed)) {
                  return strings.invalidEmail;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: _requiredLabel(strings, strings.phone),
                hintText: '+998901234567',
              ),
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return strings.fieldRequired;
                if (trimmed.replaceAll(RegExp(r'\D'), '').length < 9) {
                  return strings.invalidPhone;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: _requiredLabel(strings, strings.password),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return strings.fieldRequired;
                if (value.length < 8) return strings.passwordTooShort;
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: _requiredLabel(strings, strings.confirmPassword),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return strings.fieldRequired;
                if (value != _passwordController.text) {
                  return strings.passwordsDoNotMatch;
                }
                return null;
              },
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _acceptedTerms,
              onChanged: (value) => setState(() {
                _acceptedTerms = value ?? false;
                if (_acceptedTerms) _showTermsError = false;
              }),
              title: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(text: strings.acceptTermsLead),
                    TextSpan(
                      text: strings.acceptTermsLink,
                      style: linkStyle,
                      recognizer: _termsLinkRecognizer,
                    ),
                    TextSpan(text: '${strings.acceptTermsTrail} *'),
                  ],
                ),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            if (_showTermsError)
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.lg, bottom: 8),
                child: Text(
                  strings.acceptTermsRequired,
                  style: AppTypography.caption.copyWith(color: AppColors.error),
                ),
              ),
            const SizedBox(height: AppSpacing.sm),
            YbPrimaryButton(
              label: strings.continueAction,
              isLoading: _isLoading,
              onPressed: _isLoading ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}

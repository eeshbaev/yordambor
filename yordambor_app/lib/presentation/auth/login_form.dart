import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/data/auth/auth_repository.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({
    super.key,
    required this.onSuccess,
    required this.onError,
    required this.onForgotPassword,
  });

  final Future<void> Function() onSuccess;
  final void Function(AuthFailure error) onError;
  final VoidCallback onForgotPassword;

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isLoading = false;
  var _obscurePassword = true;
  var _autovalidate = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _autovalidate = true);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signIn(
            identifier: _identifierController.text,
            password: _passwordController.text,
          );
      await widget.onSuccess();
    } on AuthFailure catch (e) {
      widget.onError(e);
    } catch (_) {
      widget.onError(
        AuthFailure(ref.read(appStringsProvider).stateErrorBody),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);

    return Form(
      key: _formKey,
      autovalidateMode: _autovalidate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _identifierController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: '${strings.email} / ${strings.phone} *',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return strings.fieldRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: '${strings.password} *',
              suffixIcon: IconButton(
                tooltip: _obscurePassword
                    ? strings.a11yShowPassword
                    : strings.a11yHidePassword,
                icon: Icon(
                  _obscurePassword ? YbIcons.visibilityOffFilled : YbIcons.visibilityFilled,
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
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onForgotPassword,
              child: Text(strings.forgotPassword),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          YbPrimaryButton(
            label: strings.continueAction,
            isLoading: _isLoading,
            onPressed: _isLoading ? null : _submit,
          ),
        ],
      ),
    );
  }
}

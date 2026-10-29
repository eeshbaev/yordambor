import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/data/auth/auth_repository.dart';

/// Screen shown after Google or Telegram sign-in when the user's
/// profile is missing a full name or phone number.
///
/// The router guard redirects here automatically; once the user saves,
/// the router takes them to /home.
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  var _loading = false;
  String? _errorBanner;

  @override
  void initState() {
    super.initState();
    // Pre-fill name from what the provider already captured.
    final existing = ref.read(sessionProvider).profile;
    _nameCtrl = TextEditingController(text: existing?.fullName ?? '');
    _phoneCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _errorBanner = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).completeProfile(
            fullName: _nameCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
          );
      // Refresh so the router guard sees the completed profile.
      await ref.read(sessionProvider.notifier).refreshProfile();
      if (!mounted) return;
      // Guard will redirect to /home now that the profile is complete.
      context.go('/home');
    } on AuthFailure catch (e) {
      setState(() => _errorBanner = e.message);
    } catch (e) {
      setState(() => _errorBanner = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final user = Supabase.instance.client.auth.currentUser;
    final colors = context.ybColors;

    // Determine which provider the user signed in with.
    final provider = _detectProvider(user);
    final autoEmail = user?.email ?? '';

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        title: Text(
          'Profilingizni to\'ldiring',
          style: AppTypography.headline.copyWith(color: colors.textPrimary),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Provider badge ────────────────────────────────────
                if (provider != null)
                  _ProviderBadge(provider: provider, email: autoEmail),
                const SizedBox(height: AppSpacing.xl),

                // ── Error banner ──────────────────────────────────────
                if (_errorBanner != null) ...[
                  _ErrorBanner(message: _errorBanner!),
                  const SizedBox(height: AppSpacing.md),
                ],

                // ── Full name ─────────────────────────────────────────
                Text(
                  'To\'liq ism',
                  style: AppTypography.label
                      .copyWith(color: colors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xs),
                TextFormField(
                  controller: _nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Ismingiz va familiyangiz',
                    filled: true,
                    fillColor: colors.surface2,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Ism kiritish shart';
                    }
                    if (v.trim().split(' ').length < 2) {
                      return 'Ism va familiyani kiriting';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Phone ─────────────────────────────────────────────
                Text(
                  'Telefon raqami',
                  style: AppTypography.label
                      .copyWith(color: colors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xs),
                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
                  ],
                  decoration: InputDecoration(
                    hintText: '+998 90 123 45 67',
                    filled: true,
                    fillColor: colors.surface2,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Telefon raqami kiritish shart';
                    }
                    final digits = v.replaceAll(RegExp(r'\D'), '');
                    if (digits.length < 9) {
                      return 'Raqam to\'liq emas';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Bir telefon raqami faqat bitta hisob uchun ishlatilishi mumkin.',
                  style: AppTypography.caption
                      .copyWith(color: colors.textTertiary),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Save button ───────────────────────────────────────
                YbPrimaryButton(
                  label: 'Saqlash',
                  onPressed: _loading ? null : _submit,
                  isLoading: _loading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String? _detectProvider(User? user) {
    if (user == null) return null;
    final identities = user.identities;
    if (identities == null || identities.isEmpty) return null;
    final provider = identities.first.provider;
    if (provider == 'google') return 'Google';
    if (provider == 'email' &&
        (user.email?.contains('@telegram.yordambor.app') ?? false)) {
      return 'Telegram';
    }
    return null;
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ProviderBadge extends StatelessWidget {
  const _ProviderBadge({required this.provider, required this.email});

  final String provider;
  final String email;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final isGoogle = provider == 'Google';
    final badgeColor =
        isGoogle ? const Color(0xFFEAF1FB) : const Color(0xFFE3F2FD);
    final textColor =
        isGoogle ? const Color(0xFF1A73E8) : const Color(0xFF039BE5);
    final icon =
        isGoogle ? Icons.account_circle_outlined : Icons.send_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: textColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$provider orqali kirdiniz',
                  style: AppTypography.label.copyWith(color: textColor),
                ),
                if (email.isNotEmpty &&
                    !email.contains('@telegram.yordambor.app'))
                  Text(
                    email,
                    style: AppTypography.caption
                        .copyWith(color: colors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.ybColors.errorSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: context.ybColors.error, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTypography.body
                  .copyWith(color: context.ybColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

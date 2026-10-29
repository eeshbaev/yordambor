import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/data/auth/auth_repository.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';

/// Google + Telegram sign-in buttons with a divider below.
///
/// Callbacks:
/// - [onSuccess]  : called after a successful sign-in (may show profile setup later via router).
/// - [onError]    : called with a human-readable message on failure.
/// - [onCancel]   : called when the user cancels the social flow (no-op by default).
class SocialAuthButtons extends ConsumerStatefulWidget {
  const SocialAuthButtons({
    super.key,
    required this.onSuccess,
    required this.onError,
    this.onCancel,
    this.dividerLabel,
  });

  final VoidCallback onSuccess;
  final void Function(String message) onError;
  final VoidCallback? onCancel;
  /// Defaults to "or with email" in the app's language.
  final String? dividerLabel;

  @override
  ConsumerState<SocialAuthButtons> createState() => _SocialAuthButtonsState();
}

class _SocialAuthButtonsState extends ConsumerState<SocialAuthButtons> {
  var _googleLoading = false;
  var _telegramLoading = false;

  Future<void> _onGoogleTap() async {
    setState(() => _googleLoading = true);
    try {
      final signed =
          await ref.read(authRepositoryProvider).signInWithGoogle();
      if (!signed) {
        widget.onCancel?.call();
        return;
      }
      widget.onSuccess();
    } on AuthFailure catch (e) {
      widget.onError(e.message);
    } catch (e) {
      widget.onError(e.toString());
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  Future<void> _onTelegramTap() async {
    setState(() => _telegramLoading = true);
    try {
      // Extract the Supabase project reference from the configured URL.
      // URL looks like: https://abcdefghijkl.supabase.co
      final url = Env.supabaseUrl;
      final ref_ = Uri.parse(url).host.split('.').first;
      await ref.read(authRepositoryProvider).signInWithTelegram(ref_);
      // The session arrives via deep link → app_links → Supabase picks it up
      // and fires authStateChanges. We just need to close any loading state.
      // The router redirect will handle profile-incomplete navigation.
      widget.onSuccess();
    } on AuthFailure catch (e) {
      widget.onError(e.message);
    } catch (e) {
      widget.onError(e.toString());
    } finally {
      if (mounted) setState(() => _telegramLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Google ────────────────────────────────────────────────
        _SocialButton(
          isLoading: _googleLoading,
          onPressed: _googleLoading || _telegramLoading ? null : _onGoogleTap,
          icon: const _GoogleLogo(),
          label: strings.socialContinueGoogle,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF212121),
          border: Border.all(color: const Color(0xFFE6E6E6), width: 1.5),
          shadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // ── Telegram ──────────────────────────────────────────────
        _SocialButton(
          isLoading: _telegramLoading,
          onPressed: _googleLoading || _telegramLoading ? null : _onTelegramTap,
          icon: const _TelegramLogo(),
          label: strings.socialContinueTelegram,
          backgroundColor: const Color(0xFF2AABEE),
          foregroundColor: Colors.white,
          shadow: [
            BoxShadow(
              color: const Color(0xFF2AABEE).withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // ── Divider ───────────────────────────────────────────────
        Row(
          children: [
            Expanded(child: Divider(color: context.ybColors.borderSubtle)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.dividerLabel ?? strings.socialOrEmail,
                style: AppTypography.caption.copyWith(
                  color: context.ybColors.textTertiary,
                ),
              ),
            ),
            Expanded(child: Divider(color: context.ybColors.borderSubtle)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal helpers
// ─────────────────────────────────────────────────────────────────────────────

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.isLoading,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.border,
    this.shadow = const [],
  });

  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final BoxBorder? border;
  final List<BoxShadow> shadow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedOpacity(
        opacity: onPressed == null ? 0.55 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: border,
            boxShadow: shadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(foregroundColor),
                  ),
                )
              else ...[
                icon,
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: foregroundColor,
                    fontFamily: 'Onest',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Brand logos (inline SVG via CustomPaint — no external assets needed) ──────

class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    // Blue segment
    final blue = Paint()..color = const Color(0xFF4285F4);
    final green = Paint()..color = const Color(0xFF34A853);
    final yellow = Paint()..color = const Color(0xFFFBBC05);
    final red = Paint()..color = const Color(0xFFEA4335);

    // Simplified Google G approximation using paths
    final path = Path();

    // Right (blue)
    path.moveTo(s * 0.98, s * 0.512);
    path.arcTo(
        Rect.fromCircle(center: Offset(s * 0.5, s * 0.5), radius: s * 0.48),
        -0.36, -1.23, false);
    path.lineTo(s * 0.5, s * 0.5);
    path.close();
    canvas.drawPath(path, blue);

    // Bottom-right (green)
    final path2 = Path();
    path2.moveTo(s * 0.5, s * 0.5);
    path2.arcTo(
        Rect.fromCircle(center: Offset(s * 0.5, s * 0.5), radius: s * 0.48),
        -0.36 - 1.23, -1.25, false);
    path2.close();
    canvas.drawPath(path2, green);

    // Left (yellow)
    final path3 = Path();
    path3.moveTo(s * 0.5, s * 0.5);
    path3.arcTo(
        Rect.fromCircle(center: Offset(s * 0.5, s * 0.5), radius: s * 0.48),
        -0.36 - 1.23 - 1.25, -1.4, false);
    path3.close();
    canvas.drawPath(path3, yellow);

    // Top (red)
    final path4 = Path();
    path4.moveTo(s * 0.5, s * 0.5);
    path4.arcTo(
        Rect.fromCircle(center: Offset(s * 0.5, s * 0.5), radius: s * 0.48),
        -0.36 - 1.23 - 1.25 - 1.4, -1.39, false);
    path4.close();
    canvas.drawPath(path4, red);

    // White centre circle
    canvas.drawCircle(
      Offset(s * 0.5, s * 0.5),
      s * 0.30,
      Paint()..color = Colors.white,
    );

    // White right-side cutout for the G notch (the opening)
    final notch = Paint()..color = Colors.white;
    canvas.drawRect(
        Rect.fromLTWH(s * 0.5, s * 0.36, s * 0.49, s * 0.28), notch);
    // Restore blue fill over the notch's right half at the correct radius
    final capPaint = Paint()..color = const Color(0xFF4285F4);
    canvas.drawRect(
        Rect.fromLTWH(s * 0.68, s * 0.36, s * 0.31, s * 0.28), capPaint);
    // Inner white circle again to clean up
    canvas.drawCircle(
      Offset(s * 0.5, s * 0.5),
      s * 0.30,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _TelegramLogo extends StatelessWidget {
  const _TelegramLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _TelegramLogoPainter()),
    );
  }
}

class _TelegramLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final white = Paint()..color = Colors.white;

    // Paper-plane body
    final body = Path()
      ..moveTo(s * 0.05, s * 0.47)
      ..lineTo(s * 0.95, s * 0.14)
      ..lineTo(s * 0.65, s * 0.86)
      ..lineTo(s * 0.45, s * 0.66)
      ..lineTo(s * 0.75, s * 0.35)
      ..lineTo(s * 0.28, s * 0.60)
      ..close();
    canvas.drawPath(body, white);

    // Tail fold
    final tail = Path()
      ..moveTo(s * 0.45, s * 0.66)
      ..lineTo(s * 0.65, s * 0.86)
      ..lineTo(s * 0.52, s * 0.74)
      ..close();
    canvas.drawPath(tail, white..color = Colors.white.withValues(alpha: 0.7));
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

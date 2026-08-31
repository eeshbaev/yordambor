import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';

class YbScaleTap extends StatefulWidget {
  const YbScaleTap({
    super.key,
    required this.onTap,
    required this.child,
    this.enabled = true,
    this.haptic = false,
    this.hitTestBehavior = HitTestBehavior.opaque,
  });

  final VoidCallback? onTap;
  final Widget child;
  final bool enabled;
  final bool haptic;
  final HitTestBehavior hitTestBehavior;

  @override
  State<YbScaleTap> createState() => _YbScaleTapState();
}

class _YbScaleTapState extends State<YbScaleTap> {
  var _pressed = false;

  void _setPressed(bool value) {
    if (!widget.enabled || widget.onTap == null) return;
    if (_pressed != value) setState(() => _pressed = value);
  }

  void _handleTap() {
    if (!widget.enabled || widget.onTap == null) return;
    if (widget.haptic) AppHaptics.selection();
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final scale = _pressed ? AppMotion.pressScale : 1.0;

    return GestureDetector(
      behavior: widget.hitTestBehavior,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.enabled ? _handleTap : null,
      child: AnimatedScale(
        scale: scale,
        duration: AppMotion.fast,
        curve: AppMotion.standard,
        child: widget.child,
      ),
    );
  }
}

class YbPrimaryButton extends StatelessWidget {
  const YbPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppTouch.buttonHeight,
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          minimumSize: const Size.fromHeight(AppTouch.buttonHeight),
          maximumSize: const Size(double.infinity, AppTouch.buttonHeight),
        ),
        onPressed: isLoading
            ? null
            : onPressed == null
                ? null
                : () {
                    AppHaptics.selection();
                    onPressed!();
                  },
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              )
            : _ButtonLabel(label: label, icon: icon),
      ),
    );
  }
}

class YbSecondaryButton extends StatelessWidget {
  const YbSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppTouch.buttonHeight,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          minimumSize: const Size.fromHeight(AppTouch.buttonHeight),
          maximumSize: const Size(double.infinity, AppTouch.buttonHeight),
        ),
        onPressed: onPressed == null
            ? null
            : () {
                AppHaptics.selection();
                onPressed!();
              },
        child: _ButtonLabel(
          label: label,
          icon: icon,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}

class _ButtonLabel extends StatelessWidget {
  const _ButtonLabel({
    required this.label,
    this.icon,
    this.color = Colors.white,
  });

  final String label;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTypography.button.copyWith(color: color);

    final text = Text(
      label,
      style: labelStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );

    if (icon == null) return text;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: AppSpacing.sm),
        Flexible(child: text),
      ],
    );
  }
}

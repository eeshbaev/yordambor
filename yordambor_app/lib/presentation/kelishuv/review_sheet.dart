import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/app_review_service.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/review_providers.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/data/review/review_repository.dart';
import 'package:yordambor/domain/entities/review.dart';
import 'package:yordambor/domain/growth/app_review_prompt.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';

Future<bool?> showReviewSheet(
  BuildContext context, {
  required String kelishuvId,
  required String xizmatId,
  String? xizmatName,
}) {
  return showModalBottomSheet<bool>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => ReviewSheet(
      kelishuvId: kelishuvId,
      xizmatId: xizmatId,
      xizmatName: xizmatName,
    ),
  );
}

class ReviewSheet extends ConsumerStatefulWidget {
  const ReviewSheet({
    super.key,
    required this.kelishuvId,
    required this.xizmatId,
    this.xizmatName,
  });

  final String kelishuvId;
  final String xizmatId;
  final String? xizmatName;

  @override
  ConsumerState<ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends ConsumerState<ReviewSheet> {
  final _commentController = TextEditingController();
  int _rating = 5;
  bool _isSubmitting = false;
  bool _sent = false;
  String? _errorMessage;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _setRating(int star) {
    AppHaptics.selection();
    setState(() => _rating = star);
  }

  Future<void> _submit() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await ref.read(reviewRepositoryProvider).create(
            CreateReviewInput(
              kelishuvId: widget.kelishuvId,
              xizmatId: widget.xizmatId,
              rating: _rating,
              comment: _commentController.text,
            ),
          );
      ref.invalidate(kelishuvReviewProvider(widget.kelishuvId));
      ref.invalidate(xizmatReviewsProvider(widget.xizmatId));
      ref.invalidate(xizmatRatingSummaryProvider(widget.xizmatId));
      if (mounted) {
        // The button closes into a checkmark (its haptic marks success).
        setState(() {
          _isSubmitting = false;
          _sent = true;
        });
        await Future<void>.delayed(const Duration(milliseconds: 650));
        if (!mounted) return;
        Navigator.of(context).pop(true);
        if (_rating == 5) {
          await maybePromptAppReview(
            context,
            ref,
            trigger: AppReviewTrigger.fiveStarReview,
          );
        }
      }
    } on ReviewFailure catch (error) {
      setState(() {
        _errorMessage = error.message;
        _isSubmitting = false;
      });
    } catch (_) {
      setState(() {
        _errorMessage = ref.read(appStringsProvider).stateErrorBody;
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);

    return YbSheetBody(
      title: strings.reviewsRate,
      subtitle: widget.xizmatName,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final star = index + 1;
            return IconButton(
              tooltip: strings.a11yStarRating(star),
              onPressed: _isSubmitting ? null : () => _setRating(star),
              icon: Icon(
                star <= _rating ? YbIcons.starFilled : YbIcons.star,
                color: context.ybColors.star,
                size: 40,
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _commentController,
          enabled: !_isSubmitting,
          decoration: InputDecoration(
            labelText: strings.reviewCommentLabel,
            hintText: strings.reviewCommentHint,
          ),
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: AppSpacing.md),
          YbInlineMessage(message: _errorMessage!),
        ],
        const SizedBox(height: AppSpacing.xl),
        YbPrimaryButton(
          label: strings.actionSubmit,
          isLoading: _isSubmitting,
          isSuccess: _sent,
          onPressed: _isSubmitting || _sent ? null : _submit,
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () => Navigator.of(context).pop(false),
          child: Text(strings.reviewLater),
        ),
      ],
    );
  }
}

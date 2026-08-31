import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/growth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/data/support/support_repository.dart';

Future<void> showFeedbackSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => const FeedbackSheet(),
  );
}

class FeedbackSheet extends ConsumerStatefulWidget {
  const FeedbackSheet({super.key});

  @override
  ConsumerState<FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends ConsumerState<FeedbackSheet> {
  final _controller = TextEditingController();
  int? _rating;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setRating(int star) {
    AppHaptics.selection();
    setState(() => _rating = star);
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(feedbackRepositoryProvider).submit(
            message: _controller.text,
            rating: _rating,
          );
      if (mounted) {
        AppHaptics.success();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ref.read(appStringsProvider).feedbackThanks)),
        );
      }
    } on FeedbackFailure catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);

    return YbSheetBody(
      title: strings.feedbackTitle,
      subtitle: strings.feedbackSubtitle,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final star = index + 1;
            return IconButton(
              onPressed: _isSubmitting ? null : () => _setRating(star),
              icon: Icon(
                star <= (_rating ?? 0)
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: AppColors.star,
                size: 40,
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _controller,
          enabled: !_isSubmitting,
          decoration: InputDecoration(
            labelText: strings.feedbackMessageLabel,
            hintText: strings.feedbackMessageHint,
          ),
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: AppSpacing.xl),
        YbPrimaryButton(
          label: strings.feedbackSubmit,
          isLoading: _isSubmitting,
          onPressed: _isSubmitting ? null : _submit,
        ),
      ],
    );
  }
}

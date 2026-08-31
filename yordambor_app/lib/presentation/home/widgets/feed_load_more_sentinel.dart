import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';

class FeedLoadMoreSentinel extends StatefulWidget {
  const FeedLoadMoreSentinel({
    super.key,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  @override
  State<FeedLoadMoreSentinel> createState() => _FeedLoadMoreSentinelState();
}

class _FeedLoadMoreSentinelState extends State<FeedLoadMoreSentinel> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isLoadingMore) widget.onLoadMore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Center(
        child: widget.isLoadingMore
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const SizedBox(height: 24),
      ),
    );
  }
}

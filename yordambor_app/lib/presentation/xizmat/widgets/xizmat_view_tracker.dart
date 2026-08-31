import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/analytics_providers.dart';

class XizmatViewTracker extends ConsumerStatefulWidget {
  const XizmatViewTracker({
    super.key,
    required this.xizmatId,
    required this.child,
  });

  final String xizmatId;
  final Widget child;

  @override
  ConsumerState<XizmatViewTracker> createState() => _XizmatViewTrackerState();
}

class _XizmatViewTrackerState extends ConsumerState<XizmatViewTracker> {
  @override
  void initState() {
    super.initState();
    if (widget.xizmatId.startsWith('demo-')) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsRepositoryProvider).recordView(widget.xizmatId);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

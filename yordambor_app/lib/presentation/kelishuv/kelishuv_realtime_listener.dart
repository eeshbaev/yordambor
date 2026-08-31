import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/core/config/env.dart';

class KelishuvRealtimeListener extends ConsumerStatefulWidget {
  const KelishuvRealtimeListener({
    super.key,
    required this.kelishuvId,
    required this.child,
  });

  final String kelishuvId;
  final Widget child;

  @override
  ConsumerState<KelishuvRealtimeListener> createState() =>
      _KelishuvRealtimeListenerState();
}

class _KelishuvRealtimeListenerState
    extends ConsumerState<KelishuvRealtimeListener> {
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    if (Env.isConfigured) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _subscribe());
    }
  }

  void _subscribe() {
    if (!Env.isConfigured) return;

    final client = Supabase.instance.client;
    _channel = client
        .channel('kelishuv-${widget.kelishuvId}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'kelishuv_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'kelishuv_id',
            value: widget.kelishuvId,
          ),
          callback: (_) {
            ref.invalidate(kelishuvMessagesProvider(widget.kelishuvId));
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'kelishuvlar',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: widget.kelishuvId,
          ),
          callback: (_) {
            ref.invalidate(kelishuvDetailProvider(widget.kelishuvId));
            ref.invalidate(incomingKelishuvProvider);
            ref.invalidate(myKelishuvRequestsProvider);
            ref.invalidate(archivedKelishuvProvider);
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    unawaited(_channel?.unsubscribe());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

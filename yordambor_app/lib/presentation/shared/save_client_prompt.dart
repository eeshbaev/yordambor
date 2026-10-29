import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/appointment_providers.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/provider_tools_sync.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';

/// "Save client?" for the provider of an agreed deal: once per deal, and
/// only while the client is not in their client book yet.
Future<void> maybePromptSaveClient(
  BuildContext context,
  WidgetRef ref, {
  required Kelishuv deal,
  required String userId,
}) async {
  if (deal.status != KelishuvStatus.jarayonda || !deal.isProvider(userId)) {
    return;
  }
  final otherPartyId = deal.otherPartyIdFor(userId);
  // Wait for the client book, so a saved client is never asked about.
  try {
    await ref.read(clientRegistryProvider.future);
  } catch (_) {
    return;
  }
  if (ref.read(savedClientAccountsProvider).contains(otherPartyId)) return;
  // The deal screen may sync twice in a row; one question is enough.
  if (!_asking.add(deal.id)) return;
  try {
    if (await ClientSavePrompts.wasAsked(deal.id)) return;
    if (!context.mounted) return;
    await promptSaveClient(
      context,
      ref,
      dealId: deal.id,
      otherPartyId: otherPartyId,
      name: deal.otherPartyNameFor(userId),
    );
  } finally {
    _asking.remove(deal.id);
  }
}

/// Deals being asked about right now.
final _asking = <String>{};

/// Asks whether to add [name] to the client book, and does on yes. The
/// deal counts as asked either way.
Future<void> promptSaveClient(
  BuildContext context,
  WidgetRef ref, {
  required String dealId,
  required String otherPartyId,
  required String name,
}) async {
  final strings = ref.read(appStringsProvider);
  final save = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(strings.saveClientPromptTitle),
      content: Text(strings.saveClientPromptBody(name)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(strings.saveClientSkip),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(strings.saveClientConfirm),
        ),
      ],
    ),
  );
  await ClientSavePrompts.markAsked(dealId);
  if (save != true) return;

  await ref
      .read(providerToolsServiceProvider)
      .saveClientFromDeal(otherPartyId: otherPartyId, name: name);
  invalidateProviderTools(ref);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(strings.saveClientDone)),
    );
  }
}

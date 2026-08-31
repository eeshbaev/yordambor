import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/domain/entities/client_registry_entry.dart';

class ClientRegistryListTile extends StatelessWidget {
  const ClientRegistryListTile({
    super.key,
    required this.client,
    required this.onTap,
  });

  final ClientRegistryEntry client;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      title: Text(
        client.clientName,
        style: AppTypography.headline.copyWith(color: colors.textPrimary),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (client.phone != null && client.phone!.isNotEmpty)
            Text(
              client.phone!,
              style: AppTypography.caption.copyWith(color: colors.textSecondary),
            ),
          if (client.note != null && client.note!.isNotEmpty)
            Text(
              client.note!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body.copyWith(color: colors.textPrimary),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}

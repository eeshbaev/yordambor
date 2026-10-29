import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/margin_providers.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/margin_unit.dart';

Future<void> showMarginUnitSheet({
  required BuildContext context,
  required WidgetRef ref,
  required AppStrings strings,
  MarginUnit? unit,
}) async {
  final isEditing = unit != null;
  final nameController = TextEditingController(text: unit?.name ?? '');
  final costController = TextEditingController(
    text: unit != null ? unit.unitCostUzs.toStringAsFixed(0) : '',
  );
  final basisController = TextEditingController(text: unit?.basisLabel ?? '');

  final saved = await showModalBottomSheet<bool>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) {
      return YbSheetBody(
        title: isEditing ? strings.marginEditUnit : strings.marginAddUnit,
        children: [
          TextField(
            controller: nameController,
            autofocus: !isEditing,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: strings.marginUnitName),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: costController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: strings.marginUnitCost),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: basisController,
            decoration: InputDecoration(
              labelText: strings.marginUnitBasis,
              hintText: strings.marginUnitBasisHint,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          YbPrimaryButton(
            label: strings.actionSave,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      );
    },
  );

  if (saved != true) return;

  final name = nameController.text.trim();
  if (name.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.marginNameRequired)),
      );
    }
    return;
  }

  final cost = double.tryParse(costController.text.trim());
  if (cost == null || cost < 0) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.marginCostRequired)),
      );
    }
    return;
  }

  final basis = basisController.text.trim();
  final repo = ref.read(marginUnitsRepositoryProvider);
  if (isEditing) {
    await repo.update(
      unit.copyWith(
        name: name,
        unitCostUzs: cost,
        basisLabel: basis.isEmpty ? null : basis,
      ),
    );
  } else {
    await repo.create(
      name: name,
      unitCostUzs: cost,
      basisLabel: basis.isEmpty ? null : basis,
    );
  }
  ref.invalidate(marginUnitsProvider);
}

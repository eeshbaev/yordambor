import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:yordambor/application/providers/margin_providers.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/margin_product.dart';
import 'package:yordambor/core/utils/money_format.dart';

Future<String?> showMarginProductSheet({
  required BuildContext context,
  required WidgetRef ref,
  required AppStrings strings,
  MarginProduct? product,
}) async {
  final isEditing = product != null;
  final nameController = TextEditingController(text: product?.name ?? '');
  final priceController = TextEditingController(
    text: product != null ? product.salePriceUzs.toStringAsFixed(0) : '',
  );

  final saved = await showModalBottomSheet<bool>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) {
      return YbSheetBody(
        title: isEditing ? strings.marginEditProduct : strings.marginAddProduct,
        children: [
          TextField(
            controller: nameController,
            autofocus: !isEditing,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: strings.marginProductName),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: strings.marginSalePrice),
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

  if (saved != true) return null;

  final name = nameController.text.trim();
  if (name.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.marginNameRequired)),
      );
    }
    return null;
  }

  final price = double.tryParse(priceController.text.trim());
  if (price == null || price <= 0) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.marginPriceRequired)),
      );
    }
    return null;
  }

  final repo = ref.read(marginProductsRepositoryProvider);
  if (isEditing) {
    await repo.save(product.copyWith(name: name, salePriceUzs: price));
    ref.invalidate(marginProductsProvider);
    ref.invalidate(marginProductProvider(product.id));
    return product.id;
  }

  final created = await repo.create(name: name, salePriceUzs: price);
  ref.invalidate(marginProductsProvider);
  return created.id;
}

Future<void> showMarginLineSheet({
  required BuildContext context,
  required WidgetRef ref,
  required AppStrings strings,
  required MarginProduct product,
  MarginProductLine? line,
}) async {
  final isEditing = line != null;
  final units = await ref.read(marginUnitsProvider.future);
  if (!context.mounted) return;

  String? selectedUnitId = line?.unitId;
  final nameController = TextEditingController(text: line?.name ?? '');
  final qtyController = TextEditingController(
    text: line != null
        ? (line.quantity == line.quantity.roundToDouble()
            ? line.quantity.toStringAsFixed(0)
            : line.quantity.toString())
        : '',
  );
  final costController = TextEditingController(
    text: line != null ? line.unitCostUzs.toStringAsFixed(0) : '',
  );
  final qtyLabelController = TextEditingController(
    text: line?.quantityLabel ?? '',
  );

  final saved = await showModalBottomSheet<bool>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return YbSheetBody(
            title: isEditing ? strings.marginEditLine : strings.marginAddLine,
            children: [
              if (units.isNotEmpty) ...[
                DropdownButtonFormField<String?>(
                  icon: const Icon(YbIcons.expandMore),
                  value: selectedUnitId,
                  decoration: InputDecoration(
                    labelText: strings.marginSelectUnit,
                  ),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(strings.marginCustomLine),
                    ),
                    for (final unit in units)
                      DropdownMenuItem(
                        value: unit.id,
                        child: Text(
                          '${unit.name} — ${formatMoney(unit.unitCostUzs, 'UZS', languageCode: strings.languageCode)}',
                        ),
                      ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedUnitId = value;
                      if (value != null) {
                        final unit = units.firstWhere((u) => u.id == value);
                        nameController.text = unit.name;
                        costController.text =
                            unit.unitCostUzs.toStringAsFixed(0);
                      }
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: strings.marginLineName),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: qtyController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration:
                    InputDecoration(labelText: strings.marginLineQuantity),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: costController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration:
                    InputDecoration(labelText: strings.marginLineUnitCost),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: qtyLabelController,
                decoration: InputDecoration(
                  labelText: strings.marginLineQuantityLabel,
                  hintText: strings.marginLineQuantityLabelHint,
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

  final qty = double.tryParse(qtyController.text.trim());
  if (qty == null || qty <= 0) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.marginQuantityRequired)),
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

  final qtyLabel = qtyLabelController.text.trim();
  final newLine = MarginProductLine(
    id: line?.id ?? const Uuid().v4(),
    name: name,
    quantity: qty,
    unitCostUzs: cost,
    unitId: selectedUnitId,
    quantityLabel: qtyLabel.isEmpty ? null : qtyLabel,
  );

  final lines = List<MarginProductLine>.from(product.lines);
  if (isEditing) {
    final index = lines.indexWhere((l) => l.id == line.id);
    if (index >= 0) lines[index] = newLine;
  } else {
    lines.add(newLine);
  }

  await ref.read(marginProductsRepositoryProvider).save(
        product.copyWith(lines: lines),
      );
  ref.invalidate(marginProductsProvider);
  ref.invalidate(marginProductProvider(product.id));
}

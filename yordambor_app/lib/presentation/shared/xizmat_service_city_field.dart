import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/constants/service_cities.dart';
import 'package:yordambor/core/design_system/widgets/yb_picker_sheet.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';

String? normalizeServiceCity(String? text) {
  return ServiceCities.normalizeStored(text);
}

String? validateServiceCity(String? cityId, AppStrings strings) {
  if (!ServiceCities.isValidId(cityId)) {
    return strings.xizmatServiceCityRequired;
  }
  return null;
}

/// The city list. A service asks where it is given ([title] and [subtitle]
/// default to that); a request asks where help is needed.
Future<void> showServiceCityPicker({
  required BuildContext context,
  required AppStrings strings,
  required String? selectedId,
  required ValueChanged<String> onSelected,
  String? title,
  String? subtitle,
}) {
  return showYbPickerSheet<void>(
    context: context,
    child: YbCompactPickerSheet(
      title: title ?? strings.xizmatServiceCityLabel,
      subtitle: subtitle ?? strings.xizmatServiceCityHint,
      headerIcon: YbIcons.locationOn,
      selectedId: selectedId ?? '',
      options: [
        for (final id in ServiceCityIds.all)
          YbPickerOption(
            id: id,
            label: strings.serviceCityLabel(id),
            icon: YbIcons.place,
          ),
      ],
      onSelected: (option) {
        onSelected(option.id);
        Navigator.pop(context);
      },
    ),
  );
}

class XizmatServiceCityField extends ConsumerWidget {
  const XizmatServiceCityField({
    super.key,
    required this.selectedCityId,
    required this.onChanged,
    this.errorText,
  });

  final String? selectedCityId;
  final ValueChanged<String> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final value = ServiceCities.isValidId(selectedCityId)
        ? strings.serviceCityLabel(selectedCityId!)
        : strings.actionPick;

    return InkWell(
      onTap: () => showServiceCityPicker(
        context: context,
        strings: strings,
        selectedId: selectedCityId,
        onSelected: onChanged,
      ),
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: strings.xizmatServiceCityLabel,
          errorText: errorText,
          suffixIcon: const Icon(YbIcons.expandMoreFilled),
        ),
        child: Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

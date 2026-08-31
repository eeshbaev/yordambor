import 'package:flutter/material.dart';
import 'package:yordambor/core/l10n/app_strings.dart';

String? normalizeServiceCity(String? text) {
  final normalized = text?.trim();
  if (normalized == null || normalized.isEmpty) return null;
  return normalized;
}

class XizmatServiceCityField extends StatelessWidget {
  const XizmatServiceCityField({
    super.key,
    required this.strings,
    required this.controller,
  });

  final AppStrings strings;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: strings.xizmatServiceCityLabel,
        hintText: strings.xizmatServiceCityHint,
      ),
    );
  }
}

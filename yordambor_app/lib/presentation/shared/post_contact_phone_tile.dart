import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yordambor/core/l10n/app_strings.dart';

class PostContactPhoneTile extends StatelessWidget {
  const PostContactPhoneTile({
    super.key,
    required this.phone,
    required this.strings,
  });

  final String phone;
  final AppStrings strings;

  Future<void> _callPhone() async {
    final uri = Uri(scheme: 'tel', path: phone.replaceAll(' ', ''));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.phone_outlined),
        title: Text(phone),
        trailing: IconButton(
          icon: const Icon(Icons.call_outlined),
          tooltip: strings.userProfileCall,
          onPressed: _callPhone,
        ),
      ),
    );
  }
}

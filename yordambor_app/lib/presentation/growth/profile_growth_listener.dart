import 'package:flutter/widgets.dart';

/// Milestones used to open a sheet the moment they unlocked. They now show
/// as a card on home instead (manual H-05: never a pop-up), so this wrapper
/// only passes its child through.
class ProfileGrowthListener extends StatelessWidget {
  const ProfileGrowthListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

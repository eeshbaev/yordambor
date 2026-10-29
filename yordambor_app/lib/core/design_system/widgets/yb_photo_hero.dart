import 'package:flutter/widgets.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';

/// The tag a service photo flies under from a card to its listing.
String xizmatPhotoHeroTag(String xizmatId) => 'xizmat-photo-$xizmatId';

/// A service photo that grows from its card into the listing header and
/// shrinks back (manual M-02). The card's rounded top corners flatten as it
/// lands. With reduced motion the photo simply stays in place.
class YbPhotoHero extends StatelessWidget {
  const YbPhotoHero({super.key, required this.tag, required this.child});

  final Object tag;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (AppMotion.reduced(context)) return child;
    return Hero(tag: tag, flightShuttleBuilder: _shuttle, child: child);
  }

  static Widget _shuttle(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final destination = (toHeroContext.widget as Hero).child;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => ClipRRect(
        // 0 on the card side, 1 on the listing side.
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.card * (1 - animation.value)),
        ),
        child: child,
      ),
      child: destination,
    );
  }
}

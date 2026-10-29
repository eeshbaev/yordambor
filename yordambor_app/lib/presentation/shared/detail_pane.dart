import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// What a list can open: a service or a request for help.
enum DetailKind { xizmat, post }

/// One thing to show in the detail pane. Records compare by value, so the
/// same card tapped twice keeps its page.
typedef DetailTarget = ({DetailKind kind, String id});

/// The open item of a list–detail layout. Null shows the "pick a card"
/// page.
class DetailPaneController extends ValueNotifier<DetailTarget?> {
  DetailPaneController() : super(null);

  void show(DetailTarget target) => value = target;
}

/// Present above a list that has a detail pane beside it (wide windows):
/// cards open there instead of pushing a page.
class DetailPane extends InheritedNotifier<DetailPaneController> {
  const DetailPane({
    super.key,
    required DetailPaneController controller,
    required super.child,
  }) : super(notifier: controller);

  /// The pane, without listening to it (for taps).
  static DetailPaneController? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<DetailPane>()?.notifier;

  /// The open item, rebuilding [context] when it changes (for the selected
  /// card's outline).
  static DetailTarget? selectedOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DetailPane>()?.notifier?.value;
}

/// Opens a service: in the detail pane when there is one, else as a page.
void openXizmat(BuildContext context, String id) {
  final pane = DetailPane.maybeOf(context);
  if (pane != null) {
    pane.show((kind: DetailKind.xizmat, id: id));
    return;
  }
  context.push('/xizmat/$id');
}

/// Opens a request for help: in the detail pane when there is one, else as
/// a page.
void openPost(BuildContext context, String id) {
  final pane = DetailPane.maybeOf(context);
  if (pane != null) {
    pane.show((kind: DetailKind.post, id: id));
    return;
  }
  context.push('/post/$id');
}

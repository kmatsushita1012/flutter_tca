import 'package:flutter_tca/flutter_tca.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Feature<S, A extends Action, W extends StateWrapper<S>> {
  Feature(Ref ref) : _ref = ref;

  final Ref _ref;

  Ref get ref => _ref;

  List<Reducer<S, A, W>> get body;

  void run(
    WidgetRef ref,
    W wrapper,
    A action,
    Future<void> Function(Effect<A>) effectHandler,
  ) {
    for (Reducer<S, A, W> elem in body) {
      elem.run(ref, wrapper, action, effectHandler);
    }
  }
}

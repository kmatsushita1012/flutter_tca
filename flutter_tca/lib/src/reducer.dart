import 'package:flutter_tca/flutter_tca.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Reducer<S, A extends Action, W extends StateWrapper<S>> {
  void run(
    WidgetRef ref,
    W wrapper,
    A action,
    void Function(Effect<A>) effectHandler,
  );
}

class Reduce<S, A extends Action, W extends StateWrapper<S>>
    extends Reducer<S, A, W> {
  Reduce(Effect<A> Function(WidgetRef, W, A) body) : _body = body;

  final Effect<A> Function(WidgetRef, W, A) _body;

  @override
  void run(
    WidgetRef ref,
    W wrapper,
    A action,
    void Function(Effect<A>) effectHandler,
  ) {
    final result = _body(ref, wrapper, action);
    effectHandler(result);
    return;
  }
}

class Scope<
  S,
  A extends Action,
  W extends StateWrapper<S>,
  CS,
  CA extends Action,
  CW extends StateWrapper<CS>
>
    extends Reducer<S, A, W> {
  late final StateProvider<Feature<CS, CA, CW>> _featureProvider;
  late final CW Function(S) _statePath;
  late final A Function(CA) _actionPath;

  StateProvider<Feature<CS, CA, CW>> get featureProvider => _featureProvider;
  CW Function(S) get statePath => _statePath;

  Scope(
    Feature<CS, CA, CW> Function(Ref) featureClosure,
    CW Function(S) statePath,
    A Function(CA) actionClosure,
  ) {
    _featureProvider = StateProvider((ref) => featureClosure(ref));
    _statePath = statePath;
    _actionPath = actionClosure;
  }
  @override
  void run(
    WidgetRef ref,
    W wrapper,
    A action,
    void Function(Effect<A>) effectHandler,
  ) {
    if (action.value is! CA) {
      return;
    }
    final tmpAction = _actionPath(action.value);
    if (action != tmpAction) {
      return;
    }
    final state = wrapper.state(ref);
    final childWrapper = _statePath(state);
    final childFeature = ref.watch(_featureProvider);
    for (Reducer<CS, CA, CW> reducer in childFeature.body) {
      reducer.run(
        ref,
        childWrapper,
        action.value,
        _effectHandlerConverter(effectHandler),
      );
    }
  }

  void Function(Effect<CA>) _effectHandlerConverter(
    void Function(Effect<A>) handler,
  ) {
    return (Effect<CA> childEffect) =>
        handler(childEffect.convert(_actionPath));
  }
}

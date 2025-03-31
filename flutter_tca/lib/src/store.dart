import 'package:flutter_tca/flutter_tca.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TcaStore<S, A extends Action, W extends StateWrapper<S>> {
  TcaStore(W wrapper, StateProvider<Feature<S, A, W>?> featureProvider) {
    _wrapper = wrapper;
    _featureProvider = featureProvider;
  }
  late final StateProvider<Feature<S, A, W>?> _featureProvider;
  late final W _wrapper;

  factory TcaStore.init(
      W wrapper, Feature<S, A, W> Function(Ref) featureClosure) {
    final featureProvider = StateProvider<Feature<S, A, W>?>(
      (ref) => featureClosure(ref),
    );
    return TcaStore(wrapper, featureProvider);
  }

  S state(WidgetRef ref) {
    final state = _wrapper.state(ref);
    return state;
  }

  Future<void> send(WidgetRef ref, A action) {
    final feature = ref.watch(_featureProvider);
    if (feature == null) {
      return Future.error("No Feature");
    }
    feature.run(ref, _wrapper, action, _effectHandler);
    return Future.value();
  }

  Future<void> _effectHandler(Effect<A> effect) async {
    return;
  }

  V select<V>(WidgetRef ref, V Function(S) selector) {
    return _wrapper.select(ref, selector);
  }

  void listen(
    WidgetRef ref,
    void Function(S?, S) listener, {
    void Function(Object, StackTrace)? onError,
  }) {
    return _wrapper.listen(ref, listener, onError: onError);
  }

  TcaStore<CS, CA, CW>
      scope<CS, CA extends Action, CW extends StateWrapper<CS>>(
    WidgetRef ref,
    CW Function(S) stateClosure,
  ) {
    final childFeature = identifyFeature<CS, CA, CW>(ref, stateClosure);
    final childWrapper = stateClosure(_wrapper.state(ref));
    final childStore = TcaStore(childWrapper, childFeature);
    return childStore;
  }

  StateProvider<Feature<CS, CA, CW>?>
      identifyFeature<CS, CA extends Action, CW extends StateWrapper<CS>>(
          WidgetRef ref, CW Function(S) stateClosure) {
    return identifyFeatureFromScope(ref, stateClosure);
  }

  StateProvider<Feature<CS, CA, CW>?> identifyFeatureFromScope<
      CS,
      CA extends Action,
      CW extends StateWrapper<CS>>(WidgetRef ref, CW Function(S) stateClosure) {
    final feature = ref.watch(_featureProvider);
    if (feature == null) {
      return StateProvider((ref) => null);
    }
    final scopes = feature.body.whereType<Scope<S, A, W, CS, CA, CW>>();
    final targets = scopes.where((scope) => scope.statePath == stateClosure);
    if (targets.isEmpty) {
      return StateProvider((ref) => null);
    }
    return targets.first.featureProvider;
  }
}

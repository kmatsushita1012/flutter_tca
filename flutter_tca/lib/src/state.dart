import 'package:flutter_riverpod/flutter_riverpod.dart';

//State must be wrapperd of Wrapper
class StateWrapper<S> {
  StateWrapper(S state) {
    _stateProvider = StateProvider((ref) => state);
  }
  late final StateProvider<S> _stateProvider;

  S state(WidgetRef ref) {
    return ref.watch(_stateProvider);
  }

  S setState(WidgetRef ref, S newState) {
    return ref.read(_stateProvider.notifier).update((state) => newState);
  }

  S update(WidgetRef ref, S Function(S) closure) {
    return ref.read(_stateProvider.notifier).update(closure);
  }

  V select<V>(WidgetRef ref, V Function(S) selector) {
    return ref.watch(_stateProvider.select(selector));
  }

  void listen(
    WidgetRef ref,
    void Function(S?, S) listener, {
    void Function(Object, StackTrace)? onError,
  }) {
    return ref.listen(_stateProvider, listener, onError: onError);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StateWrapper<S> && other._stateProvider == _stateProvider;
  }

  @override
  int get hashCode => _stateProvider.hashCode;
}

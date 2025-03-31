import 'package:flutter_tca/flutter_tca.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class Effect<A extends Action> {
  Effect(
    List<Future<void> Function(Future<void> Function(WidgetRef, A))> operations,
  ) {
    _operations = operations;
  }

  late final List<Future<void> Function(Future<void> Function(WidgetRef, A))>
  _operations;

  Future<void> execute(Future<void> Function(WidgetRef, A) send) async {
    for (var task in this._operations) {
      await task(send);
    }
  }

  Effect<PA> convert<PA extends Action>(PA Function(A) closure) {
    final convertedOperations =
        _operations.map((operation) {
          return (Future<void> Function(WidgetRef, PA) send) async {
            return operation((WidgetRef ref, A childAction) async {
              PA action = closure(childAction);
              send(ref, action);
            });
          };
        }).toList();
    return Effect(convertedOperations);
  }

  factory Effect.none() => None();
  factory Effect.run(
    Future<void> Function(Future<void> Function(WidgetRef, A)) operation,
  ) => Run(operation);
  factory Effect.send(WidgetRef ref, A action) => Send(ref, action);
  factory Effect.task(Future<(WidgetRef, A)> Function() operation) =>
      Task(operation);
  factory Effect.fireAndForget(Future<void> Function() operation) =>
      FireAndForget(operation);
  factory Effect.merge(List<Effect<A>> effects) => Merge(effects);
}

class None<A extends Action> extends Effect<A> {
  None() : super([]);
}

class Run<A extends Action> extends Effect<A> {
  Run(Future<void> Function(Future<void> Function(WidgetRef, A)) operation)
    : super([operation]);
}

class Send<A extends Action> extends Effect<A> {
  Send(WidgetRef ref, A action)
    : super([
        (send) async {
          send(ref, action);
        },
      ]);
}

class Task<A extends Action> extends Effect<A> {
  Task(Future<(WidgetRef, A)> Function() operation)
    : super([
        (send) async {
          final result = await operation();
          await send(result.$1, result.$2);
        },
      ]);
}

class Merge<A extends Action> extends Effect<A> {
  Merge(List<Effect<A>> effects)
    : super(
        effects
            .map((effect) => effect._operations)
            .expand((list) => list)
            .toList(),
      );
}

class FireAndForget<A extends Action> extends Effect<A> {
  FireAndForget(Future<void> Function() operation)
    : super([(send) => operation()]);
}

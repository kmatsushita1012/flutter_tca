abstract class Action<T> {
  T get value =>
      throw UnimplementedError(
        "The 'value' getter is not implemented for this TcaAction.",
      );
}

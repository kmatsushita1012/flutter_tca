import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';

class StateGenerationConfig {
  StateGenerationConfig({required this.className, required this.factories});
  final String className;
  final List<StateFactoryConfig> factories;

  StateFactoryConfig get factory => factories.first;
}

class StateFactoryConfig {
  StateFactoryConfig({required this.name, required this.args});

  final String name;
  final List<StateFactoryArgConfig> args;
}

class StateFactoryArgConfig {
  StateFactoryArgConfig({
    required this.name,
    required this.dartType,
    required this.isChildState,
  });

  final String name;
  final DartType dartType;
  final bool isChildState;

  bool get isNullable => dartType.isNullableType;
  String get typeName => _typeToCode(dartType);
}

extension on DartType {
  bool get isNullableType =>
      this is DynamicType || nullabilitySuffix == NullabilitySuffix.question;
}

String _typeToCode(DartType type, {bool forceNullable = false}) {
  if (type is DynamicType) {
    return 'dynamic';
  } else if (type is InterfaceType) {
    return [
      type.element.name,
      if (type.typeArguments.isNotEmpty)
        '<${type.typeArguments.map(_typeToCode).join(', ')}>',
      if (type.isNullableType || forceNullable) '?' else '',
    ].join();
  }

  if (type is TypeParameterType) {
    return type.getDisplayString(withNullability: false);
  }
  throw UnimplementedError('(${type.runtimeType}) $type');
}

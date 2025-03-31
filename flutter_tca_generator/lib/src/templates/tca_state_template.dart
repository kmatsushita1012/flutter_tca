import 'package:flutter_tca_generator/src/configs/code_config/state_config.dart';
import 'package:flutter_tca_generator/src/utils/utils.dart';

/// A template for a class to read documents from Firestore.
class TcaStateTemplate {
  const TcaStateTemplate(this.config);

  /// The configuration for the document.
  final StateGenerationConfig config;

  @override
  String toString() {
    return '''
T _\$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError('It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.Please check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

${StateMixInTemplate(config).toString()}

${StateCopyWithTemplate(config).toString()}

${StateCopyWithImplTemplate(config).toString()}

${StateImplCopyWithTemplate(config).toString()}

${StateImplCopyWithImplTemplate(config).toString()}

${StateImplTemplate(config).toString()}

${StateTemplate(config).toString()}

${StateWrapperTemplate(config).toString()}
''';
  }
}

class StateMixInTemplate {
  const StateMixInTemplate(this.config);

  /// The configuration for the document.
  final StateGenerationConfig config;

  @override
  String toString() {
    final fieldsBuffer = StringBuffer();
    try {
      final defaultFactory =
          config.factories.where((item) => item.name == "").first;

      for (final argConfig in defaultFactory.args) {
        final fieldTemplate = StateMixInFieldTemplate(argConfig);
        fieldsBuffer.writeln(fieldTemplate);
      }
    } catch (_) {}

    return '''
mixin _\$${config.className} {
  ${fieldsBuffer.toString()}
  \$${config.className}CopyWith<${config.className}> get copyWith => throw _privateConstructorUsedError;
}
''';
  }
}

class StateMixInFieldTemplate {
  const StateMixInFieldTemplate(this.config);

  /// The configuration for the document.
  final StateFactoryArgConfig config;

  @override
  String toString() {
    final typeName =
        config.isChildState ? "${config.typeName}Wrapper" : config.typeName;
    final name = config.isChildState ? "${config.name}Wrapper" : config.name;
    return "$typeName get $name => throw _privateConstructorUsedError;";
  }
}

class StateCopyWithTemplate {
  final StateGenerationConfig config;

  StateCopyWithTemplate(this.config);

  @override
  String toString() {
    final argsBuffer = StringBuffer();
    for (final argConfig in config.factory.args) {
      final arg = CopyWithArgTemplate(argConfig);
      argsBuffer.writeln(arg.toString());
    }
    return '''
abstract class \$${config.className}CopyWith<\$Res> {
  factory \$${config.className}CopyWith(
         ${config.className} value, \$Res Function(${config.className}) then) =
      _\$${config.className}CopyWithImpl<\$Res, ${config.className}>;
  \$Res call({
  ${argsBuffer.toString()}
  });
}
''';
  }
}

class CopyWithArgTemplate {
  const CopyWithArgTemplate(this.config);

  /// The configuration for the document.
  final StateFactoryArgConfig config;

  @override
  String toString() {
    final typeName =
        config.isChildState ? "${config.typeName}Wrapper" : config.typeName;
    final name = config.isChildState ? "${config.name}Wrapper" : config.name;
    return "$typeName $name,";
  }
}

class StateCopyWithImplTemplate {
  final StateGenerationConfig config;

  StateCopyWithImplTemplate(this.config);

  @override
  String toString() {
    final callArgsBuffer = StringBuffer();
    final stateImplArgsBuffer = StringBuffer();
    for (final argConfig in config.factory.args) {
      final callArg = StateCopyWithImplCallArgTemplate(argConfig);
      final stateImplArg = StateCopyWithImplReturnArgTemplate(argConfig);
      callArgsBuffer.writeln(callArg.toString());
      stateImplArgsBuffer.writeln(stateImplArg.toString());
    }
    return '''
class _\$${config.className}CopyWithImpl<\$Res, \$Val extends ${config.className}>
    implements \$${config.className}CopyWith<\$Res> {
  _\$${config.className}CopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final \$Val _value;
  // ignore: unused_field
  final \$Res Function(\$Val) _then;

  @pragma('vm:prefer-inline')
  @override
  \$Res call({
    ${callArgsBuffer.toString()}
  }) {
    return _then(_value.copyWith(
      ${stateImplArgsBuffer.toString()}
    ) as \$Val);
  }
}
''';
  }
}

class StateCopyWithImplCallArgTemplate {
  const StateCopyWithImplCallArgTemplate(this.config);

  /// The configuration for the document.
  final StateFactoryArgConfig config;

  @override
  String toString() {
    final defaultValue = config.isNullable ? "null" : "copyWithNull";
    final name = config.isChildState ? "${config.name}Wrapper" : config.name;
    return "Object? $name = $defaultValue,";
  }
}

class StateCopyWithImplReturnArgTemplate {
  const StateCopyWithImplReturnArgTemplate(this.config);

  /// The configuration for the document.
  final StateFactoryArgConfig config;

  @override
  String toString() {
    final defaultValue = config.isNullable ? "null" : "copyWithNull";
    final typeName =
        config.isChildState ? "${config.typeName}Wrapper" : config.typeName;
    final name = config.isChildState ? "${config.name}Wrapper" : config.name;
    return '''
$name: $defaultValue == $name
  ? _value.$name
  : $name // ignore: cast_nullable_to_non_nullable
      as $typeName,
''';
  }
}

class StateImplCopyWithTemplate {
  final StateGenerationConfig config;

  StateImplCopyWithTemplate(this.config);

  @override
  String toString() {
    final argsBuffer = StringBuffer();
    for (final argConfig in config.factory.args) {
      final arg = CopyWithArgTemplate(argConfig);
      argsBuffer.writeln(arg.toString());
    }
    return '''
abstract class _\$\$${config.className}ImplCopyWith<\$Res> implements \$${config.className}CopyWith<\$Res>  {
  factory _\$\$${config.className}ImplCopyWith(
          _\$${config.className}Impl value, \$Res Function(_\$${config.className}Impl) then) =
      __\$\$${config.className}ImplCopyWithImpl<\$Res>;
  \$Res call({
  ${argsBuffer.toString()}});
}
''';
  }
}

class StateImplCopyWithImplTemplate {
  final StateGenerationConfig config;

  StateImplCopyWithImplTemplate(this.config);

  @override
  String toString() {
    final callArgsBuffer = StringBuffer();
    final stateImplArgsBuffer = StringBuffer();
    for (final argConfig in config.factory.args) {
      final callArg = StateCopyWithImplCallArgTemplate(argConfig);
      callArgsBuffer.writeln(callArg.toString());
      final stateImplArg = StateCopyWithImplReturnArgTemplate(argConfig);
      stateImplArgsBuffer.writeln(stateImplArg.toString());
    }
    return '''
class __\$\$${config.className}ImplCopyWithImpl<\$Res>
    extends _\$${config.className}CopyWithImpl<\$Res, _\$${config.className}Impl>
      implements _\$\$${config.className}ImplCopyWith<\$Res> {
  __\$\$${config.className}ImplCopyWithImpl(_\$${config.className}Impl _value,
      \$Res Function(_\$${config.className}Impl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  \$Res call({
    ${callArgsBuffer.toString()}
  }) {
    return _then(_\$${config.className}Impl(
      ${stateImplArgsBuffer.toString()}
    ));
  }
}
''';
  }
}

class StateImplTemplate {
  final StateGenerationConfig config;

  StateImplTemplate(this.config);

  @override
  String toString() {
    final constructorArgsBuffer = StringBuffer();
    final fieldsBuffer = StringBuffer();
    final toStringBuffer = StringBuffer();
    final equalBuffer = StringBuffer();
    for (final argConfig in config.factory.args) {
      final constructorArg = StateImplArgTemplate(argConfig);
      constructorArgsBuffer.writeln(constructorArg);
      final field = StateImplFieldTemplate(argConfig);
      fieldsBuffer.writeln(field);
      final toString = StateImplToStringTemplate(argConfig);
      toStringBuffer.write(toString);
      final equal = StateImplEqualTemplate(argConfig);
      equalBuffer.writeln(equal);
    }
    return '''
class _\$${config.className}Impl implements _${config.className} {
  const _\$${config.className}Impl({
    ${constructorArgsBuffer.toString()}
  });

  ${fieldsBuffer.toString()}
  @override
  String toString() {
    return '${config.className}(${toStringBuffer.toString()})';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _\$${config.className}Impl
            ${equalBuffer.toString()});
  }

  @override
  @pragma('vm:prefer-inline')
  _\$\$${config.className}ImplCopyWith<_\$${config.className}Impl> get copyWith =>
      __\$\$${config.className}ImplCopyWithImpl<_\$${config.className}Impl>(this, _\$identity);
}
''';
  }
}

class StateImplArgTemplate {
  final StateFactoryArgConfig config;

  StateImplArgTemplate(this.config);
  @override
  String toString() {
    if (config.isChildState) {
      return "${!config.isNullable ? "required" : ""} this.${config.name}Wrapper,";
    } else {
      return "${!config.isNullable ? "required" : ""} this.${config.name},";
    }
  }
}

class StateImplFieldTemplate {
  final StateFactoryArgConfig config;

  StateImplFieldTemplate(this.config);

  @override
  String toString() {
    if (config.isChildState) {
      return '''
@override
final ${config.typeName}Wrapper ${config.name}Wrapper;
''';
    } else {
      return '''
@override
final ${config.typeName} ${config.name};
''';
    }
  }
}

class StateImplToStringTemplate {
  final StateFactoryArgConfig config;

  StateImplToStringTemplate(this.config);

  @override
  String toString() {
    final name = config.isChildState ? "${config.name}Wrapper" : config.name;
    return "$name: \$$name, ";
  }
}

class StateImplEqualTemplate {
  final StateFactoryArgConfig config;

  StateImplEqualTemplate(this.config);

  @override
  String toString() {
    final name = config.isChildState ? "${config.name}Wrapper" : config.name;
    return "&& (identical(other.$name, $name) || other.$name == $name)";
  }
}

class StateTemplate {
  final StateGenerationConfig config;

  StateTemplate(this.config);

  @override
  String toString() {
    final constructorArgsBuffer = StringBuffer();
    final fieldsBuffer = StringBuffer();
    final constructorBody = StateConstructorBodyTemplate(config);
    for (final argConfig in config.factory.args) {
      final constructorArg = StateArgTemplate(argConfig);
      constructorArgsBuffer.writeln(constructorArg);
      final field = StateFieldTemplate(argConfig);
      fieldsBuffer.writeln(field);
    }
    return '''
abstract class _${config.className} implements ${config.className} {
  factory _${config.className}({
    ${constructorArgsBuffer.toString()}
  }){${constructorBody.toString()}}

  ${fieldsBuffer.toString()}

  @override
  _\$\$${config.className}ImplCopyWith<_\$${config.className}Impl> get copyWith => throw _privateConstructorUsedError;
}
''';
  }
}

class StateArgTemplate {
  final StateFactoryArgConfig config;

  StateArgTemplate(this.config);
  @override
  String toString() {
    return "${!config.isNullable ? "required" : ""} final ${config.dartType} ${config.name},";
  }
}

class StateConstructorBodyTemplate {
  final StateGenerationConfig config;

  StateConstructorBodyTemplate(this.config);
  @override
  String toString() {
    final wrappersBuffer = StringBuffer();
    final argsBuffer = StringBuffer();
    for (final argConfig in config.factory.args) {
      if (argConfig.isChildState) {
        final wrapper = StateConstructorBodyWrapperTemplate(argConfig);
        wrappersBuffer.writeln(wrapper);
      }
      final arg = StateConstructorBodyArgTemplate(argConfig);
      argsBuffer.write(arg);
    }
    return '''
$wrappersBuffer
return _\$${config.className}Impl(${argsBuffer.toString()});
''';
  }
}

class StateConstructorBodyWrapperTemplate {
  final StateFactoryArgConfig config;

  StateConstructorBodyWrapperTemplate(this.config);
  @override
  String toString() {
    if (config.isChildState) {
      return "final ${config.name}Wrapper = ${config.typeName}Wrapper(${config.name});";
    } else {
      return "";
    }
  }
}

class StateConstructorBodyArgTemplate {
  final StateFactoryArgConfig config;

  StateConstructorBodyArgTemplate(this.config);
  @override
  String toString() {
    if (config.isChildState) {
      return "${config.name}Wrapper: ${config.name}Wrapper,";
    } else {
      return "${config.name}: ${config.name},";
    }
  }
}

class StateFieldTemplate {
  final StateFactoryArgConfig config;

  StateFieldTemplate(this.config);

  @override
  String toString() {
    if (config.isChildState) {
      return '''
@override
${config.typeName}Wrapper get ${config.name}Wrapper;
''';
    } else {
      return '''
@override
${config.typeName} get ${config.name};
''';
    }
  }
}

class StateWrapperTemplate {
  final StateGenerationConfig config;

  StateWrapperTemplate(this.config);

  @override
  String toString() {
    final methodsBuffer = StringBuffer();
    for (final argConfig in config.factory.args) {
      final method = StateWrapperMethodTemplate(argConfig);
      methodsBuffer.writeln(method.toString());
    }
    return '''
class ${config.className}Wrapper extends StateWrapper<${config.className}> {
  ${config.className}Wrapper(super.state);
  ${methodsBuffer.toString()}
}
''';
  }
}

class StateWrapperMethodTemplate {
  const StateWrapperMethodTemplate(this.config);

  final StateFactoryArgConfig config;

  @override
  String toString() {
    final typeName =
        config.isChildState ? "${config.typeName}Wrapper" : config.typeName;
    final name = config.isChildState ? "${config.name}Wrapper" : config.name;
    return '''
$typeName $name (WidgetRef ref) {
  return state(ref).$name;
}

void set${capitalize(config.name)} (WidgetRef ref,$typeName newValue) {
  update(ref,(state)=>state.copyWith($name: newValue));
}
''';
  }
}

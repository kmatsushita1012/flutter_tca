import 'package:analyzer/dart/element/element.dart';
import 'package:flutter_tca_generator_annotation/flutter_tca_generator_annotation.dart';
import 'package:source_gen/source_gen.dart';

import '../configs/code_config/state_config.dart';

/// Parses a given [FieldElement] to produce a [StateFieldConfig] instance.
/// This function examines the metadata annotations of the [FieldElement]
/// to extract default values and any JsonConverter configurations.
///
/// Returns a [StateFieldConfig] that contains parsed configurations.

StateFactoryConfig parseStateFactoryElement(ConstructorElement element) {
  List<StateFactoryArgConfig> args =
      element.parameters.map(parseStateFactoryArgElement).toList();

  return StateFactoryConfig(name: element.name, args: args);
}

StateFactoryArgConfig parseStateFactoryArgElement(ParameterElement element) {
  final annotations = element.metadata;
  final isChildState = annotations
      .map(_parseTcaChildStateAnnotation)
      .firstWhere((value) => value != null, orElse: () => null);
  return StateFactoryArgConfig(
    name: element.name,
    dartType: element.type,
    isChildState: isChildState ?? false,
  );
}

bool? _parseTcaChildStateAnnotation(ElementAnnotation annotation) {
  final objectType = annotation.computeConstantValue()?.type;

  const tcaChildStateChecker = TypeChecker.fromRuntime(ChildState);
  return objectType != null &&
      tcaChildStateChecker.isAssignableFromType(objectType);
}

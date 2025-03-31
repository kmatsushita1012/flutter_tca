import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:flutter_tca_generator_annotation/flutter_tca_generator_annotation.dart';
// import 'package:flutter_tca/flutter_tca.dart';
import 'package:source_gen/source_gen.dart';
import 'package:flutter_tca_generator/src/configs/build_yaml_config.dart';
import 'package:flutter_tca_generator/src/configs/code_config/state_config.dart';
import 'package:flutter_tca_generator/src/parsers/state_element_parser.dart';
import 'package:flutter_tca_generator/src/templates/tca_state_template.dart';

class TcaStateGenerator extends GeneratorForAnnotation<State> {
  const TcaStateGenerator(this._buildYamlConfig);

  // ignore: unused_field
  final BuildYamlConfig _buildYamlConfig;

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@TcaState can only be applied on classes. '
        'Failing element: ${element.name}',
        element: element,
      );
    }

    // ignore: unused_local_variable
    final annotation = const TypeChecker.fromRuntime(
      State,
    ).firstAnnotationOf(element, throwOnUnresolved: false)!;

    final factories = element.constructors
        .where((item) => item.isFactory)
        .map(parseStateFactoryElement)
        .toList();

    final config = StateGenerationConfig(
      className: element.name,
      factories: factories,
    );

    final buffer = StringBuffer()..writeln(TcaStateTemplate(config));

    return buffer.toString();
  }
}

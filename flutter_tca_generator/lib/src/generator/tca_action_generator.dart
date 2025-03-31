// import 'package:analyzer/dart/element/element.dart';
// import 'package:build/build.dart';
// import 'package:source_gen/source_gen.dart';
// import 'package:flutter_tca_generator/src/configs/build_yaml_config.dart';
// import 'package:flutter_tca_generator/src/configs/code_generation_config.dart';

// class TcaActionGenerator extends GeneratorForAnnotation<TcaAction> {
//   const TcaActionGenerator(this._buildYamlConfig);

//   final BuildYamlConfig _buildYamlConfig;

//   @override
//   String generateForAnnotatedElement(
//     Element element,
//     ConstantReader annotation,
//     BuildStep buildStep,
//   ) {
//     if (element is! ClassElement) {
//       throw InvalidGenerationSourceError(
//         '@TcaAction can only be applied on classes. '
//         'Failing element: ${element.name}',
//         element: element,
//       );
//     }

//     final annotation =
//         const TypeChecker.fromRuntime(
//           TcaAction,
//         ).firstAnnotationOf(element, throwOnUnresolved: false)!;

//     final config = CodeGenerationConfig(
//       className: element.name,
//       fieldConfigs: element.fields.map(parseFieldElement).toList(),
//       convertSnakeCaseToCamelCase: annotation.decodeField<bool>(
//         'convertSnakeToCamel',
//         decode: (obj) => obj.toBoolValue()!,
//         orElse: () => _buildYamlConfig.convertSnakeToCamel,
//       ),
//     );

//     final buffer = StringBuffer()..writeln(TcaActionTemplate(config));

//     return buffer.toString();
//   }
// }

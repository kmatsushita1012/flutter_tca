/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:flutter_tca_generator/src/flutter_tca_generator.dart';
import 'src/configs/build_yaml_config.dart';

export 'src/generator/tca_state_generator.dart';

// Export any libraries intended for clients of this package.
Builder tcaStateGenerator(BuilderOptions options) {
  return PartBuilder(
    [TcaStateGenerator(BuildYamlConfig.fromBuildYaml(options.config))],
    '.tca.dart',
    header: '''
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark
''',
    options: options,
  );
}

// Builder tcaActionGenerator(BuilderOptions options) {
//   return PartBuilder(
//     [TcaActionGenerator(BuildYamlConfig.fromBuildYaml(options.config))],
//     '.from_json.dart',
//     header: '''
// // coverage:ignore-file
// // ignore_for_file: type=lint
// // ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark
// ''',
//     options: options,
//   );
// }

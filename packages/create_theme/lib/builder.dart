import 'package:build/build.dart';
import 'package:create_theme/src/generator.dart';
import 'package:source_gen/source_gen.dart';

Builder createThemeBuilder(BuilderOptions options) {
  return SharedPartBuilder(
    [CreateThemeGenerator()],
    'create_theme',
  );
}

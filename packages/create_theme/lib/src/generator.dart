import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:create_theme/src/commons.dart';
import 'package:create_theme/src/template/inherited_theme.dart';
import 'package:create_theme/src/template/theme_extension.dart';
import 'package:create_theme_annotation/create_theme_annotation.dart';
import 'package:source_gen/source_gen.dart';

class CreateThemeGenerator extends GeneratorForAnnotation<CreateTheme> {
  @override
  String generateForAnnotatedElement(
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final themeName = ThemeName.fromAnnotatedElement(
      element: element,
      annotation: annotation,
    );

    final createDefault = annotation.read('createDefault');
    final createDefaultFunction = createDefault.isNull
        ? null
        : createDefault.objectValue.toFunctionValue2();

    final themeExtensionTemplate = ThemeExtensionTemplate(
      name: themeName.extension,
      properties: ThemeProperties.iterableFromAnnotatedElement(
        annotation: annotation,
        themeName: themeName,
      ).toList(),
    );

    final inheritedThemeTemplate = InheritedThemeTemplate(
      name: themeName.widget,
      dataName: themeName.extension,
      createDefaultFunction: createDefaultFunction != null
          ? getFunctionName(createDefaultFunction)
          : null,
    );

    return '''
${themeExtensionTemplate.generate()}

${inheritedThemeTemplate.generate()}
''';
  }
}

class ThemeName {
  const ThemeName({required this.extension, required this.widget});

  factory ThemeName.fromAnnotatedElement({
    required Element2 element,
    required ConstantReader annotation,
  }) {
    final themeName = annotation.read('name');
    if (themeName.isNull) {
      final name = element.name3;

      if (name == null) {
        throw Exception('@CreateTheme element name is null');
      }

      return ThemeName(extension: '${name}ThemeData', widget: '${name}Theme');
    }

    return ThemeName(
      extension: themeName.read('themeExtension').stringValue,
      widget: themeName.read('themeWidget').stringValue,
    );
  }

  final String extension;
  final String widget;
}

class ThemeProperties {
  ThemeProperties({
    required this.type,
    required this.name,
    required this.function,
  });

  final String type;
  final String name;
  final String function;

  static Iterable<ThemeProperties> iterableFromAnnotatedElement({
    required ConstantReader annotation,
    required ThemeName themeName,
  }) sync* {
    final Map<DartObject?, DartObject?> map = annotation
        .read('themeProperties')
        .mapValue;

    if (map.isEmpty) {
      throw Exception(
        'themeProperties for widget ${themeName.extension} is empty',
      );
    }

    for (final prop in map.entries) {
      final String? name = prop.key?.toStringValue();
      if (name == null) {
        throw Exception('One of themeProperties key is not String');
      }

      if (name.isEmpty) {
        throw Exception('One of themeProperties key is an empty String');
      }

      final ConstantReader value = ConstantReader(prop.value);
      final DartType type = value.read('propertiesType').typeValue;
      final ExecutableElement2? lerp = value
          .read('lerp')
          .objectValue
          .toFunctionValue2();

      if (lerp == null) {
        throw Exception('$name lerp is not a function');
      }

      yield ThemeProperties(
        type: type.getDisplayString(),
        name: name,
        function: getFunctionName(lerp),
      );
    }
  }
}

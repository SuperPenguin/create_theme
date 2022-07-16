import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
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
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final widgetName = element.name;
    if (widgetName == null) {
      throw Exception('@CreateTheme element name is null');
    }
    if (widgetName.isEmpty) {
      throw Exception('@CreateTheme element name is empty String');
    }

    final themeExtensionName = '${widgetName}ThemeData';
    final themeInheritedName = '${widgetName}Theme';
    final createDefault = annotation.read('createDefault');
    final createDefaultFunction = createDefault.isNull
        ? null
        : createDefault.objectValue.toFunctionValue();

    final themeExtensionTemplate = ThemeExtensionTemplate(
      name: themeExtensionName,
      properties: ThemeProperties.iterableFromAnnotation(annotation).toList(),
    );

    final inheritedThemeTemplate = InheritedThemeTemplate(
      name: themeInheritedName,
      dataName: themeExtensionName,
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

class ThemeProperties {
  ThemeProperties({
    required this.type,
    required this.name,
    required this.function,
  });

  final String type;
  final String name;
  final String function;

  static Iterable<ThemeProperties> iterableFromAnnotation(
    ConstantReader annotation, {
    String? elementName,
  }) sync* {
    final Map<DartObject?, DartObject?> map =
        annotation.read('themeProperties').mapValue;

    if (map.isEmpty) {
      throw Exception(
        'themeProperties for widget $elementName is empty',
      );
    }

    for (final prop in map.entries) {
      final String? name = prop.key?.toStringValue();
      if (name == null) {
        throw Exception('One of themeProperties key is not String');
      }

      if (name.isEmpty) {
        throw Exception(
          'One of themeProperties key is an empty String',
        );
      }

      final ConstantReader value = ConstantReader(prop.value);
      final DartType type = value.read('propertiesType').typeValue;
      final ExecutableElement? lerp =
          value.read('lerp').objectValue.toFunctionValue();

      if (lerp == null) {
        throw Exception(
          '$name lerp is not a function',
        );
      }

      yield ThemeProperties(
        type: type.getDisplayString(withNullability: false),
        name: name,
        function: getFunctionName(lerp),
      );
    }
  }
}

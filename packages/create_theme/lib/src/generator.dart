import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
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
    if (widgetName == null) return '';

    final themeExtensionName = '${widgetName}ThemeData';
    final themeInheritedName = '${widgetName}Theme';
    final themeProperties = annotation.read('themeProperties').mapValue;
    if (themeProperties.isEmpty) return '';

    final List<_Properties> props = [];

    for (final prop in themeProperties.entries) {
      final String? propName = prop.key?.toStringValue();
      final DartObject? propValue = prop.value;
      final valueReader = ConstantReader(propValue);
      final propLerpFunction =
          valueReader.read('lerp').objectValue.toFunctionValue();
      if (propName == null || propName.isEmpty) continue;
      if (propValue == null) continue;
      if (propLerpFunction == null) continue;

      final propType = valueReader.read('propertiesType').typeValue;
      final propTypeName = propType.getDisplayString(withNullability: false);

      props.add(
        _Properties(
          typeName: propTypeName,
          name: propName,
          callableFunctionString: _callableFunctionString(propLerpFunction),
        ),
      );
    }

    final constructor = _constructor(themeExtensionName, props);
    final properties = _properties(props);
    final copyWith = _copyWith(themeExtensionName, props);
    final merge = _merge(themeExtensionName, props);
    final lerp = _lerp(themeExtensionName, props);
    final equalOperator = _equalOperator(themeExtensionName, props);
    final hashCode = _hashCode(props);

    final createDefaultFunction = annotation.read('createDefault');

    final inheritedTheme = _inheritedTheme(
      themeExtensionName,
      createDefaultFunction.isNull
          ? null
          : createDefaultFunction.objectValue.toFunctionValue(),
    );

    return '''
class $themeExtensionName extends ThemeExtension<$themeExtensionName> {
  $constructor

  $properties

  $copyWith

  $lerp

  $merge

  $equalOperator

  $hashCode
}

class $themeInheritedName extends InheritedWidget {
  const $themeInheritedName({
    super.key,
    required this.theme,
    required super.child,
  });

  final $themeExtensionName theme;

  @override
  bool updateShouldNotify($themeInheritedName oldWidget) {
    return oldWidget.theme != theme;
  }

  static $themeExtensionName of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<$themeInheritedName>();
    final localTheme = widget?.theme;

    final theme = Theme.of(context);
    final rootTheme = theme.extensions[$themeExtensionName] as $themeExtensionName?;

    $inheritedTheme
  }
}
''';
  }
}

String _callableFunctionString(ExecutableElement fe) {
  if (fe is FunctionElement) {
    return fe.name;
  }

  if (fe is MethodElement) {
    return '${fe.enclosingElement.name}.${fe.name}';
  }

  throw UnsupportedError(
    'Not sure how to support typeof ${fe.runtimeType}',
  );
}

class _Properties {
  _Properties({
    required this.typeName,
    required this.name,
    required this.callableFunctionString,
  });

  final String typeName;
  final String name;
  final String callableFunctionString;
}

String _constructor(
  String themeExtensionName,
  List<_Properties> props,
) {
  final constuctorParams = StringBuffer();

  for (final p in props) {
    constuctorParams.write('this.${p.name},');
  }

  return '''
  const $themeExtensionName({$constuctorParams});
''';
}

String _properties(
  List<_Properties> props,
) {
  final sb = StringBuffer();

  for (final p in props) {
    sb.writeln('final ${p.typeName}? ${p.name};');
  }

  return sb.toString();
}

String _copyWith(
  String themeExtensionName,
  List<_Properties> props,
) {
  final functionParams = StringBuffer();
  final returnParams = StringBuffer();

  for (final p in props) {
    functionParams.write('${p.typeName}? ${p.name},');
    returnParams.write('${p.name}: ${p.name} ?? this.${p.name},');
  }

  return '''
  @override
  $themeExtensionName copyWith({$functionParams}) {
    return $themeExtensionName($returnParams);
  }
''';
}

String _merge(
  String themeExtensionName,
  List<_Properties> props,
) {
  final returnParams = StringBuffer();

  for (final p in props) {
    returnParams.write('${p.name}: other.${p.name},');
  }

  return '''
  $themeExtensionName merge($themeExtensionName? other) {
    if (other == null) return this;

    return copyWith($returnParams);
  }
''';
}

String _lerp(
  String themeExtensionName,
  List<_Properties> props,
) {
  final returnParams = StringBuffer();

  for (final p in props) {
    returnParams.write(
      '${p.name}: ${p.callableFunctionString}(${p.name}, other.${p.name}, t),',
    );
  }

  return '''
  @override
  $themeExtensionName lerp(
    ThemeExtension<$themeExtensionName>? other,
    double t,
  ) {
    if (other is! $themeExtensionName) return this;

    return $themeExtensionName($returnParams);
  }
''';
}

String _equalOperator(
  String themeExtensionName,
  List<_Properties> props,
) {
  final propsEqual = StringBuffer();

  for (final p in props) {
    propsEqual.write(' && other.${p.name} == ${p.name}');
  }

  return '''
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is $themeExtensionName$propsEqual;
  }
''';
}

String _hashCode(
  List<_Properties> props,
) {
  final allProps = StringBuffer();

  for (final p in props) {
    allProps.write('${p.name},');
  }

  return '''
  @override
  int get hashCode {
    return Object.hashAll([$allProps]);
  }
''';
}

String _inheritedTheme(
  String themeExtensionName,
  ExecutableElement? functionElement,
) {
  if (functionElement == null) {
    return '''
  final result = rootTheme?.merge(localTheme);
  if (result != null) return result;

  throw Exception(
    'Unable to get any $themeExtensionName, add createDefault to @CreateTheme or add $themeExtensionName to your ThemeData extension',
  );
''';
  }

  final createDefault = _callableFunctionString(functionElement);

  return '''
  final $themeExtensionName defaultTheme = $createDefault(theme);
  final result = defaultTheme.merge(rootTheme?.merge(localTheme));

  return result;
''';
}

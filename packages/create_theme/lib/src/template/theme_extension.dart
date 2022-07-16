import 'package:create_theme/src/generator.dart';

class ThemeExtensionTemplate {
  ThemeExtensionTemplate({
    required this.name,
    required this.properties,
  });

  final String name;
  final List<ThemeProperties> properties;

  String generate() {
    return '''
class $name extends ThemeExtension<$name>{
  $generateConstructor

  $generateFields

  $generateCopyWith

  $generateLerp

  $generateMerge

  $generateEqualOperator
  
  $generateHashCode
}
''';
  }

  String get generateConstructor {
    final params = StringBuffer();

    for (final p in properties) {
      params.write('this.${p.name},');
    }

    return 'const $name({$params});';
  }

  String get generateFields {
    final fields = StringBuffer();

    for (final p in properties) {
      fields.writeln('final ${p.type}? ${p.name};');
    }

    return fields.toString();
  }

  String get generateCopyWith {
    final functionParams = StringBuffer();
    final returnParams = StringBuffer();

    for (final p in properties) {
      functionParams.write('${p.type}? ${p.name},');
      returnParams.write('${p.name}: ${p.name} ?? this.${p.name},');
    }

    return '''
  @override
  $name copyWith({$functionParams}) {
    return $name($returnParams);
  }
''';
  }

  String get generateLerp {
    final params = StringBuffer();

    for (final p in properties) {
      params.write(
        '${p.name}: ${p.function}(${p.name}, other.${p.name}, t),',
      );
    }

    return '''
  @override
  $name lerp(
    ThemeExtension<$name>? other,
    double t,
  ) {
    if (other is! $name) return this;

    return $name($params);
  }
''';
  }

  String get generateMerge {
    final params = StringBuffer();

    for (final p in properties) {
      params.write('${p.name}: other.${p.name},');
    }

    return '''
  $name merge($name? other) {
    if (other == null) return this;

    return copyWith($params);
  }
''';
  }

  String get generateEqualOperator {
    final fields = StringBuffer();

    for (final p in properties) {
      fields.write(' && other.${p.name} == ${p.name}');
    }

    return '''
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is $name$fields;
  }
''';
  }

  String get generateHashCode {
    final fields = StringBuffer();

    for (final p in properties) {
      fields.write('${p.name},');
    }

    return '''
  @override
  int get hashCode {
    return Object.hashAll([$fields]);
  }
''';
  }
}

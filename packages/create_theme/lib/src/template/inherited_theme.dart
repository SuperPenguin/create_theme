class InheritedThemeTemplate {
  InheritedThemeTemplate({
    required this.name,
    required this.dataName,
    required this.createDefaultFunction,
  });

  final String name;
  final String dataName;
  final String? createDefaultFunction;

  String generate() {
    return '''
class $name extends InheritedWidget {
  const $name({
    super.key,
    required this.theme,
    required super.child,
  });

  final $dataName theme;

  @override
  bool updateShouldNotify($name oldWidget) {
    return oldWidget.theme != theme;
  }

  $generateInheritedOf
}
''';
  }

  String get generateInheritedOf {
    if (createDefaultFunction == null) {
      return '''
  static $dataName of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<$name>();
    final localTheme = widget?.theme;

    final theme = Theme.of(context);
    final rootTheme = theme.extensions[$dataName] as $dataName?;

    final result = rootTheme?.merge(localTheme);
    if (result != null) return result;

    throw Exception(
      'Unable to get any $dataName, add createDefault to @CreateTheme or add $dataName to your ThemeData extension',
    );
  }
''';
    }

    return '''
  static $dataName of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<$name>();
    final localTheme = widget?.theme;

    final theme = Theme.of(context);
    final rootTheme = theme.extensions[$dataName] as $dataName?;

    final $dataName defaultTheme = $createDefaultFunction(theme);
    final result = defaultTheme.merge(rootTheme?.merge(localTheme));

    return result;
  }
''';
  }
}

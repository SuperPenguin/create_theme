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
  static $dataName? maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<$name>();
    final localTheme = widget?.theme;

    final theme = Theme.of(context);
    final rootTheme = theme.extensions[$dataName] as $dataName?;

    return rootTheme?.merge(localTheme);
  }
  
  static $dataName of(BuildContext context) {
    final result = maybeOf(context);

    assert(() {
      if (result == null) {
        throw FlutterError.fromParts([
          ErrorSummary(
            'Unable to get any $dataName, add createDefault to @CreateTheme or add $dataName to your ThemeData extension',
          ),
          context.describeElement('The context used was'),
        ]);
      }
      return true;
    });

    return result!;
  }
''';
    }

    return '''
  static $dataName? maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<$name>();
    final localTheme = widget?.theme;

    final theme = Theme.of(context);
    final rootTheme = theme.extensions[$dataName] as $dataName?;

    final $dataName defaultTheme = $createDefaultFunction(theme);
    final result = defaultTheme.merge(rootTheme).merge(localTheme);

    return result;
  }
  
  static $dataName of(BuildContext context) {
    final result = maybeOf(context);

    assert(() {
      if (result == null) {
        throw FlutterError.fromParts([
          ErrorSummary(
            'Unable to get any $dataName, add createDefault to @CreateTheme or add $dataName to your ThemeData extension',
          ),
          context.describeElement('The context used was'),
        ]);
      }
      return true;
    });

    return result!;
  }
''';
  }
}

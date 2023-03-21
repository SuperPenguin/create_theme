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
    final String maybeOf;
    final String of;

    if (createDefaultFunction == null) {
      maybeOf = '''
  static $dataName? maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<$name>();
    final localTheme = widget?.theme;

    final theme = Theme.of(context);
    final rootTheme = theme.extension<$dataName>();

    return rootTheme?.merge(localTheme);
  }
''';
    } else {
      maybeOf = '''
  static $dataName? maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<$name>();
    final localTheme = widget?.theme;

    final theme = Theme.of(context);
    final rootTheme = theme.extension<$dataName>();

    final $dataName defaultTheme = $createDefaultFunction(theme);
    final result = defaultTheme.merge(rootTheme).merge(localTheme);

    return result;
  }
''';
    }

    of = '''
  static $dataName of(BuildContext context) {
    final result = maybeOf(context);

    assert(() {
      if (result == null) {
        throw FlutterError.fromParts([
          ErrorSummary(
            'Unable to get any $dataName from context, add createDefault to @CreateTheme or add $dataName to your ThemeData extension',
          ),
          context.describeElement('The context used was'),
        ]);
      }
      return true;
    }());

    return result!;
  }
''';

    return '''
  $maybeOf

  $of
''';
  }
}

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
class $name extends InheritedTheme {
  const $name({
    super.key,
    required this.data,
    required super.child,
  });

  final $dataName data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return $name(data: data, child: child);
  }

  @override
  bool updateShouldNotify($name oldWidget) {
    return oldWidget.data != data;
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
    final localTheme = widget?.data;

    final theme = Theme.of(context);
    final rootTheme = theme.extension<$dataName>();

    return rootTheme?.merge(localTheme);
  }
''';
    } else {
      maybeOf = '''
  static $dataName? maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<$name>();
    final localTheme = widget?.data;

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

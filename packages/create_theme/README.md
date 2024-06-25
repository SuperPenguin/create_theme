# Create Theme
codegen for flutter ThemeExtension

# Installing

```
flutter pub add create_theme_annotation
flutter pub add --dev create_theme
```

# Example

`my_widget.dart`


```dart
import 'package:create_theme_annotation/create_theme_annotation.dart';
import 'package:flutter/material.dart';

part 'my_widget.g.dart';

MyWidgetThemeData _createDefault(ThemeData theme) {
  return MyWidgetThemeData(
    headerColor: theme.colorScheme.primary,
    headerTextStyle: TextStyle(
      color: theme.colorScheme.onPrimary,
    ),
    backgroundColor: theme.scaffoldBackgroundColor,
  );
}

@CreateTheme(
  themeProperties: {
    'headerColor': CreateThemeColor(),
    'headerTextStyle': CreateThemeTextStyle(),
    'backgroundColor': CreateThemeColor(),
  },
  createDefault: _createDefault,
)
class MyWidget extends StatelessWidget {
  const MyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = MyWidgetTheme.of(context);

    return Column(
      children: [
        Material(
          color: theme.headerColor,
          child: DefaultTextStyle.merge(
            style: theme.headerTextStyle,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text('Header'),
              ),
            ),
          ),
        ),
        Expanded(
          child: Material(
            color: theme.backgroundColor,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text('Body'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CreateThemeColor extends CreateThemeProperties<Color> {
  const CreateThemeColor();

  @override
  Color? lerp(Color? a, Color? b, double t) {
    return Color.lerp(a, b, t);
  }
}

class CreateThemeTextStyle extends CreateThemeProperties<TextStyle> {
  const CreateThemeTextStyle();

  @override
  TextStyle? lerp(TextStyle? a, TextStyle? b, double t) {
    return TextStyle.lerp(a, b, t);
  }
}

@CreateTheme(
  name: CreateThemeName(
    themeExtension: 'HelloThemeData',
    themeWidget: 'WorldTheme',
  ),
  themeProperties: {
    'textStyle': CreateThemeTextStyle(),
  },
)
class HelloWorld extends StatelessWidget {
  const HelloWorld({super.key});

  @override
  Widget build(BuildContext context) {
    final HelloThemeData theme = WorldTheme.of(context);

    return Text(
      'Hello World',
      style: theme.textStyle,
    );
  }
}
```

`my_widget.g.dart`

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_widget.dart';

// **************************************************************************
// CreateThemeGenerator
// **************************************************************************

class MyWidgetThemeData extends ThemeExtension<MyWidgetThemeData> {
  const MyWidgetThemeData({
    this.headerColor,
    this.headerTextStyle,
    this.backgroundColor,
  });

  final Color? headerColor;
  final TextStyle? headerTextStyle;
  final Color? backgroundColor;

  @override
  MyWidgetThemeData copyWith({
    Color? headerColor,
    TextStyle? headerTextStyle,
    Color? backgroundColor,
  }) {
    return MyWidgetThemeData(
      headerColor: headerColor ?? this.headerColor,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  MyWidgetThemeData lerp(
    ThemeExtension<MyWidgetThemeData>? other,
    double t,
  ) {
    if (other is! MyWidgetThemeData) return this;

    return MyWidgetThemeData(
      headerColor:
          const CreateThemeColor().lerp(headerColor, other.headerColor, t),
      headerTextStyle: const CreateThemeTextStyle()
          .lerp(headerTextStyle, other.headerTextStyle, t),
      backgroundColor: const CreateThemeColor()
          .lerp(backgroundColor, other.backgroundColor, t),
    );
  }

  MyWidgetThemeData merge(MyWidgetThemeData? other) {
    if (other == null) return this;

    return copyWith(
      headerColor: other.headerColor,
      headerTextStyle: other.headerTextStyle,
      backgroundColor: other.backgroundColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyWidgetThemeData &&
        other.headerColor == headerColor &&
        other.headerTextStyle == headerTextStyle &&
        other.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      headerColor,
      headerTextStyle,
      backgroundColor,
    ]);
  }
}

class MyWidgetTheme extends InheritedWidget {
  const MyWidgetTheme({
    super.key,
    required this.theme,
    required super.child,
  });

  final MyWidgetThemeData theme;

  @override
  bool updateShouldNotify(MyWidgetTheme oldWidget) {
    return oldWidget.theme != theme;
  }

  static MyWidgetThemeData? maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<MyWidgetTheme>();
    final localTheme = widget?.theme;

    final theme = Theme.of(context);
    final rootTheme = theme.extension<MyWidgetThemeData>();

    final MyWidgetThemeData defaultTheme = _createDefault(theme);
    final result = defaultTheme.merge(rootTheme).merge(localTheme);

    return result;
  }

  static MyWidgetThemeData of(BuildContext context) {
    final result = maybeOf(context);

    assert(() {
      if (result == null) {
        throw FlutterError.fromParts([
          ErrorSummary(
            'Unable to get any MyWidgetThemeData from context, add createDefault to @CreateTheme or add MyWidgetThemeData to your ThemeData extension',
          ),
          context.describeElement('The context used was'),
        ]);
      }
      return true;
    }());

    return result!;
  }
}

class HelloThemeData extends ThemeExtension<HelloThemeData> {
  const HelloThemeData({
    this.textStyle,
  });

  final TextStyle? textStyle;

  @override
  HelloThemeData copyWith({
    TextStyle? textStyle,
  }) {
    return HelloThemeData(
      textStyle: textStyle ?? this.textStyle,
    );
  }

  @override
  HelloThemeData lerp(
    ThemeExtension<HelloThemeData>? other,
    double t,
  ) {
    if (other is! HelloThemeData) return this;

    return HelloThemeData(
      textStyle:
          const CreateThemeTextStyle().lerp(textStyle, other.textStyle, t),
    );
  }

  HelloThemeData merge(HelloThemeData? other) {
    if (other == null) return this;

    return copyWith(
      textStyle: other.textStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HelloThemeData && other.textStyle == textStyle;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      textStyle,
    ]);
  }
}

class WorldTheme extends InheritedWidget {
  const WorldTheme({
    super.key,
    required this.theme,
    required super.child,
  });

  final HelloThemeData theme;

  @override
  bool updateShouldNotify(WorldTheme oldWidget) {
    return oldWidget.theme != theme;
  }

  static HelloThemeData? maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<WorldTheme>();
    final localTheme = widget?.theme;

    final theme = Theme.of(context);
    final rootTheme = theme.extension<HelloThemeData>();

    return rootTheme?.merge(localTheme);
  }

  static HelloThemeData of(BuildContext context) {
    final result = maybeOf(context);

    assert(() {
      if (result == null) {
        throw FlutterError.fromParts([
          ErrorSummary(
            'Unable to get any HelloThemeData from context, add createDefault to @CreateTheme or add HelloThemeData to your ThemeData extension',
          ),
          context.describeElement('The context used was'),
        ]);
      }
      return true;
    }());

    return result!;
  }
}
```
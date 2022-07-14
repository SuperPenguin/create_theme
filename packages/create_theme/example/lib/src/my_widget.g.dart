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
      headerColor: Color.lerp(headerColor, other.headerColor, t),
      headerTextStyle:
          TextStyle.lerp(headerTextStyle, other.headerTextStyle, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
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

  static MyWidgetThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<MyWidgetTheme>();
    final localTheme = widget?.theme;

    final theme = Theme.of(context);
    final rootTheme = theme.extensions[MyWidgetThemeData] as MyWidgetThemeData?;

    final MyWidgetThemeData defaultTheme = _createDefault(theme);
    final result = defaultTheme.merge(rootTheme?.merge(localTheme));

    return result;
  }
}

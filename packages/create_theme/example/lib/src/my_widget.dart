import 'package:create_theme_annotation/create_theme_annotation.dart';
import 'package:flutter/material.dart';

part 'my_widget.g.dart';

class MyWidgetTemplate extends CreateTheme {
  const MyWidgetTemplate()
      : super(
          themeProperties: const {
            'headerColor': CreateThemeColor(),
            'headerTextStyle': CreateThemeTextStyle(),
            'backgroundColor': CreateThemeColor(),
          },
          createDefault: _createDefault,
        );

  static MyWidgetThemeData _createDefault(ThemeData theme) {
    return MyWidgetThemeData(
      headerColor: theme.colorScheme.primary,
      headerTextStyle: TextStyle(
        color: theme.colorScheme.onPrimary,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
    );
  }
}

@MyWidgetTemplate()
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

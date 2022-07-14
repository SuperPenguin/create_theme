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
    Key? key,
  }) : super(key: key);

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
  const CreateThemeColor() : super(propertiesType: Color, lerp: Color.lerp);
}

class CreateThemeTextStyle extends CreateThemeProperties<TextStyle> {
  const CreateThemeTextStyle()
      : super(propertiesType: TextStyle, lerp: TextStyle.lerp);
}

class CreateTheme {
  const CreateTheme({
    this.name,
    this.themeProperties = const {},
    this.createDefault,
  });

  final CreateThemeName? name;
  final Map<String, CreateThemeProperties<dynamic>> themeProperties;
  final Function? createDefault;
}

abstract class CreateThemeProperties<T> {
  const CreateThemeProperties();

  T? lerp(T? a, T? b, double t);
}

class CreateThemeName {
  const CreateThemeName({
    required this.themeExtension,
    required this.themeWidget,
  });

  final String themeExtension;
  final String themeWidget;
}

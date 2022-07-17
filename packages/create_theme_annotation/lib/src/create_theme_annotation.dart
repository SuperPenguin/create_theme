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
  const CreateThemeProperties({
    required this.propertiesType,
    required this.lerp,
  });

  final Type propertiesType;
  final T? Function(T? a, T? b, double t) lerp;
}

class CreateThemeName {
  const CreateThemeName({
    required this.themeExtension,
    required this.themeWidget,
  });

  final String themeExtension;
  final String themeWidget;
}

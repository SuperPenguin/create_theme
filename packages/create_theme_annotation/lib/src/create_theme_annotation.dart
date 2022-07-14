class CreateTheme {
  const CreateTheme({
    this.themeProperties,
    this.createDefault,
  });

  final Map<String, CreateThemeProperties<dynamic>>? themeProperties;
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

import 'package:analyzer/dart/element/element.dart';

String getFunctionName(ExecutableElement e) {
  if (e is FunctionElement) {
    return e.name;
  }

  if (e is MethodElement) {
    return '${e.enclosingElement.name}.${e.name}';
  }

  if (e is ConstructorElement) {
    if (e.name.isEmpty) {
      return e.enclosingElement.name;
    }
    return '${e.enclosingElement.name}.${e.name}';
  }

  throw UnsupportedError(
    'Not sure how to support typeof ${e.runtimeType}',
  );
}

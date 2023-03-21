import 'package:analyzer/dart/element/element.dart';

String getFunctionName(ExecutableElement e) {
  if (e is FunctionElement) {
    return e.name;
  }

  if (e is MethodElement) {
    return '${e.enclosingElement3.name}.${e.name}';
  }

  if (e is ConstructorElement) {
    if (e.name.isEmpty) {
      return e.enclosingElement3.name;
    }
    return '${e.enclosingElement3.name}.${e.name}';
  }

  throw UnsupportedError(
    'Not sure how to support typeof ${e.runtimeType}',
  );
}

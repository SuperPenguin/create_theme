import 'package:analyzer/dart/element/element2.dart';

String getFunctionName(ExecutableElement2 e) {
  if (e is TopLevelFunctionElement) {
    return e.name3!;
  }

  if (e is MethodElement2) {
    return '${e.enclosingElement2!.name3!}.${e.name3!}';
  }

  if (e is ConstructorElement2) {
    // The default constructor.
    if (e.name3 == 'new') {
      return e.enclosingElement2.name3!;
    }
    return '${e.enclosingElement2.name3!}.${e.name3!}';
  }

  throw UnsupportedError('Not sure how to support typeof ${e.runtimeType}');
}

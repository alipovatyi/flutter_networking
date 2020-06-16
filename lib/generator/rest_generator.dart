import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:flutternetworking/generator/rest_annotations.dart';
import 'package:source_gen/source_gen.dart';

class RestGenerator extends GeneratorForAnnotation<ApiService> {
  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final path = annotation.peek('path').stringValue;
    final methods = (element as ClassElement).methods;

    final cl = Class((c) {
      c.name = '_${element.name}';
      c.implements.add(refer(element.name));
      c.fields.addAll([
        _createFinalField('_client', 'RestClient'),
      ]);
      c.methods.addAll(_generateMethods(path, methods));
      c.constructors.add(_generateConstructor());
    });

    return DartFormatter().format('${cl.accept(DartEmitter())}');
  }

  final _methodAnnotations = const [GET, POST, PUT];

  Method _generateRequestMethod(MethodElement element, String path) {
    final returnType = _genericOf(element.returnType);
    final name = element.name;
    final methodAnnotation = _getMethodAnnotation(element);
    final methodBodyParamName = _getMethodBodyParamName(element);
    final methodName = methodAnnotation.peek('name').stringValue;
    final methodPath = methodAnnotation.peek('path').stringValue;
    final headers = _getHeadersAnnotation(element).peek('headers').mapValue;
    final headersJson = _generateHeaders(headers);
    return Method((b) {
      final body = Code('''
        final url = _client.baseUrl + '/${_createUrl([path, methodPath])}';
        final method = '$methodName';
        final headers = $headersJson;
        final request = Request(method, Uri.parse(url));
        request.headers.addEntries(headers.entries);
        request.body = ${methodBodyParamName != null ? 'jsonEncode($methodBodyParamName)' : "''"};
        final response = await _client.send(request);
        return $returnType.fromJson(jsonDecode(response.body));
      ''');
      b.annotations.add(CodeExpression(Code('override')));
      b.name = name;
      b.modifier = MethodModifier.async;
      b.body = body;
      b.requiredParameters.addAll(element.parameters.map(
        (e) => Parameter((p) {
          p.name = methodBodyParamName;
          p.type = refer(e.type.toString()).type;
        }),
      ));
    });
  }

  _createFinalField(String name, String type) {
    return Field((f) {
      f.name = name;
      f.modifier = FieldModifier.final$;
      f.type = refer(type).type;
    });
  }

  _generateParameter(String name, bool named) {
    return Parameter((p) {
      p.name = name;
      p.named = named;
      p.toThis = true;
    });
  }

  _generateConstructor() {
    return Constructor((c) {
      c.requiredParameters.add(_generateParameter('_client', false));
    });
  }

  _generateMethods(String path, List<MethodElement> methods) {
    return methods.map((element) => _generateRequestMethod(element, path));
  }

  _generateHeaders(Map<dynamic, dynamic> headers) {
    final map = {};
    headers.forEach((k, v) {
      map[literal(k.toStringValue())] = literal(v.toStringValue());
    });
    return map;
  }

  _getMethodAnnotation(MethodElement element) {
    for (final type in _methodAnnotations) {
      final annotation = _getAnnotation(element, type);
      if (annotation != null) {
        return ConstantReader(annotation);
      }
    }
    return null;
  }

  _getMethodBodyParamName(MethodElement element) => element
      .parameters
      .firstWhere((e) => _hasAnnotation(e, Body), orElse: () => null)
      ?.name;

  _getHeadersAnnotation(MethodElement element) {
    final annotation = _getAnnotation(element, Headers);
    if (annotation != null) {
      return ConstantReader(annotation);
    }
    return null;
  }

  _getAnnotation(Element element, dynamic annotation) =>
      _typeChecker(annotation)
          .firstAnnotationOf(element, throwOnUnresolved: false);

  _hasAnnotation(Element element, dynamic annotation) =>
      _getAnnotation(element, annotation) != null;

  TypeChecker _typeChecker(Type type) => TypeChecker.fromRuntime(type);

  String _createUrl(Iterable<String> parts) =>
      parts.where((element) => element.isNotEmpty).join('/');

  DartType _genericOf(DartType type) {
    return type is InterfaceType && type.typeArguments.isNotEmpty
        ? type.typeArguments.first
        : null;
  }
}

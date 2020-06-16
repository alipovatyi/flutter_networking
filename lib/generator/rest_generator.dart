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
        _createFinalField('_client', 'Client'),
        _createFinalField('baseUrl', 'String'),
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
    final methodName = methodAnnotation.peek('name').stringValue;
    final methodPath = methodAnnotation.peek('path').stringValue;
    final headers = _getHeadersAnnotation(element).peek('headers').mapValue;
    final headersJson = _generateHeaders(headers);
    return Method((b) {
      final body = Code('''
        final url = baseUrl + '/${_createUrl([path, methodPath])}';
        final method = '$methodName';
        final headers = $headersJson;
        final request = Request(method, Uri.parse(url));
        request.headers.addEntries(headers.entries);
        final response = await _client.send(request);
        final body = await response.stream.bytesToString();
        return $returnType.fromJson(jsonDecode(body));
      ''');
      b.annotations.add(CodeExpression(Code('override')));
      b.name = name;
      b.modifier = MethodModifier.async;
      b.body = body;
      b.requiredParameters.addAll([]);
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
      c.optionalParameters.add(_generateParameter('baseUrl', true));
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
      final annotation = _typeChecker(type)
          .firstAnnotationOf(element, throwOnUnresolved: false);
      if (annotation != null) {
        return ConstantReader(annotation);
      }
    }
    return null;
  }

  _getHeadersAnnotation(MethodElement element) {
    final annotation = _typeChecker(Headers)
        .firstAnnotationOf(element, throwOnUnresolved: false);
    if (annotation != null) {
      return ConstantReader(annotation);
    }
    return null;
  }

  TypeChecker _typeChecker(Type type) => TypeChecker.fromRuntime(type);

  String _createUrl(Iterable<String> parts) =>
      parts.where((element) => element.isNotEmpty).join('/');

  DartType _genericOf(DartType type) {
    return type is InterfaceType && type.typeArguments.isNotEmpty
        ? type.typeArguments.first
        : null;
  }
}

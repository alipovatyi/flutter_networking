import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:flutternetworking/generator/rest_annotations.dart';
import 'package:source_gen/source_gen.dart';

class RestGenerator extends GeneratorForAnnotation<ApiService> {
  final _methodAnnotations = const [GET, POST, PUT];

  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final servicePath = _parseServicePath(annotation);
    final cl = Class((c) {
      c.name = '_${element.name}';
      c.implements.add(refer(element.name));
      c.fields.add(_createFinalField('_client', 'RestClient'));
      c.methods.addAll(_generateMethods(element as ClassElement, servicePath));
      c.constructors.add(_generateConstructor());
    });

    return DartFormatter().format('${cl.accept(DartEmitter())}');
  }

  List<Method> _generateMethods(ClassElement element, String servicePath) =>
      element.methods
          .map((e) => _generateMethod(_getMethod(e), servicePath))
          .toList();

  _MethodToGenerate _getMethod(MethodElement element) {
    final name = element.name;
    final returnType = _genericOf(element.returnType);
    final parameters = _generateMethodParameters(element);
    final restMethod = _parseRestMethod(element);
    final headers = _parseHeaders(element);
    final url = _parseUrlParameter(element);
    final pathParams = _parsePathParameters(element);
    final queryParams = _parseQueryParameters(element);
    final body = _parseBodyParameter(element);
    return _MethodToGenerate(name, returnType, parameters, restMethod, headers,
        url, pathParams, queryParams, body);
  }

  Method _generateMethod(_MethodToGenerate element, String servicePath) {
    final returnType = element.returnType;
    final methodType = element.restMethod.type;
    final methodPath = element.restMethod.path;
    final headers = element.headers;
    final urlParam = element.url?.parameterName;
    final pathParameters = element.pathParameters;
    final queryParameters = element.queryParameters;
    final requestBody = element.body != null
        ? 'jsonEncode(${element.body.parameterName})'
        : null;
    var path = '';
    if (servicePath != null && servicePath.isNotEmpty) {
      path = '/$servicePath';
    }
    if (methodPath != null && methodPath.isNotEmpty) {
      path = path + '/$methodPath';
    }
    final block = Block.of([
      Code("var _url = '\${_client.baseUrl}$path';"),
      if (urlParam != null) Code("""
      _url = $urlParam.startsWith(RegExp('https?://')) ? $urlParam : '\$_url/\$$urlParam';"""),
      if (urlParam == null && pathParameters.isNotEmpty) Code("""
      final _pathParameters = $pathParameters;
      _pathParameters.forEach((k, v) => _url = _url.replaceFirst('{\$k}', v));"""),
      Code('var _uri = Uri.parse(_url);'),
      if (urlParam == null && queryParameters.isNotEmpty) Code("""
      final _queryParameters = $queryParameters;
      _uri = _uri.replace(queryParameters: _queryParameters);"""),
      Code("final _request = Request('$methodType', _uri);"),
      if (headers.isNotEmpty) Code("""
      final _headers = $headers;
      _request.headers.addEntries(_headers.entries);"""),
      if (requestBody != null) Code("_request.body = $requestBody;"),
      Code("final _response = await _client.send(_request);"),
      Code("return $returnType.fromJson(jsonDecode(_response.body));"),
    ]);
    final method = Method((m) {
      m.annotations.add(CodeExpression(Code('override')));
      m.name = element.name;
      m.requiredParameters.addAll(element.parameters.where((e) => !e.named));
      m.optionalParameters.addAll(element.parameters.where((e) => e.named));
      m.modifier = MethodModifier.async;
      m.body = block;
    });
    return method;
  }

  String _parseServicePath(ConstantReader annotation) =>
      annotation.peek('path').stringValue;

  _RestMethod _parseRestMethod(MethodElement element) {
    for (final type in _methodAnnotations) {
      final annotation = _getAnnotation(element, type);
      if (annotation != null) {
        final reader = ConstantReader(annotation);
        final method = reader.peek('name').stringValue;
        final path = reader.peek('path').stringValue;
        return _RestMethod(method, path);
      }
    }
    return null;
  }

  _Url _parseUrlParameter(MethodElement element) {
    var url;
    element.parameters.forEach((param) {
      if (_getAnnotation(param, Url) != null) {
        url = _Url(param.name);
      }
    });
    return url;
  }

  _Body _parseBodyParameter(MethodElement element) {
    var body;
    element.parameters.forEach((param) {
      if (_getAnnotation(param, Body) != null) {
        body = _Body(param.name);
      }
    });
    return body;
  }

  Map _parsePathParameters(MethodElement element) {
    final map = {};
    element.parameters.forEach((param) {
      final annotation = _getAnnotation(param, Path);
      if (annotation == null) return;
      final reader = ConstantReader(annotation);
      final name = reader.peek('value').stringValue;
      map.putIfAbsent(literal(name), () => param.name);
    });
    return map;
  }

  Map<dynamic, dynamic> _parseQueryParameters(MethodElement element) {
    final map = {};
    element.parameters.forEach((param) {
      final annotation = _getAnnotation(param, Query);
      if (annotation == null) return;
      final reader = ConstantReader(annotation);
      final name = reader.peek('name').stringValue;
      map.putIfAbsent(literal(name), () => param.name);
    });
    return map;
  }

  Map<dynamic, dynamic> _parseHeaders(MethodElement element) {
    final annotation = _getAnnotation(element, Headers);
    if (annotation == null) return {};
    final reader = ConstantReader(annotation);
    final map = <dynamic, dynamic>{};
    reader.peek('headers').mapValue.forEach((k, v) {
      map[literal(k.toStringValue())] = literal(v.toStringValue());
    });
    return map;
  }

  _generateMethodParameters(MethodElement element) {
    return element.parameters
        .map(
          (e) => Parameter((p) {
            p.name = e.name;
            p.named = e.isNamed;
            p.type = refer(e.type.toString()).type;
            p.defaultTo = Code(e.defaultValueCode);
          }),
        )
        .toList();
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

  _getAnnotation(Element element, dynamic annotation) =>
      _typeChecker(annotation)
          .firstAnnotationOf(element, throwOnUnresolved: false);

  TypeChecker _typeChecker(Type type) => TypeChecker.fromRuntime(type);

  DartType _genericOf(DartType type) {
    return type is InterfaceType && type.typeArguments.isNotEmpty
        ? type.typeArguments.first
        : null;
  }
}

class _MethodToGenerate {
  final String name;
  final DartType returnType;
  final List<Parameter> parameters;
  final _RestMethod restMethod;
  final Map<dynamic, dynamic> headers;
  final _Url url;
  final Map<dynamic, dynamic> pathParameters;
  final Map<dynamic, dynamic> queryParameters;
  final _Body body;

  const _MethodToGenerate(
    this.name,
    this.returnType,
    this.parameters,
    this.restMethod,
    this.headers,
    this.url,
    this.pathParameters,
    this.queryParameters,
    this.body,
  );
}

class _RestMethod {
  final String type;
  final String path;

  const _RestMethod(this.type, this.path);
}

abstract class _Parameter {
  final String parameterName;

  const _Parameter(this.parameterName);
}

class _Url extends _Parameter {
  const _Url(String parameterName) : super(parameterName);
}

class _Body extends _Parameter {
  const _Body(String parameterName) : super(parameterName);
}

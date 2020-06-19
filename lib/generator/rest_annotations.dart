class ApiService {
  final String path;

  const ApiService({this.path = ''}) : assert(path != null);
}

abstract class RestMethod {
  final String name;
  final String path;

  const RestMethod(this.name, this.path)
      : assert(name != null),
        assert(path != null);
}

class GET extends RestMethod {
  const GET(String path) : super('GET', path);
}

class POST extends RestMethod {
  const POST(String path) : super('POST', path);
}

class PUT extends RestMethod {
  const PUT(String path) : super('PUT', path);
}

class Headers {
  final Map<String, String> headers;

  const Headers(this.headers) : assert(headers != null);
}

class Body {
  const Body();
}

class Url {
  const Url();
}

class Path {
  final String value;

  const Path(this.value) : assert(value != null);
}

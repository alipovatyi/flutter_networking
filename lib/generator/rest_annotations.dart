class ApiService {
  final String path;

  const ApiService({this.path = ''}) : assert(path != null);
}

abstract class RestMethod {
  const RestMethod(this.name, this.path)
      : assert(name != null),
        assert(path != null);

  final String name;
  final String path;
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

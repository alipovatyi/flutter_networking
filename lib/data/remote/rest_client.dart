import 'package:http/http.dart';

typedef Interceptor = Function(Request request);

class RestClient {
  RestClient({
    String baseUrl,
    Client client,
    Map<String, String> defaultHeaders,
    List<Interceptor> requestInterceptors,
  })  : baseUrl = baseUrl ?? '',
        _client = client ?? Client(),
        _defaultHeaders = defaultHeaders ?? {},
        _requestInterceptors = requestInterceptors ?? [];

  final Client _client;
  final String baseUrl;
  final Map<String, String> _defaultHeaders;
  final List<Interceptor> _requestInterceptors;

  Future<StreamedResponse> send(Request request) async {
    request.headers.addAll(_defaultHeaders);
    _requestInterceptors.forEach((element) => element(request));
    return _client.send(request);
  }
}

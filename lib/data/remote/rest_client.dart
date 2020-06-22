import 'package:http/http.dart';

abstract class RequestInterceptor {
  Request intercept(Request request);
}

abstract class ResponseInterceptor {
  Response intercept(Response response);
}

class RestClient {
  RestClient({
    String baseUrl,
    Client client,
    Map<String, String> defaultHeaders,
    List<RequestInterceptor> requestInterceptors,
    List<ResponseInterceptor> responseInterceptors,
  })  : baseUrl = baseUrl ?? '',
        _client = client ?? Client(),
        _defaultHeaders = defaultHeaders ?? {},
        _requestInterceptors = requestInterceptors ?? [],
        _responseInterceptors = responseInterceptors ?? [];

  final Client _client;
  final String baseUrl;
  final Map<String, String> _defaultHeaders;
  final List<RequestInterceptor> _requestInterceptors;
  final List<ResponseInterceptor> _responseInterceptors;

  Future<Response> send(Request request) async {
    request.headers.addAll(_defaultHeaders);
    _requestInterceptors.forEach((i) => i.intercept(request));
    final streamedResponse = await _client.send(request);
    final response = await Response.fromStream(streamedResponse);
    _responseInterceptors.forEach((i) => i.intercept(response));
    return response;
  }
}

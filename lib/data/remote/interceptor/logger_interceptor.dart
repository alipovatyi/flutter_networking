import 'package:flutternetworking/data/remote/rest_client.dart';
import 'package:http/http.dart';

class LoggerRequestInterceptor implements RequestInterceptor {
  @override
  Request intercept(Request request) {
    print('--> ${request.method} ${request.url}');
    print('--> Headers: ${request.headers}');
    print('--> Body: ${request.body}');
    return request;
  }
}

class LoggerResponseInterceptor implements ResponseInterceptor {
  @override
  Response intercept(Response response) {
    print('<-- Status code: ${response.statusCode}');
    print('<-- ${response.body}');
    return response;
  }
}

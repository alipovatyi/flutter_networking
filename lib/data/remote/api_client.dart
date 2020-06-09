import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient(this._client, this._baseUrl)
      : assert(_client != null),
        assert(_baseUrl != null);

  final http.Client _client;
  final String _baseUrl;

  Future<http.Response> get(String path) async {
    return _client.get('$_baseUrl/$path');
  }
}

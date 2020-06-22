import 'package:flutternetworking/data/remote/rest_client.dart';
import 'package:flutternetworking/generator/rest_service.dart';
import 'package:http/http.dart';

export 'dart:convert';

Uri $createUri({
  String baseUrl,
  String servicePath,
  String methodPath,
  String urlParam,
  Map<String, dynamic> pathParameters,
  Map<String, dynamic> queryParameters,
}) {
  var url = baseUrl;
  if (servicePath != null && servicePath.isNotEmpty) {
    url = '$url/$servicePath';
  }
  if (methodPath != null && methodPath.isNotEmpty) {
    url = '$url/$methodPath';
  }
  if (urlParam != null) {
    url = _$shouldOverrideUrl(urlParam) ? urlParam : '$url/$urlParam';
    return Uri.parse(url);
  } else {
    var uri = Uri.parse(url);
    if (queryParameters.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParameters);
    }
    return uri;
  }
}

Request $createRequest({
  String method,
  Uri uri,
  Map<String, String> headers,
  String body,
}) {
  final request = Request(method, uri);
  request.headers.addEntries(headers.entries);
  if (body != null) {
    request.body = body;
  }
  return Request(method, uri);
}

makeRequest(RestClient client, Request request, dynamic type) async {
  final response = await client.send(request);
  return type.fromJson(jsonDecode(response.body));
}

bool _$shouldOverrideUrl(String url) => url.startsWith(RegExp('https?://'));

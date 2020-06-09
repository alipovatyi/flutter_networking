import 'dart:io';

import 'package:http/http.dart';

Future<Response> createResponse({String body, String fileName, int statusCode = HttpStatus.ok}) async {
  assert(body != null || fileName != null);
  return Response(body ?? await File(fileName).readAsString(), statusCode);
}

import 'dart:io';

import 'package:http/http.dart';

Response createResponse({
  String body,
  String fileName,
  int statusCode = HttpStatus.ok
}) {
  assert(body != null || fileName != null);
  final path = '../test_resources/$fileName';
  return Response(body ?? File(path).readAsStringSync(), statusCode);
}

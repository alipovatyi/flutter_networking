import 'dart:io';

import 'package:http/http.dart';

import '../../../util/test_utils.dart';

Response createResponse({
  String body,
  String fileName,
  int statusCode = HttpStatus.ok,
}) {
  assert(body != null || fileName != null);
  return Response(body ?? readTestResource(fileName), statusCode);
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;

Widget buildTestableWidget(Widget widget) {
  return new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: widget),
  );
}

final testResourcesDirectory = join(
  Directory.current.path,
  Directory.current.path.endsWith('test') ? '..' : '',
  'test_resources',
);

String readTestResource(String fileName) {
  assert(fileName != null);
  final path = '$testResourcesDirectory/$fileName';
  return File(path).readAsStringSync();
}

Response createChopperResponse({
  String body,
  String fileName,
  int statusCode = HttpStatus.ok
}) {
  assert(body != null || fileName != null);
  final bodyString = body ?? readTestResource(fileName);
  final response = createHttpResponse(body: bodyString, statusCode: statusCode);
  return Response(response, bodyString);
}

http.Response createHttpResponse({
  String body,
  String fileName,
  int statusCode = HttpStatus.ok
}) {
  assert(body != null || fileName != null);
  final bodyString = body ?? readTestResource(fileName);
  return http.Response(bodyString, statusCode);
}

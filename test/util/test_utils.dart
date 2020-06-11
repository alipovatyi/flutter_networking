import 'dart:convert';
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

Response<T> createChopperResponse<T>({
  String body,
  String fileName,
  Function mapper,
  int statusCode = HttpStatus.ok
}) {
  assert(body != null || fileName != null);
  final bodyString = body ?? readTestResource(fileName);
  final response = createHttpResponse(body: bodyString, statusCode: statusCode);
  final mapped = mapper?.call(jsonDecode(bodyString)) ?? jsonDecode(bodyString);
  return Response<T>(response, mapped);
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

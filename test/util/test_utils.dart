import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Widget buildTestableWidget(Widget widget) {
  return new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: widget),
  );
}

Response<T> createChopperResponse<T>({
  String body,
  String fileName,
  Function mapper,
  int statusCode = HttpStatus.ok
}) {
  assert(body != null || fileName != null);
  final path = '../test_resources/$fileName';
  final bodyString = body ?? File(path).readAsStringSync();
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
  final path = '../test_resources/$fileName';
  final bodyString = body ?? File(path).readAsStringSync();
  return http.Response(bodyString, statusCode);
}

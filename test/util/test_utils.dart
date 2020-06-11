import 'dart:io';

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:mockito/mockito.dart';

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

Response<Map<String, dynamic>> createHttpResponse({
  String body,
  String fileName,
  int statusCode = HttpStatus.ok,
}) {
  assert(body != null || fileName != null);
  final bodyString = body ?? readTestResource(fileName);
  return Response(data: jsonDecode(bodyString), statusCode: statusCode);
}

extension MockResponse on Dio {
  void mock(String path, {String responseBody, String responsePath}) {
    final response = createHttpResponse(
      body: responseBody,
      fileName: responsePath,
    );
    when(request(
      path,
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
      data: anyNamed('data'),
    )).thenAnswer((_) async => response);
  }
}
